import 'package:common/index.dart';
import 'package:order/domain/entity/order_entity.dart';
import 'package:order/domain/repository/order_repository.dart';

final class GetOrdersUseCase extends UseCase<List<OrderEntity>, GetOrdersUseCaseParams> {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  @override
  Future<UseCaseResult<List<OrderEntity>>> call(GetOrdersUseCaseParams params) =>
      innerCall(() => repository.getOrders(page: params.page, query: params.query));
}

final class GetOrdersUseCaseParams {
  final int page;
  final String? query;

  GetOrdersUseCaseParams({required this.page, this.query});
}
