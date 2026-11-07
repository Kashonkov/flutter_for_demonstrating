import 'package:common/bloc/bloc.dart';
import 'package:common/exception/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:lxe_app/l10n/app_localizations.dart';
import 'package:lxe_app/router/app_router.dart';
import 'package:ui_kit/bottom_sheet/error_bottom_sheet.dart';
import 'package:ui_kit/bottom_sheet/ui_bottom_sheet.dart';

class BlocNewsHandlerImpl implements BlocNewsHandler {
  final ErrorHandler errorHandler;
  final AppRouter router;

  BlocNewsHandlerImpl({required this.errorHandler, required this.router});

  @override
  Future<void> onNewsReceived(BuildContext context, BlocNews news) async {
    final localization = AppLocalizations.of(context);
    if (news is ErrorBlocNews) {
      final errorMessage = errorHandler.proceed(context, news.exception);
      showUiModalBottomSheet(
        barrierColor: Colors.grey,
        context: context,
        useRootNavigator: true,
        builder: (context) => ErrorBottomSheet(
          title: localization.requestError,
          description: errorMessage.message,
          buttonText: localization.close,
          onTap: () => router.maybePop(),
        ),
      );
    } else if (news is ErrorWithPopBlocNews) {
      final errorMessage = errorHandler.proceed(context, news.exception);
      showUiModalBottomSheet(
        barrierColor: Colors.grey,
        context: context,
        useRootNavigator: true,
        builder: (context) => ErrorBottomSheet(
          title: localization.requestError,
          description: errorMessage.message,
          buttonText: localization.back,
          onTap: () => router.maybePop(),
        ),
      ).then((_) => router.back());
    } else if (news is RetryErrorBlocNews) {
      final errorMessage = errorHandler.proceed(context, news.exception);
      showUiModalBottomSheet(
        barrierColor: Colors.grey,
        context: context,
        useRootNavigator: true,
        builder: (context) => ErrorBottomSheet(
          title: localization.requestError,
          description: errorMessage.message,
          buttonText: localization.retry,
          onTap: () {
            router.maybePop();
            news.retry();
          },
        ),
      );
    }
  }
}
