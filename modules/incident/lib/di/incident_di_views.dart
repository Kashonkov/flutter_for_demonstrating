import 'package:auto_route/auto_route.dart';
import 'package:common/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain_core/domain/entity/incident_item_entity.dart';
import 'package:incident/presentation/incident_details/bloc/incident_details_cubit.dart';
import 'package:incident/presentation/incident_details/incident_details_screen.dart';
import 'package:incident/presentation/incidents_list/bloc/incidents_list_bloc.dart';
import 'package:incident/presentation/incidents_list/incident_list_screen.dart';
import 'package:incident/presentation/incidents_map/bloc/incident_map_bloc.dart';
import 'package:incident/presentation/incidents_map/incidents_map_screen_content.dart';
import 'package:list_view_handler/list_view_handler.dart';

@RoutePage()
class IncidentNestedRoutingScreen extends StatelessWidget {
  const IncidentNestedRoutingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoRouter();
  }
}

@RoutePage()
class IncidentListScreen extends StatelessWidget {
  const IncidentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IncidentsListBloc(
        getIncidentsUseCase: getIt(),
        listViewHandler: ListViewHandler(),
        navigator: getIt(),
        getInitialIncidentsUseCase: getIt(),
        applyIncidentFilterUseCase: getIt(),
        getFilterIncidentStreamUseCase: getIt(),
      ),
      child: IncidentsListScreenContent(),
    );
  }
}

@RoutePage()
class IncidentDetailsScreen extends StatelessWidget {
  final IncidentEntity incident;

  const IncidentDetailsScreen({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IncidentDetailsCubit(
        incident: incident,
        navigator: getIt(),
        downloadIncidentReportUseCase: getIt(),
        downloadShareReportIncidentReportUseCase: getIt(),
      ),
      child: IncidentDetailsScreenContent(),
    );
  }
}

@RoutePage()
class IncidentsMapScreen extends StatelessWidget {
  const IncidentsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IncidentsMapBloc(
        getIncidentsUseCase: getIt(),
        getFilterIncidentStreamUseCase: getIt(),
        applyIncidentFilterUseCase: getIt(),
        navigator: getIt(),
      ),
      child: IncidentsMapScreenContent(),
    );
  }
}
