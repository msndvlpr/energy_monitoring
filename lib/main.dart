import 'dart:developer';
import 'dart:ui';

import 'package:enpal_app_code_challenge/data/data_sources/network_data_source.dart';
import 'package:enpal_app_code_challenge/data/repositories/energy_analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import 'app/app.dart';
import 'app/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log(error.toString(), stackTrace: stack);
    return true;
  };

  Bloc.observer = const AppBlocObserver();

  final energyAnalyticsRepository = EnergyAnalyticsRepository(NetworkDataSource(Client()));

  runApp(App(energyAnalyticsRepository: energyAnalyticsRepository));
}
