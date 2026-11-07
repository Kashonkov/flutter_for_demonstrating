import 'package:common/bloc/bloc.dart';
import 'package:shipment/presentation/shipment_filter_bottom_sheet/model/shipment_filter.dart';

final class ShowFilterDialogNews extends BlocNews{
  final ShipmentBottomFilters? filter;

  ShowFilterDialogNews(this.filter);
}

final class ShowQueryNews extends BlocNews {
  final String query;

  ShowQueryNews(this.query);
}
