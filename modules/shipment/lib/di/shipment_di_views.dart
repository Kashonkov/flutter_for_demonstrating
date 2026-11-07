import 'package:auto_route/auto_route.dart';
import 'package:common/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_view_handler/list_view_handler.dart';
import 'package:shipment/navigation/shipment_navigator.dart';
import 'package:shipment/presentation/shipment_details/bloc/shipment_details_bloc.dart';
import 'package:shipment/presentation/shipments_list/bloc/shipments_list_bloc.dart';
import 'package:shipment/presentation/shipments_list/shipments_list_screen.dart';
import 'package:shipment/presentation/shipment_details/shipment_details_screen.dart';
import 'package:shipment/presentation/shipments_map/bloc/shipments_map_bloc.dart';
import 'package:shipment/presentation/shipments_map/shipments_map_screen.dart';

@RoutePage()
class ShipmentNestedRoutingScreen extends StatelessWidget {
  const ShipmentNestedRoutingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoRouter();
  }
}

@RoutePage()
class ShipmentListScreen extends StatelessWidget {
  const ShipmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShipmentsListBloc(
        getInitialShipmentsUseCase: getIt(),
        getShipmentsUseCase: getIt(),
        applyShipmentFilterUseCase: getIt(),
        getFilterShipmentStreamUseCase: getIt(),
        listViewHandler: ListViewHandler(),
        navigator: ShipmentNavigatorImpl(AutoRouter.of(context), getIt()),
        busController: getIt(),
      ),
      child: ShipmentsListScreenContent(),
    );
  }
}

@RoutePage()
class ShipmentDetailsScreen extends StatelessWidget {
  final String id;

  const ShipmentDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShipmentDetailsBloc(
        shipmentId: id,
        getShipmentUseCase: getIt(),
        getShipmentRouteUseCase: getIt(),
        completeShipmentUseCase: getIt(),
        busController: getIt(),
        navigator: ShipmentNavigatorImpl(AutoRouter.of(context), getIt()),
      ),
      child: ShipmentsDetailsScreenContent(),
    );
  }
}

@RoutePage()
class ShipmentsMapScreen extends StatelessWidget {
  const ShipmentsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShipmentsMapBloc(
        getShipmentsUseCase: getIt(),
        applyShipmentFilterUseCase: getIt(),
        getFilterShipmentStreamUseCase: getIt(),
        navigator: ShipmentNavigatorImpl(AutoRouter.of(context), getIt()),
        controller: getIt(),
      ),
      child: ShipmentsMapScreenContent(),
    );
  }
}
