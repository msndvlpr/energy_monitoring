import 'package:bloc_test/bloc_test.dart';
import 'package:enpal_app_code_challenge/charts_overview/bloc/energy_data_bloc.dart';
import 'package:enpal_app_code_challenge/charts_overview/cubit/chart_date_cubit.dart';
import 'package:enpal_app_code_challenge/charts_overview/cubit/chart_unit_cubit.dart';
import 'package:enpal_app_code_challenge/charts_overview/view/charts_overview_screen.dart';
import 'package:enpal_app_code_challenge/charts_overview/widget/app_loader.dart';
import 'package:enpal_app_code_challenge/charts_overview/widget/reload_widget.dart';
import 'package:enpal_app_code_challenge/data/models/energy_data_model.dart';
import 'package:enpal_app_code_challenge/data/models/monitoring_type.dart';
import 'package:enpal_app_code_challenge/data/repositories/energy_analytics_repository.dart';
import 'package:enpal_app_code_challenge/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MockEnergyDataBloc extends Mock implements EnergyDataBloc {}

class MockChartDateCubit extends Mock implements ChartDateCubit {}

class MockChartUnitCubit extends Mock implements ChartUnitCubit {}

class MockHomeCubit extends Mock implements HomeCubit {}

class MockEnergyAnalyticsRepository extends Mock implements EnergyAnalyticsRepository {}

class MyTypeFake extends Fake implements EnergyDataFetched {}

void main() {
  late MockEnergyDataBloc energyDataBloc;
  late MockChartDateCubit chartDateCubit;
  late MockChartUnitCubit chartUnitCubit;
  late MockHomeCubit homeCubit;
  late MockEnergyAnalyticsRepository repository;

  final mockData = [
    EnergyDataModel(
        timestamp: DateTime.parse('2025-02-04T00:00:00Z'), value: 1000),
    EnergyDataModel(
        timestamp: DateTime.parse('2025-02-04T01:00:00Z'), value: 1500),
  ];

  setUp(() {
    energyDataBloc = MockEnergyDataBloc();
    chartDateCubit = MockChartDateCubit();
    chartUnitCubit = MockChartUnitCubit();
    homeCubit = MockHomeCubit();
    repository = MockEnergyAnalyticsRepository();

    when(() => chartDateCubit.state).thenReturn(DateTime.now());
    when(() => chartUnitCubit.state).thenReturn(false);
    when(() => homeCubit.state).thenReturn(const HomeState());

    whenListen(homeCubit, Stream.value(const HomeState()));
  });

  setUpAll(() {
    registerFallbackValue(MonitoringType.solar);
    registerFallbackValue(MyTypeFake());
  });

  Widget buildTestableWidget() {
    return RepositoryProvider<EnergyAnalyticsRepository>(
      create: (context) => repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<EnergyDataBloc>.value(value: energyDataBloc),
          BlocProvider<ChartDateCubit>.value(value: chartDateCubit),
          BlocProvider<ChartUnitCubit>.value(value: chartUnitCubit),
          BlocProvider<HomeCubit>.value(value: homeCubit),
        ],
        child: const MaterialApp(
          home: ChartsOverviewScreen(),
        ),
      ),
    );
  }

  group('ChartsOverviewScreen', () {

    testWidgets(
  'Given app starts and API call fails'
  'When error state is emitted'
  'Then shows error widget'
  , (WidgetTester tester) async {
      when(() => repository.getEnergyAnalyticsData(any(), any())).thenThrow(
          (_) async => Future.delayed(const Duration(seconds: 0), () {
                return Exception;
              }));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ReloadWidget), findsOneWidget);
    });

    testWidgets(
  'Given app starts and API call returns data'
  'When successful state is emitted with the data'
  'Then shows success state and all normal widgets'
  , (WidgetTester tester) async {
      when(() => repository.getEnergyAnalyticsData(any(), any())).thenAnswer(
          (_) async => Future.delayed(const Duration(seconds: 0), () {
                return mockData;
              }));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Solar Generation:'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(SfCartesianChart), findsOneWidget);
    });

    testWidgets(
  'Given app starts'
  'When loading state is emitted'
  'Then shows loading indicator'
  , (WidgetTester tester) async {
      when(() => energyDataBloc.state).thenReturn(EnergyDataStateLoading());

      await tester.pumpWidget(buildTestableWidget());

      expect(find.byType(AppLoader), findsOneWidget);
    });

    testWidgets(
  'Given the app starts with success state and kw switch is shown'
  'When initial state of switch is false'
  'Then user should be able to toggle the switch to update the unit state'
  , (WidgetTester tester) async {
      when(() => repository.getEnergyAnalyticsData(any(), any())).thenAnswer(
          (_) async => Future.delayed(const Duration(seconds: 0), () {
                return mockData;
              }));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      await tester.tap(switchFinder);
      await tester.pump();

      expect(() => tester.element(switchFinder).read<ChartUnitCubit>(),
          returnsNormally);
    });

    testWidgets(
  'Given the app starts normally'
  'When state is successful and RefreshIndicator is dragged'
  'Then user should be able to refresh the page'
  , (WidgetTester tester) async {
      when(() => repository.getEnergyAnalyticsData(any(), any())).thenAnswer(
          (_) async => Future.delayed(const Duration(seconds: 0), () {
                return mockData;
              }));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();
      final refreshIndicatorFinder = find.byType(RefreshIndicator);

      expect(refreshIndicatorFinder, findsOneWidget);
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, 300));

      await tester.pumpAndSettle();
      expect(() => tester.element(refreshIndicatorFinder).read<EnergyDataBloc>(),
          returnsNormally);
    });
  });
}
