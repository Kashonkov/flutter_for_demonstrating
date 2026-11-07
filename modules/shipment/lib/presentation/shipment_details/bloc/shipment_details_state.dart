import 'package:shipment/presentation/shipment_details/model/route_model.dart';
import 'package:shipment/presentation/shipment_details/model/shipment_presentation_model.dart';

sealed class ShipmentDetailsState {}

final class IdleState extends ShipmentDetailsState {}

final class LoadingState extends ShipmentDetailsState {}

final class DataState extends ShipmentDetailsState {
  final ShipmentPresentationModel model;
  final RouteModel? routeModel;
  final bool isCompleteVisible;

  DataState({required this.model, this.routeModel, required this.isCompleteVisible});
}
