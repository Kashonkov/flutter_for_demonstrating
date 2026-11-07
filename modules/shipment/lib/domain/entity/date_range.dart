import 'package:equatable/equatable.dart';

final class DateRange extends Equatable{
  final DateTime startDate;
  final DateTime endDate;

  const DateRange({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [
    startDate,
    endDate,
  ];
}
