import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

const headerUserAgent = "User-Agent";
const headerTimeZone = "X-Timezone-Offset";
const headerTimeZoneName = "X-Timezone-Name";

const userAgentBuildVersion = "buildVersion";
const bundleId = "bundleId";
const userAgentBuildNumber = "buildNumber";
const userAgentPlatform = "platform";
const deviceId = "deviceId";

class UserAgentInterceptor extends Interceptor {
  UserAgentInterceptor();

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll(await _getUserAgent());
    super.onRequest(options, handler);
  }

  Future<Map<String, String>> _getUserAgent() async {
    final userAgentData = await _getUserAgentData();
    return {
      headerUserAgent: jsonEncode(userAgentData),
      headerTimeZone: _getTimezoneOffset(),
      headerTimeZoneName: _getTimezoneName(),
    };
  }

  String _getTimezoneOffset() {
    return DateTime.now().timeZoneOffset.inMinutes.toString();
  }

  String _getTimezoneName() {
    return DateTime.now().timeZoneName;
  }

  Future<Map<String, String>> _getUserAgentData() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final userAgent = {
      userAgentPlatform: '${Platform.operatingSystem}/${Platform.operatingSystemVersion}',
      userAgentBuildVersion: packageInfo.version,
      userAgentBuildNumber: packageInfo.buildNumber,
      bundleId: packageInfo.packageName,
    };

    return userAgent;
  }
}
