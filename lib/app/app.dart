import 'package:enpal_app_code_challenge/data/repositories/energy_analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/view/home_page.dart';

class App extends StatelessWidget {

  final EnergyAnalyticsRepository energyAnalyticsRepository;
  const App({required this.energyAnalyticsRepository, super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: energyAnalyticsRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
