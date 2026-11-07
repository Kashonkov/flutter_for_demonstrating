final class IncidentPresentationModel {
  final ContainerInfoPresentationModel containerInfo;
  final IncidentInfoPresentationModel incidentInfo;

  IncidentPresentationModel({
    required this.containerInfo,
    required this.incidentInfo,
  });
}

final class ContainerInfoPresentationModel {
  final String reference;
  final String number;

  ContainerInfoPresentationModel({
    required this.reference,
    required this.number,
  });
}

final class IncidentInfoPresentationModel {
  final String shipment;
  final String status;
  final String address;
  final String createdDate;
  final String? updatedDate;
  final double lat;
  final double long;
  final double? accuracy;
  final int? range;
  final String? incidentMapRange;

  IncidentInfoPresentationModel({
    required this.shipment,
    required this.status,
    required this.address,
    required this.createdDate,
    required this.updatedDate,
    required this.lat,
    required this.long,
    this.range,
    this.incidentMapRange,
    this.accuracy,
  });
}
