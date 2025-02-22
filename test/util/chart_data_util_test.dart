import 'package:enpal_app_code_challenge/data/models/energy_data_model.dart';
import 'package:enpal_app_code_challenge/util/chart_data_util.dart';
import 'package:test/test.dart';

void main() {
  group('aggregateChartData', () {

    test('''
    Given a list with 24 or fewer data points
    When aggregating the data
    Then return the same list
    ''', () {
      final data = [
        EnergyDataModel(timestamp: DateTime.now(), value: 1),
        EnergyDataModel(timestamp: DateTime.now().add(Duration(hours: 1)), value: 2),
      ];

      final result = aggregateChartData(data);

      expect(result, equals(data));
    });

    test('''
    Given a list with more than 24 data points
    When aggregating the data
    Then return a list with 24 points and aggregated values
    ''', () {
      final data = List.generate(
        48,
            (index) => EnergyDataModel(
          timestamp: DateTime.now().add(Duration(hours: index)),
          value: index + 1,
        ),
      );

      final result = aggregateChartData(data);

      expect(result.length, equals(24));

      final firstGroupSum = data.sublist(0, 2).fold(0, (sum, item) => sum + item.value);
      final firstGroupAvg = (firstGroupSum / 2).toInt();
      expect(result[0].value, equals(firstGroupAvg));
    });

    test('''
    Given an empty list
    When aggregating the data
    Then return an empty list
    ''', () {
      final data = <EnergyDataModel>[];

      final result = aggregateChartData(data);

      expect(result, equals(data));
    });

  });
}
