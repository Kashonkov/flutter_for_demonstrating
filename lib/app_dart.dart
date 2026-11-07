import 'package:auth/l10n/auth_localizations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:incident/l10n/incident_localizations.dart';
import 'package:lxe_app/router/app_router.dart';
import 'package:order/l10n/order_localizations.dart';
import 'package:profile/l10n/profile_localizations.dart';
import 'package:shipment/l10n/shipment_localizations.dart';
import 'package:ui_kit/l10n/common_localizations.dart';
import 'package:ui_kit/theme/text_theme.dart';

import 'l10n/app_localizations.dart';

class MainApp extends StatelessWidget {
  final AppRouter router;

  const MainApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = TextStyle(fontFamily: 'Balsamiq');
    TextStyle titleStyle = TextStyle(fontFamily: 'SF');
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router.config(
        deepLinkBuilder: (_) {
          return DeepLink.defaultPath;
        },
        navigatorObservers: () => [AutoRouteObserver()],
      ),
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(surface: Color(0xFFFCFCFC)),
        scaffoldBackgroundColor: Color(0xFFF2F2F2),
        appBarTheme: AppBarThemeData(
          backgroundColor: Color(0xFFF2F2F2),
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        extensions: [
          TextThemeExtension(
            body1: baseStyle.copyWith(
              color: Color(0xFF000000),
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            body1Variant: baseStyle.copyWith(
              color: Color(0xFF000000),
              fontSize: 16,
              height: 20 / 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            subtitle1: baseStyle.copyWith(
              color: Color(0xFF222222),
              fontSize: 16,
              height: 20 / 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            body2: baseStyle.copyWith(
              color: Color(0x80000000),
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            body2Variant: baseStyle.copyWith(
              color: Color(0xFF000000),
              fontSize: 14,
              height: 18 / 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            body3: baseStyle.copyWith(
              color: Color(0xB2000000),
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            body4: baseStyle.copyWith(
              color: Color(0xB2000000),
              fontSize: 10,
              height: 16 / 10,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5,
            ),
            header1: baseStyle.copyWith(
              color: Color(0xFF1A1A1A),
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
            caption: baseStyle.copyWith(
              color: Color(0xFF1A1A1A),
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            button: baseStyle.copyWith(
              fontSize: 14,
              height: 16 / 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            largeTitle: titleStyle.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 34,
              height: 41 / 34,
              letterSpacing: 0.4,
            ),
            smallTitle: titleStyle.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 18 / 14,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        AuthLocalizations.delegate,
        CommonLocalizations.delegate,
        IncidentLocalizations.delegate,
        OrderLocalizations.delegate,
        ProfileLocalizations.delegate,
        ShipmentLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, widget) {
        return MediaQuery.withNoTextScaling(child: widget ?? SizedBox.shrink());
      },
    );
  }
}
