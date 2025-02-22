import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:enpal_app_code_challenge/data/models/monitoring_type.dart';

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class NetworkDataSource {
  final http.Client client;
  final String baseUrl;

  NetworkDataSource(this.client, {this.baseUrl = 'http://localhost:3000'});

  Future<List<dynamic>> getEnergyMetricsData(String date, MonitoringType type) async {
    try {
      final response = await client
          .get(_buildUri(date, type))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;

      } else {
        debugPrint('Error ${response.statusCode}: ${response.reasonPhrase}');
        throw NetworkException('Error loading the data, please try again in a moment.');

      }
    } on SocketException {
      throw NetworkException('No Internet connection, please check your network.');

    } on TimeoutException {
      throw NetworkException('The request took too long to process, please try again in a moment.');

    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw NetworkException('Error loading data, please try again in a moment.');

    }
  }

  Uri _buildUri(String date, MonitoringType type) {
    //return Uri.parse('$baseUrl/monitoring?date=$date&type=${type.value}');
    return Uri.parse('https://3vq81.wiremockapi.cloud/thing/${type.value}');
  }
}
