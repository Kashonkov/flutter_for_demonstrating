import 'package:common/bloc/news.dart';
import 'package:flutter/widgets.dart';

abstract class BlocNewsHandler {
  void onNewsReceived(BuildContext context, BlocNews news);
}
