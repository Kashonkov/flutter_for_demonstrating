import 'package:api/api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:order/data/model/orders_list_request.dart';
import 'package:order/data/model/orders_page_dto.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'order_api.g.dart';

@RestApi()
abstract class OrderApi {
  factory OrderApi(ApiClient client) => _OrderApi(client.dio);

  @POST('/api/order/list')
  Future<OrdersPageDto> getOrderList(@Body() OrdersListRequest body);
}
