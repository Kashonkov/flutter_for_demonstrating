import 'package:auto_route/auto_route.dart';
import 'package:common/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_view_handler/list_view_handler.dart';
import 'package:order/presentation/bloc/orders_list_bloc.dart';
import 'package:order/presentation/orders_list_screen.dart';

@RoutePage()
class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersListBloc(getOrdersUseCase: getIt(), listViewHandler: ListViewHandler()),
      child: OrdersListScreenContent(),
    );
  }
}
