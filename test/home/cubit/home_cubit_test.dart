import 'package:enpal_app_code_challenge/home/cubit/home_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {

  late HomeCubit homeCubit;

  setUp(() {
    homeCubit = HomeCubit();
  });

  tearDown(() {
    homeCubit.close();
  });

  group('HomeCubit', () {

    blocTest<HomeCubit, HomeState>(
      '''
      Given the initial tab is solarTab
      When setTab is called with houseTab
      Then emit a new state with houseTab selected
      ''',
      build: () => homeCubit,
      act: (cubit) => cubit.setTab(HomeTab.houseTab),
      expect: () => [
        const HomeState(selectedTab: HomeTab.houseTab),
      ],
    );


    blocTest<HomeCubit, HomeState>(
      '''
      Given the initial theme is light
      When setTheme is called with true
      Then emit a new state with dark theme enabled
      ''',
      build: () => homeCubit,
      act: (cubit) => cubit.setTheme(true),
      expect: () => [
        const HomeState(isDark: true),
      ],
    );


    blocTest<HomeCubit, HomeState>(
      '''
      Given the initial cache state is not cleared
      When setDataCacheState methid is called with true
      Then emit a new state with cache cleared
      ''',
      build: () => homeCubit,
      act: (cubit) => cubit.setDataCacheState(true),
      expect: () => [
        const HomeState(isCacheCleared: true),
      ],
    );

    blocTest<HomeCubit, HomeState>(
        '''
        Given the initial state
        When setTab is called with batteryTab and theme is set to dark
        Then emit states reflecting tab and theme changes
        ''',
      build: () => homeCubit,
      act: (cubit) {
        cubit.setTab(HomeTab.batteryTab);
        cubit.setTheme(true);
      },
      expect: () => [
        const HomeState(selectedTab: HomeTab.batteryTab),
        const HomeState(selectedTab: HomeTab.batteryTab, isDark: true),
      ],
    );
  });
}
