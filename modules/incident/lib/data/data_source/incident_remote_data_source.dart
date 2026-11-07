import 'dart:async';
import 'dart:io';

import 'package:api/config/api_config.dart';
import 'package:api/exception/error_handler.dart';
import 'package:api/jwt/domain/use_case/get_access_token_use_case.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:common/index.dart';
import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:external_path/external_path.dart';
import 'package:incident/data/api/incident_api.dart';
import 'package:incident/data/api/incident_file_api.dart';
import 'package:incident/data/model/incident_list_request.dart';

abstract interface class IncidentRemoteDataSource {
  Future<List<IncidentEntity>> getIncidents({String? query, required int page});

  Future<void> downloadReport(String id);

  Future<String> downloadSharingReport(String id);
}

const _requestAmount = 20;

final class IncidentRemoteDataSourceImpl implements IncidentRemoteDataSource {
  final IncidentApi _api;
  final IncidentFileApi _fileApi;
  final ApiConfig apiConfig;
  final GetAccessTokenUseCase getAccessTokenUseCase;

  IncidentRemoteDataSourceImpl(
    this._api,
    this.apiConfig,
    this.getAccessTokenUseCase,
    this._fileApi,
  );

  @override
  Future<List<IncidentEntity>> getIncidents({String? query, required int page}) async {
    final hasQuery = query != null && query.isNotEmpty;
    final request = IncidentListRequest(
      query: hasQuery ? query : null,
      page: page,
      pageSize: _requestAmount,
    );
    final result = await checkNetErrors(() => _api.getIncidentList(request));
    final items = result.items;
    return items.map((item) => item.toEntity()).toList();
  }

  @override
  Future<void> downloadReport(String id) async {
    final accessToken = getAccessTokenUseCase(EmptyUsecaseParams());
    final token = accessToken.result?.token;

    if (!accessToken.isSuccessful || token == null) {
      return;
    }

    final requestPath = '${apiConfig.baseConfig.url}/api/incident/$id/report';

    if (Platform.isAndroid) {
      var status = await FileDownloader().permissions.status(PermissionType.notifications);

      if (status != PermissionStatus.granted) {
        status = await FileDownloader().permissions.request(PermissionType.notifications);
      }

      FileDownloader().configureNotification(
        running: const TaskNotification('Downloading', 'Downloading {filename}'),
        complete: const TaskNotification('Downloaded', '{filename} has been downloaded.'),
        error: const TaskNotification('Download failed', 'Couldn’t download {filename}.'),
        tapOpensFile: true,
        progressBar: true,
      );
    }

    late final DownloadTask task;

    if (Platform.isAndroid) {
      final downloadsPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD,
      );

      task = DownloadTask(
        url: requestPath,
        httpRequestMethod: 'POST',
        headers: {'Authorization': 'Bearer $token'},
        filename: '$id.pdf',
        directory: downloadsPath,
        baseDirectory: BaseDirectory.root,
        requiresWiFi: false,
        retries: 5,
        allowPause: false,
        updates: Updates.statusAndProgress,
      );
    } else {
      task = DownloadTask(
        url: requestPath,
        httpRequestMethod: 'POST',
        headers: {'Authorization': 'Bearer $token'},
        filename: '$id.pdf',
        baseDirectory: BaseDirectory.applicationDocuments,
        directory: 'reports',
        requiresWiFi: false,
        retries: 5,
        allowPause: false,
        updates: Updates.statusAndProgress,
      );
    }

    final result = await FileDownloader().download(task);

    if (result.status != TaskStatus.complete) {
      final errorText = result.exception?.description ?? result.status.toString();
      throw Exception('Download failed: $errorText');
    }

    if (Platform.isIOS) {
      await FileDownloader().openFile(task: task, mimeType: 'application/pdf');
    }
  }

  @override
  Future<String> downloadSharingReport(String id) {
    return checkNetErrors(() => _fileApi.downloadIncidentReport(id));
  }
}
