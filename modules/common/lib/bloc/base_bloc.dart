import 'package:common/bloc/bloc_news_mixin.dart';
import 'package:common/bloc/news.dart';
import 'package:common/bloc/use_case_processor_mixin.dart';
import 'package:common/exception/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

EventTransformer<Event> sequential<Event>() {
  return (events, mapper) => events.asyncExpand(mapper);
}

EventTransformer<Event> throttleTransformer<Event>(Duration duration) {
  return (events, mapper) => events.throttleTime(duration).switchMap(mapper);
}

EventTransformer<Event> debounceTransformer<Event>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

abstract class BaseBloc<EventT, StateT> extends Bloc<EventT, StateT> with BlocNewsMixin, UseCaseProcessorMixin {
  BaseBloc(
    super.initialState,) {
    initProcessor();
  }

  void emitIfNotClosed(Emitter<StateT> emitter, StateT state) {
    if (!isClosed) {
      emitter(state);
    }
  }

  void addIfNotClosed(EventT event) {
    if (!isClosed) {
      super.add(event);
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
