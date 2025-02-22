
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chart_date_state.dart';

class ChartDateCubit extends Cubit<DateTime> {
  ChartDateCubit() : super(DateTime.now());

  void changeDate(DateTime date) => emit(date);
}