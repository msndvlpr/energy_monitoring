import 'package:enpal_app_code_challenge/data/models/monitoring_type.dart';
import 'package:enpal_app_code_challenge/data/repositories/energy_analytics_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/energy_data_model.dart';

part 'energy_data_event.dart';

part 'energy_data_state.dart';

class EnergyDataBloc extends Bloc<EnergyDataEvent, EnergyDataState> {
  final EnergyAnalyticsRepository energyAnalyticsRepository;

  EnergyDataBloc(this.energyAnalyticsRepository) : super(EnergyDataStateInitial()) {
    on<EnergyDataFetched>(_getAllEnergyAnalyticsData);
    on<EnergyDataCleared>(_clearCachedEnergyAnalyticsData);
  }

  void _getAllEnergyAnalyticsData(
      EnergyDataFetched event,
      Emitter<EnergyDataState> emit) async {

    emit(EnergyDataStateLoading());
    try {
      final solarData = await energyAnalyticsRepository.getEnergyAnalyticsData(event.date, MonitoringType.solar);
      final houseData = await energyAnalyticsRepository.getEnergyAnalyticsData(event.date, MonitoringType.house);
      final batteryData = await energyAnalyticsRepository.getEnergyAnalyticsData(event.date, MonitoringType.battery);

      emit(EnergyDataStateSuccess(
        solarData: solarData,
        houseData: houseData,
        batteryData: batteryData,
      ));
    } catch (e) {
      emit(EnergyDataStateFailure(errorMessage: e.toString()));
    }
  }

  void _clearCachedEnergyAnalyticsData(
      EnergyDataEvent event,
      Emitter<EnergyDataState> emit) async {

    emit(EnergyDataStateFailure(errorMessage: 'No data available because of cleared cache, please reload the page'));

  }
}
