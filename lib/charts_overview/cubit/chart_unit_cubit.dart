import 'package:flutter_bloc/flutter_bloc.dart';

class ChartUnitCubit extends Cubit<bool> {
  ChartUnitCubit() : super(false);

  void setUnit(bool isKw) => emit(isKw);
}
