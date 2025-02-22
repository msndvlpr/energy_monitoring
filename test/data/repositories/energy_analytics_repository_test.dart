import 'package:enpal_app_code_challenge/data/data_sources/network_data_source.dart';
import 'package:enpal_app_code_challenge/data/models/energy_data_model.dart';
import 'package:enpal_app_code_challenge/data/models/monitoring_type.dart';
import 'package:enpal_app_code_challenge/data/repositories/energy_analytics_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkDataSource extends Mock implements NetworkDataSource {}

void main() {

  late MockNetworkDataSource mockNetworkDataSource;
  late EnergyAnalyticsRepository repository;

  const List<dynamic> jsonBody = [
    {"timestamp": "2024-02-01T00:00:00.000Z", "value": 3333},
    {"timestamp": "2024-02-01T00:05:00.000Z", "value": 5003},
    {"timestamp": "2024-02-01T00:10:00.000Z", "value": 2225}
  ];

  setUp(() {
    mockNetworkDataSource = MockNetworkDataSource();
    repository = EnergyAnalyticsRepository(mockNetworkDataSource);
  });

    group('getEnergyAnalyticsData', () {

      test(
        '''
        Given EnergyAnalyticsRepository 
        When getEnergyMetricsData returns valid data 
        Then should return a list of EnergyDataModel
        ''',
            () async {
          when(() => mockNetworkDataSource.getEnergyMetricsData('2025-02-04', MonitoringType.solar))
              .thenAnswer((_) async => jsonBody);

          final data = await repository.getEnergyAnalyticsData('2025-02-04', MonitoringType.solar);

          expect(data, isNotNull);
          expect(data, isA<List<EnergyDataModel>>());
          expect(data.length, equals(3));
        },
      );

      test(
        '''
        Given EnergyAnalyticsRepository 
        When getEnergyMetricsData throws a NetworkException 
        Then should throw a generic Exception with the network error message
        ''',
            () async {
          when(() => mockNetworkDataSource.getEnergyMetricsData('2025-02-04', MonitoringType.solar))
              .thenThrow(NetworkException('Network error occurred'));

          final call = repository.getEnergyAnalyticsData('2025-02-04', MonitoringType.solar);

          expect(call, throwsA(predicate((e) =>
          e is Exception && e.toString().contains('Network error occurred'))));
        },
      );

      test(
        '''
        Given EnergyAnalyticsRepository 
        When an unexpected error occurs during data processing 
        Then should throw a generic Exception with a fallback message
        ''',
            () async {

          when(() => mockNetworkDataSource.getEnergyMetricsData('2025-02-04', MonitoringType.solar))
              .thenThrow(Exception('Unexpected error'));

          final call = repository.getEnergyAnalyticsData('2025-02-04', MonitoringType.solar);

          expect(call, throwsA(predicate((e) =>
          e is Exception && e.toString().contains('Error loading data, please try again.'))));
        },
      );
    });

}
