import 'package:bloc_test/bloc_test.dart';
import 'package:enpal_app_code_challenge/charts_overview/bloc/energy_data_bloc.dart';
import 'package:enpal_app_code_challenge/data/models/energy_data_model.dart';
import 'package:enpal_app_code_challenge/data/models/monitoring_type.dart';
import 'package:enpal_app_code_challenge/data/repositories/energy_analytics_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEnergyAnalyticsRepository extends Mock implements EnergyAnalyticsRepository {}

void main() {
  late MockEnergyAnalyticsRepository mockRepository;
  late EnergyDataBloc energyDataBloc;

  setUpAll(() {
    registerFallbackValue(MonitoringType.solar);
  });

  setUp(() {
    mockRepository = MockEnergyAnalyticsRepository();
    energyDataBloc = EnergyDataBloc(mockRepository);
  });

  tearDown(() {
    energyDataBloc.close();
  });

  const mockDate = '2025-02-04';
  final mockData = [
    EnergyDataModel(timestamp: DateTime.parse('2025-02-04T00:00:00Z'), value: 1000),
    EnergyDataModel(timestamp: DateTime.parse('2025-02-04T01:00:00Z'), value: 1500),
  ];

  group('EnergyDataBloc', () {

    blocTest<EnergyDataBloc, EnergyDataState>(
      '''
      Given the repository returns data for all monitoring types
      When EnergyDataFetched is added
      Then emit [Loading, Success] with the fetched data
      ''',
      build: () {
        when(() => mockRepository.getEnergyAnalyticsData(any(), MonitoringType.solar))
            .thenAnswer((_) async => mockData);
        when(() => mockRepository.getEnergyAnalyticsData(any(), MonitoringType.house))
            .thenAnswer((_) async => mockData);
        when(() => mockRepository.getEnergyAnalyticsData(any(), MonitoringType.battery))
            .thenAnswer((_) async => mockData);
        return energyDataBloc;
      },
      act: (bloc) => bloc.add(EnergyDataFetched(date: mockDate)),
      expect: () => [
        EnergyDataStateLoading(),
        EnergyDataStateSuccess(solarData: mockData, houseData: mockData, batteryData: mockData),
      ],
    );

    blocTest<EnergyDataBloc, EnergyDataState>(
      '''
      Given the repository throws an exception
      When EnergyDataFetched is added
      Then emit [Loading, Failure] with the error message
      ''',
      build: () {
        when(() => mockRepository.getEnergyAnalyticsData(any(), any()))
            .thenThrow(Exception('Failed to fetch data'));
        return energyDataBloc;
      },
      act: (bloc) => bloc.add(EnergyDataFetched(date: mockDate)),
      expect: () => [
        EnergyDataStateLoading(),
        EnergyDataStateFailure(errorMessage: 'Exception: Failed to fetch data'),
      ],
    );

    blocTest<EnergyDataBloc, EnergyDataState>(
      '''
      Given cached data exists
      When EnergyDataCleared is added
      Then emit [Failure] with a message indicating the cache is cleared
      ''',
      build: () => energyDataBloc,
      act: (bloc) => bloc.add(EnergyDataCleared()),
      expect: () => [
        EnergyDataStateFailure(errorMessage: 'No data available because of clear cache, please reload data'),
      ],
    );


  });
}
