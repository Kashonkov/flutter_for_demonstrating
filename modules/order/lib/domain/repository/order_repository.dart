import 'package:order/domain/entity/order_entity.dart';

abstract interface class OrderRepository {
  Future<List<OrderEntity>> getOrders({String? query, required int page});
}
