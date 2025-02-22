import 'dart:convert';

import 'package:enpal_app_code_challenge/data/data_sources/network_data_source.dart';
import 'package:enpal_app_code_challenge/data/models/energy_data_model.dart';
import 'package:enpal_app_code_challenge/data/models/monitoring_type.dart';

class DataParsingException implements Exception {
  final String message;
  DataParsingException(this.message);
}

class EnergyAnalyticsRepository {

  final NetworkDataSource energyAnalyticsDataSource;
  EnergyAnalyticsRepository(this.energyAnalyticsDataSource);

  Future<List<EnergyDataModel>> getEnergyAnalyticsData(String date, MonitoringType type) async {
    try {
      final responseData = await energyAnalyticsDataSource.getEnergyMetricsData(date, type);

      if (responseData.isEmpty) {
        throw DataParsingException('No data available for the selected date.');
      }

      return responseData.map((item) {
        return EnergyDataModel.fromJson(item);
      }).toList();


      //todo: also other necessary logics should be implemented in this layer

    } on NetworkException catch (e) {
      throw Exception(e.message);

    } on DataParsingException catch (e) {
      throw Exception('Error loading data, please try again.');

    } catch (e) {
      throw Exception('Error loading data, please try again.');

    }
  }
}