import 'package:api/exception/error_handler.dart';
import 'package:order/data/api/order_api.dart';
import 'package:order/data/model/orders_list_request.dart';
import 'package:order/domain/entity/order_entity.dart';

abstract interface class OrderRemoteDataSource {
  Future<List<OrderEntity>> getOrders({String? query, required int page});
}

const _requestAmount = 50;

final class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final OrderApi _api;

  OrderRemoteDataSourceImpl(this._api);

  @override
  Future<List<OrderEntity>> getOrders({String? query, required int page}) async {
    final hasQuery = query != null && query.isNotEmpty;
    final result = await checkNetErrors(
      () => _api.getOrderList(
        OrdersListRequest(page: page, pageSize: _requestAmount, query: hasQuery ? query : null),
      ),
    );
    return result.items.map((item) => item.toEntity()).toList();
  }
}
