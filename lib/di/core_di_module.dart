import 'package:common/bloc/bloc.dart';
import 'package:common/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:lxe_app/bloc/bloc_news_handler_impl.dart';
import 'package:lxe_app/bloc/default_error_handler.dart';

final class CoreDiModule extends BaseDIModule {
  @override
  void updateInjections(GetIt instance) {
    instance.registerFactory<BlocNewsHandler>(
      () => BlocNewsHandlerImpl(errorHandler: DefaultErrorHandler(), router: getIt()),
    );
  }
}
