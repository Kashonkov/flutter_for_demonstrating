import 'dart:convert';
import 'dart:math' as math;

import 'package:common/bloc/base_bloc.dart';
import 'package:common/utils/geo_utils.dart';
import 'package:common/utils/string_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipment/domain/entity/connection_status.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:shipment/domain/entity/route_point_entity.dart';
import 'package:shipment/domain/entity/shipment_entity.dart';
import 'package:shipment/domain/use_case/complete_shipment_use_case.dart';
import 'package:shipment/domain/use_case/get_shipment_route_use_case.dart';
import 'package:shipment/domain/use_case/get_shipment_use_case.dart';
import 'package:shipment/navigation/shipment_navigator.dart';
import 'package:shipment/presentation/shipment_bus/shipment_bus.dart';
import 'package:shipment/presentation/shipment_details/bloc/shipment_details_event.dart';
import 'package:shipment/presentation/shipment_details/bloc/shipment_details_state.dart';
import 'package:shipment/presentation/shipment_details/model/route_model.dart';
import 'package:shipment/presentation/shipment_details/model/shipment_presentation_model.dart';
import 'package:shipment/presentation/shipment_details/model/timeline_point.dart';

final class ShipmentDetailsBloc extends BaseBloc<ShipmentDetailsEvent, ShipmentDetailsState> {
  final String shipmentId;
  final GetShipmentUseCase getShipmentUseCase;
  final GetShipmentRouteUseCase getShipmentRouteUseCase;
  final CompleteShipmentUseCase completeShipmentUseCase;
  final ShipmentBusController busController;
  final ShipmentNavigator navigator;

  ShipmentEntity? _shipment;
  List<RoutePointEntity>? _route;
  TimelineModel? _timeline;

  ShipmentDetailsBloc({
    required this.shipmentId,
    required this.getShipmentUseCase,
    required this.getShipmentRouteUseCase,
    required this.completeShipmentUseCase,
    required this.busController,
    required this.navigator,
  }) : super(LoadingState()) {
    on<OnInitialEvent>(_onInit);
    on<OnCompleteTapEvent>(_onCompleteTap);
    on<OnOpenIncidentTapEvent>(_onOpenIncidentTap);
    on<OnTimeProgressChangeEvent>(
      _onTimeProgressChange,
      transformer: debounceTransformer(Duration(milliseconds: 300)),
    );

    add(OnInitialEvent());
  }

  Future<void> _onInit(OnInitialEvent event, Emitter emit) async {
    await _getShipmentDetails(shipmentId, emit);
    await _getShipmentRoute(shipmentId, emit);
  }

  Future<void> _onTimeProgressChange(OnTimeProgressChangeEvent event, Emitter emit) async {
    final timeline = _timeline;
    if (timeline == null) return;
    final startTime = timeline.startDate;
    final endTime = timeline.endDate;
    final timePosition = event.value / 100;
    final milliseconds =
        (endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch) * timePosition;
    final thresholdTime = startTime.add(
      Duration(milliseconds: milliseconds.toInt() + 60 + 60 + 1000),
    );
    final route = (_route ?? [])
        .where((point) => point.position.time.isBefore(thresholdTime))
        .toList();
    _showData(_shipment, route, _timeline, emit);
  }

  Future<void> _getShipmentDetails(String shipmentId, Emitter emit) async {
    await processUseCase(
          () => getShipmentUseCase(shipmentId),
      onSuccess: (result) {
        _shipment = result;
        _showData(_shipment, _route, _timeline, emit);
      },
      onError: (error) {
        handleUseCaseError(error);
        emit(IdleState());
      },
    );
  }

  Future<void> _getShipmentRoute(String shipmentId, Emitter emit) async {
    await processUseCase(
          () => getShipmentRouteUseCase(GetShipmentRouteUseCaseParams(shipmentId: shipmentId)),
      onSuccess: (result) {
        _route = result;
        _timeline = _mapTimeline(result);
        _showData(_shipment, _route, _timeline, emit);
      },
    );
  }

  void _onOpenIncidentTap(OnOpenIncidentTapEvent event, Emitter emit) {
    navigator.navigateToIncident(event.incident);
  }

  void _showData(ShipmentEntity? shipment,
      List<RoutePointEntity>? route,
      TimelineModel? timeline,
      Emitter emit,) {
    if (shipment == null) return;
    RouteModel? routeModel;
    if (route != null && timeline != null) {
      routeModel = RouteModel(
        mapPoints: _pointsToGeoJson(route),
        mapLines: _routeLineToGeoJson(route),
        mapPolygons: _pointRangesToGeoJson(route),
        points: route,
        timeline: timeline,
      );
    }
    emit(
      DataState(
        model: _map(shipment),
        routeModel: routeModel,
        isCompleteVisible: shipment.deliveryStatus == DeliveryStatus.transit,
      ),
    );
  }

  Future<void> _onCompleteTap(OnCompleteTapEvent event, Emitter emit) async {
    emit(LoadingState());
    bool isCompleted = false;
    await processUseCase(
          () =>
          completeShipmentUseCase(
            CompleteShipmentsUseCaseParams(shipmentId, event.address, event.comment, event.status),
          ),
      onSuccess: (shipment) {
        isCompleted = true;
        busController.addEvent(ShipmentCompletedEvent(shipmentId));
        _shipment = shipment;
        emit(
          DataState(
            model: _map(shipment),
            isCompleteVisible: shipment.deliveryStatus == DeliveryStatus.transit,
          ),
        );
      },
      onError: (error) {
        handleUseCaseError(error);
        _showData(_shipment, _route, _timeline, emit);
      },
    );
    if (isCompleted) {
      await _getShipmentRoute(shipmentId, emit);
    }
  }

