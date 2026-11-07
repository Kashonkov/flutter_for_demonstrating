import 'package:common/bloc/news.dart';

final class SetProfileDataNews extends BlocNews {
  final String? name;
  final String? phone;
  final String? email;
  final String? company;

  SetProfileDataNews({
    required this.name,
    required this.phone,
    required this.email,
    required this.company,
  });
}

final class NavigateBackNews extends BlocNews {}