import 'package:enpal_app_code_challenge/charts_overview/bloc/energy_data_bloc.dart';
import 'package:enpal_app_code_challenge/charts_overview/cubit/chart_date_cubit.dart';
import 'package:enpal_app_code_challenge/charts_overview/cubit/chart_unit_cubit.dart';
import 'package:enpal_app_code_challenge/charts_overview/widget/app_loader.dart';
import 'package:enpal_app_code_challenge/charts_overview/widget/date_selector_bar.dart';
import 'package:enpal_app_code_challenge/charts_overview/widget/reload_widget.dart';
import 'package:enpal_app_code_challenge/data/repositories/energy_analytics_repository.dart';
import 'package:enpal_app_code_challenge/home/cubit/home_cubit.dart';
import 'package:enpal_app_code_challenge/util/chart_data_util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/models/energy_data_model.dart';
import '../../data/models/monitoring_type.dart';

class ChartsOverviewScreen extends StatelessWidget {
  const ChartsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EnergyDataBloc(context.read<EnergyAnalyticsRepository>())
            ..add(EnergyDataFetched(date: DateFormat('yyyy-MM-dd').format(DateTime.now()))),
        ),
        BlocProvider(
          create: (context) => ChartDateCubit(),
        ),
        BlocProvider(
          create: (context) => ChartUnitCubit(),
        ),
      ],
      child: const ChartsOverview(),
    );
  }
}

class ChartsOverview extends StatelessWidget {
  const ChartsOverview({super.key});

  @override
  Widget build(BuildContext context) {

    final selectedMetric = context.select((HomeCubit cubit) => cubit.state.selectedTab);
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<ChartDateCubit, DateTime>(
              listener: (context, selectedDate) {
            context.read<EnergyDataBloc>().add(
              EnergyDataFetched(date: DateFormat('yyyy-MM-dd').format(selectedDate)));
          }),
          BlocListener<HomeCubit, HomeState>(
              listenWhen: (previous, current) => current.isCacheCleared,
              listener: (context, state) {
                context.read<EnergyDataBloc>().add(EnergyDataCleared());
                context.read<HomeCubit>().setDataCacheState(false);
              })
        ],
        child: BlocBuilder<EnergyDataBloc, EnergyDataState>(
          builder: (context, state) {
            final isKilowatt = context.watch<ChartUnitCubit>().state;

            switch (state) {
              case EnergyDataStateSuccess():
                final chartData = selectedMetric.index == MonitoringType.solar.index
                    ? aggregateChartData(state.solarData)
                    : selectedMetric.index == MonitoringType.house.index
                    ? aggregateChartData(state.houseData)
                    : aggregateChartData(state.batteryData);

                final total = chartData.fold(0, (sum, item) => sum + item.value);
                final formattedTotal = NumberFormat.decimalPattern().format(total);
                final formattedTotalKw = NumberFormat('#,##0.00').format(total / 1000);

                return RefreshIndicator(
                  displacement: 110,
                  onRefresh: () => _refreshData(context),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const DateSelectorBar(),

                        SizedBox(height: screenHeight * 0.015),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          width: double.infinity,
                          height: 1.1,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: 12),
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _getChartLabel(MonitoringType.values[selectedMetric.index]),
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                isKilowatt ? '$formattedTotalKw kW' : '$formattedTotal W',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  Switch(
                                    value: isKilowatt,
                                    onChanged: (isKw) {
                                      context.read<ChartUnitCubit>().setUnit(isKw);
                                    },
                                  ),
                                  const Text('KW'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          width: double.infinity,
                          height: 1.1,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        _drawLineChart(chartData, isKilowatt, selectedMetric, context, screenHeight),
                      ],
                    ),
                  ),
                );

              case EnergyDataStateFailure():
                return Center(
                  child: ReloadWidget(
                    content: state.errorMessage,
                    onPressed: () => _refreshData(context)
                  ),
                );

              default:
                return const Center(
                  child: AppLoader(),
                );
            }
          },
        ),
      ),
    );
  }

  Widget _drawLineChart(List<EnergyDataModel> chartData, bool isKilowatt, HomeTab selectedMetric, context, double screenHeight) {

    final color = selectedMetric == HomeTab.solarTab ? Colors.purple : selectedMetric == HomeTab.houseTab ? Colors.blue : Colors.green;
    return Container(height: screenHeight * 0.48,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(right: 8, left: 4),
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          zoomMode: ZoomMode.xy,
        ),
        primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.hours,
          dateFormat: DateFormat.Hm(),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 2,
          labelRotation: 45,
        ),
        primaryYAxis: NumericAxis(
          numberFormat: isKilowatt ? NumberFormat.compact() : NumberFormat.decimalPattern(),
          labelFormat: '{value}',
        ),
        series: <CartesianSeries<EnergyDataModel, DateTime>>[
          SplineAreaSeries<EnergyDataModel, DateTime>(
            dataSource: chartData,
            xValueMapper: (EnergyDataModel data, _) => data.timestamp,
            yValueMapper: (EnergyDataModel data, _) => isKilowatt ? data.value / 1000 : data.value,
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.4),
                color.withOpacity(0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderColor: color,
            borderWidth: 3,
            markerSettings: MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
              color: color,
            ),
            enableTooltip: true,
          ),
        ],
      ),
    );
  }

  String _getChartLabel(MonitoringType type) {
    switch (type) {
      case MonitoringType.solar:
        return 'Solar Generation:';
      case MonitoringType.house:
        return 'House Consumption:';
      case MonitoringType.battery:
        return 'Battery Consumption:';
    }
  }

  Future<void> _refreshData(BuildContext context) async {
    final selectedDate = context.read<ChartDateCubit>().state;
    context.read<EnergyDataBloc>().add(
      EnergyDataFetched(date: DateFormat('yyyy-MM-dd').format(selectedDate)),
    );
  }

}