  // Процент где на таймллайне находятся точки инцедентов
  TimelineModel? _mapTimeline(List<RoutePointEntity> route) {
    if (route.isEmpty) return null;
    route.sort((first, second) => first.position.time.compareTo(second.position.time));
    final startDate = route.first.position.time;
    final endDate = route.last.position.time;

    OriginTimelinePoint? origin;
    DestinationTimelinePoint? destination;
    CurrentTimelinePoint? current;
    final List<IncidentTimelinePoint> incidentTimePosition = [];

    final period = (endDate.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch).clamp(
        1, double.maxFinite);

    for (final point in route) {
      final pointDate = point.position.time;
      final pointTimePosition =
          (pointDate.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch) / period;
      if (point is IncidentPointEntity) {
        incidentTimePosition.add(
          IncidentTimelinePoint(timeProgress: pointTimePosition, point: point),
        );
      } else if (point is OriginPointEntity) {
        origin = OriginTimelinePoint(timeProgress: pointTimePosition, point: point);
      } else if (point is DestinationPointEntity) {
        destination = DestinationTimelinePoint(timeProgress: pointTimePosition, point: point);
      } else if (point is CurrentPointEntity) {
        current = CurrentTimelinePoint(timeProgress: pointTimePosition, point: point);
      }
    }

    return TimelineModel(
      startDate: startDate,
      endDate: endDate,
      originTimelinePoint: origin,
      destinationTimelinePoint: destination,
      incidentTimelinePoint: incidentTimePosition,
      currentTimelinePoint: current,
    );
  }

  ShipmentPresentationModel _map(ShipmentEntity result) {
    return ShipmentPresentationModel(
      title: result.reference,
      address: result.currentPosition.title,
      deliveryStatus: result.deliveryStatus,
      updatedDate: result.currentPosition.time.format(),
      isGpsConnected: result.gpsStatus == ConnectionStatus.online,
      containerInfo: ContainerInfoPresentationModel(
        reference: result.reference,
        number: result.container,
      ),
      seals: result.seals
          .map(
            (seal) =>
            SealPresentationModel(
              title: seal.number,
              status: seal.status,
              type: seal.type,
              color: seal.color,
              isGpsConnected: seal.gpsStatus == ConnectionStatus.online,
              isConnected: seal.lteStatus == ConnectionStatus.online,
            ),
      )
          .toList(),
      originPosition: result.origin,
      currentPosition: result.currentPosition,
      stats: StatsPresentationModel(
        distance: result.distance,
        timeTotal: result.timeTotal,
        timeIdle: result.timeIdle,
        timeInMotion: result.timeInMotion,
        avgSpeed: result.avgSpeed,
        maxSpeed: result.maxSpeed,
      ),
    );
  }

  String _pointsToGeoJson(List<RoutePointEntity> points) {
    final features = points.map((s) {
      return {
        "type": "Feature",
        "id": s.id,
        "geometry": {
          "type": "Point",
          "coordinates": [s.position.longitude, s.position.latitude],
        },
        "properties": {"id": s.id, "type": _mapPointType(s)},
      };
    }).toList();

    return jsonEncode({"type": "FeatureCollection", "features": features});
  }

  String _mapPointType(RoutePointEntity point) {
    return switch (point) {
      OriginPointEntity() => "origin",
      DestinationPointEntity() => "destination",
      IncidentPointEntity() => "incident",
      WaypointEntity() => "waypoint",
      CurrentPointEntity() => "current",
    };
  }

  String _routeLineToGeoJson(List<RoutePointEntity> points) {
    final coordinates = points.map((p) => [p.position.longitude, p.position.latitude]).toList();

    // Если меньше 2 точек — линию рисовать нельзя
    if (coordinates.length < 2) {
      return jsonEncode({"type": "FeatureCollection", "features": <Map<String, dynamic>>[]});
    }

    return jsonEncode({
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "geometry": {"type": "LineString", "coordinates": coordinates},
          "properties": {},
        },
      ],
    });
  }

  String _pointRangesToGeoJson(List<RoutePointEntity> points) {
    final features = <Map<String, dynamic>>[];

    for (final p in points) {
      if (p is! IncidentPointEntity && p is! WaypointEntity) continue;

      double radiusMeters = 0;

      if (p is IncidentPointEntity) {
        radiusMeters = p.incident.accuracyInMeters?.toDouble() ?? 0;
      } else if (p is WaypointEntity) {
        radiusMeters = p.rangeInMeters;
      }

      if (radiusMeters <= 0) continue;

      final lon = p.position.longitude;
      final lat = p.position.latitude;

      final ring = buildGeodesicCircleRing(
        lon: lon,
        lat: lat,
        radiusMeters: radiusMeters.toDouble(),
        segments: 64, // можно 32/48/64
      );

      features.add({
        "type": "Feature",
        "geometry": {
          "type": "Polygon",
          "coordinates": [ring],
        },
        "properties": {
          "rangeType": _mapPointType(p), // "incident" / "waypoint"
          "radiusMeters": radiusMeters,
        },
      });
    }

    return jsonEncode({"type": "FeatureCollection", "features": features});
  }
}