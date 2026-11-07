import 'package:intl/intl.dart';

extension StringExtension on String? {
  bool isNullOrEmpty() {
    final str = this;
    return str == null || str.isEmpty;
  }

  bool isNotNullOrEmpty() {
    final str = this;
    return str != null && str.isNotEmpty;
  }
}

extension SbExtensions on StringBuffer {
  void writeWithDivider(String source) {
    if (isNotEmpty) {
      write(" • ");
    }
    write(source);
  }
}

extension DTExtension on DateTime {
  String format() {
    final fmt = DateFormat('MM/dd/yy h:mm a', 'en_US');
    return fmt.format(this).toLowerCase();
  }

  String formatDate() {
    final fmt = DateFormat('MM/dd/yy', 'en_US');
    return fmt.format(this).toLowerCase();
  }
}
extension DoubleExtensions on double {
  String twoDigits(){
    return toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
  }
}