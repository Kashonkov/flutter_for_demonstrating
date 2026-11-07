import 'dart:async';

import 'package:common/bloc/news.dart';
import 'package:common/exception/error_handler.dart';
import 'package:flutter/foundation.dart';

/// Миксин для добавления событий в bloc
mixin BlocNewsMixin {
  final StreamController<BlocNews> newsController = StreamController.broadcast();
  late Stream<BlocNews> newsStream;

  void addNews(BlocNews news) {
    newsController.add(news);
  }

  @protected
  void onFailure(Exception exception) {
    addNews(ErrorBlocNews(exception));
  }
}
