part of 'chart_date_cubit.dart';


final class ChartDateState extends Equatable {
  const ChartDateState({
    required this.dateTime
  });

  final DateTime dateTime;

  @override
  List<Object> get props => [dateTime];
}