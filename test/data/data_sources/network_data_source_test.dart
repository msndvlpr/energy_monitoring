import 'package:enpal_app_code_challenge/data/data_sources/network_data_source.dart';
import 'package:enpal_app_code_challenge/data/models/monitoring_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late NetworkDataSource networkDataSource;

  const jsonBody = '''[
    {
        "timestamp": "2024-02-01T00:00:00.000Z",
        "value": 3333
    },
    {
        "timestamp": "2024-02-01T00:05:00.000Z",
        "value": 5003
    },
    {
        "timestamp": "2024-02-01T00:10:00.000Z",
        "value": 2225
    }
  ]''';
  const baseUrl = 'http://localhost:3000/monitoring?date=2025-02-04&type=solar';

  setUp(() {
    mockHttpClient = MockHttpClient();
    networkDataSource = NetworkDataSource(mockHttpClient);
  });

    group('getEnergyMetricsData', () {

      test(
          '''
          Given NetworkRepository 
          When http get method is called 
          Then should respond success with non-null data list
          ''',
          () async {
        when(() => mockHttpClient.get(Uri.parse(baseUrl)))
            .thenAnswer((invocation) async {
          return Response(jsonBody, 200);
        });
        final data = networkDataSource.getEnergyMetricsData('2025-02-04', MonitoringType.solar);
        expect(data, isNotNull);
        expect(data, isA<Future<List<dynamic>>>());

      });

      test(
          '''
          Given NetworkRepository 
          When http get method is called and response has error 
          Then should throw exception
          ''', () async {
            when(() => mockHttpClient.get(Uri.parse('https://3vq81.wiremockapi.cloud/thing/solar')))
                .thenAnswer((invocation) async {
              return Response('{}', 500);
            });
            final data = networkDataSource.getEnergyMetricsData('2025-02-04', MonitoringType.solar);
            expect(data, throwsException);

          });
    });

}
