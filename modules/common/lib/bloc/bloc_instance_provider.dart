import 'dart:async';

import 'package:common/bloc/base_bloc.dart';
import 'package:common/bloc/base_cubit.dart';
import 'package:common/bloc/bloc_news_handler.dart';
import 'package:common/bloc/news.dart';
import 'package:common/di/get_it_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef BlocDelegate<T extends Bloc> = T Function();

abstract class StateWithBloc<T extends BaseBloc, P extends StatefulWidget> extends StateWithBlocBase<T, P> {
  @override
  String get _tag => 'StateWithBloc';

  @override
  Stream<BlocNews> get newsStream {
    if (!isInitialized) throw BlocNotInitializedException();

    return bloc.newsStream;
  }
}

abstract class StateWithCubit<T extends BaseCubit, P extends StatefulWidget> extends StateWithBlocBase<T, P> {
  @override
  String get _tag => 'StateWithCubit';

  @override
  Stream<BlocNews> get newsStream {
    if (!isInitialized) throw BlocNotInitializedException();

    return bloc.newsStream;
  }
}

/// Класс с общей логикой для 2 подклассов: StateWithBLoc и StateWithCubit. Напрямую от него
/// наследоваться не нужно
abstract class StateWithBlocBase<T extends BlocBase, P extends StatefulWidget> extends State<P> {
  late T bloc;

  StreamSubscription? _subscription;

  bool _isInitialized = false;

  String get _tag => 'StateWithBlocBase';

  /// Геттер для получения стрима из [bloc]. Определяется в StateWithBLoc и StateWithCubit.
  Stream<BlocNews> get newsStream;

  bool get isInitialized => _isInitialized;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    try {
      bloc = BlocProvider.of<T>(context);
      _isInitialized = true;
      _subscription = newsStream.listen((event) => onNewsReceived(event));
    } catch (e) {
      debugPrint('$_tag initState error: $e');
    }
  }

  @override
  @mustCallSuper
  void dispose() {
    _subscription?.cancel();
    closeBloc();
    super.dispose();
  }

  void closeBloc() {
    if (_isInitialized) {
      bloc.close();
    }
  }

  void onNewsReceived(BlocNews news) async {
    BlocNewsHandler? handler;
    try {
      handler = getIt<BlocNewsHandler>();
    } catch (_) {
      debugPrint('$_tag implementation of BlocNewsHandler not registered');
    }
    handler?.onNewsReceived(context, news);
  }
}

/// Блок не создан
class BlocNotInitializedException implements Exception {}
