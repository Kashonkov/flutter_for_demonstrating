import 'package:domain_core/domain/entity/position_entity.dart';
import 'package:shipment/domain/entity/delivery_status.dart';
import 'package:domain_core/domain/entity/seal_status.dart';

final class ShipmentPresentationModel {
  final String title;
  final bool isGpsConnected;
  final String updatedDate;
  final String address;
  final PositionEntity originPosition;
  final PositionEntity currentPosition;
  final ContainerInfoPresentationModel containerInfo;
  final List<SealPresentationModel> seals;
  final DeliveryStatus deliveryStatus;
  final StatsPresentationModel stats;

  ShipmentPresentationModel({
    required this.containerInfo,
    required this.seals,
    required this.title,
    required this.isGpsConnected,
    required this.updatedDate,
    required this.address,
    required this.originPosition,
    required this.currentPosition,
    required this.deliveryStatus,
    required this.stats,
  });
}

final class ContainerInfoPresentationModel {
  final String reference;
  final String? number;

  ContainerInfoPresentationModel({required this.reference, required this.number});
}

final class SealPresentationModel {
  final String title;
  final SealStatus status;
  final String type;
  final String color;
  final bool isGpsConnected;
  final bool isConnected;

  SealPresentationModel({
    required this.title,
    required this.status,
    required this.type,
    required this.color,
    required this.isGpsConnected,
    required this.isConnected,
  });
}

final class StatsPresentationModel {
  final String? distance;
  final String? timeTotal;
  final String? timeIdle;
  final String? timeInMotion;
  final String? avgSpeed;
  final String? maxSpeed;

  StatsPresentationModel({
    required this.distance,
    required this.timeTotal,
    required this.timeIdle,
    required this.timeInMotion,
    required this.avgSpeed,
    required this.maxSpeed,
  });

  bool get isEmpty =>
      distance == null &&
      timeTotal == null &&
      timeIdle == null &&
      timeInMotion == null &&
      avgSpeed == null &&
      maxSpeed == null;
}
