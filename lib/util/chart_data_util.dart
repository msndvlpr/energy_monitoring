import '../data/models/energy_data_model.dart';

List<EnergyDataModel> aggregateChartData(List<EnergyDataModel> data) {
  const int targetPoints = 24;
  if (data.length <= targetPoints) return data;

  final int groupSize = (data.length / targetPoints).floor();
  List<EnergyDataModel> aggregated = [];

  for (int i = 0; i < data.length; i += groupSize) {
    int end = (i + groupSize < data.length) ? i + groupSize : data.length;

    double sum = 0;
    for (int j = i; j < end; j++) {
      sum += data[j].value;
    }
    double avg = sum / (end - i);
    DateTime midTimestamp = data[i + ((end - i) ~/ 2)].timestamp;

    aggregated.add(EnergyDataModel(timestamp: midTimestamp, value: avg.toInt()));
  }
  return aggregated;
}