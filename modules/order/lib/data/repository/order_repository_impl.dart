import 'package:order/data/data_source/order_remote_data_source.dart';
import 'package:order/domain/entity/order_entity.dart';
import 'package:order/domain/repository/order_repository.dart';

final class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<OrderEntity>> getOrders({String? query, required int page}) =>
      remoteDataSource.getOrders(page: page, query: query);
}
