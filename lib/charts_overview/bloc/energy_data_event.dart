part of 'energy_data_bloc.dart';


sealed class EnergyDataEvent extends Equatable{}

class EnergyDataFetched extends EnergyDataEvent{
  final String date;
  EnergyDataFetched({required this.date});

  @override
  List<Object> get props => [];
}

class EnergyDataCleared extends EnergyDataEvent{

  @override
  List<Object?> get props => throw UnimplementedError();
}