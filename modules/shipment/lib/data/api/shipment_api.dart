import 'package:api/api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shipment/data/model/active_shipments_request.dart';
import 'package:shipment/data/model/complete_shipment_request.dart';
import 'package:shipment/data/model/route_point_dto.dart';
import 'package:shipment/data/model/shipment_dto.dart';
import 'package:shipment/data/model/shipment_item_dto.dart';
import 'package:shipment/data/model/shipment_list_request.dart';
import 'package:shipment/data/model/shipments_page_dto.dart';

part 'shipment_api.g.dart';

@RestApi()
abstract class ShipmentApi {
  factory ShipmentApi(ApiClient client) => _ShipmentApi(client.dio);

  @POST('/api/shipment/list')
  Future<ShipmentsPageDto> getShipmentList(@Body() ShipmentsListRequest body);

  @POST('/api/shipment/active')
  Future<List<ShipmentItemDto>> getActiveShipments(@Body() ActiveShipmentsRequest body);

  @GET('/api/shipment/{id}')
  Future<ShipmentDto> getShipmentById(@Path("id") String id);

  @GET('/api/shipment/{id}/route')
  Future<List<RoutePointDto>> getRoute(@Path("id") String id, @Query('clusterRadiusInMeters') int clusterRadius);

  @POST('/api/shipment/{id}/complete')
  Future<ShipmentDto> completeShipment(@Path("id") String id, @Body() CompleteShipmentRequest request);
}
