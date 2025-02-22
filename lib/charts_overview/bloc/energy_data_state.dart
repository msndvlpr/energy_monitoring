part of 'energy_data_bloc.dart';

sealed class EnergyDataState extends Equatable {

  @override
  List<Object?> get props => [];
}

class EnergyDataStateInitial extends EnergyDataState {}

class EnergyDataStateSuccess extends EnergyDataState {
  final List<EnergyDataModel> solarData;
  final List<EnergyDataModel> houseData;
  final List<EnergyDataModel> batteryData;

  EnergyDataStateSuccess({
    required this.solarData,
    required this.houseData,
    required this.batteryData,
  });

  @override
  List<Object?> get props => [solarData, houseData, batteryData];
}

class EnergyDataStateFailure extends EnergyDataState {
  final String errorMessage;
  EnergyDataStateFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class EnergyDataStateLoading extends EnergyDataState {}