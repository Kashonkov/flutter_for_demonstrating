import 'package:common/bloc/bloc_news_mixin.dart';
import 'package:common/bloc/news.dart';
import 'package:common/bloc/use_case_processor_mixin.dart';
import 'package:common/exception/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<StateT> extends Cubit<StateT> with BlocNewsMixin, UseCaseProcessorMixin {
  BaseCubit(super.initialState) {
    initProcessor();
  }

  void emitIfNotClosed(StateT state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  @override
  void addNews(BlocNews news) {
    if (!isClosed) {
      super.addNews(news);
    }
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    await closeProcessor();
    return super.close();
  }
}
