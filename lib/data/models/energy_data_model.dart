
class EnergyDataModel {
  final DateTime timestamp;
  final int value;

  EnergyDataModel({required this.timestamp, required this.value});

  factory EnergyDataModel.fromJson(Map<String, dynamic> json) {
    return EnergyDataModel(
      timestamp: DateTime.parse(json['timestamp']),
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'value': value,
    };
  }
}

