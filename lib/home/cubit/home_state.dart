part of 'home_cubit.dart';

enum HomeTab { solarTab, houseTab, batteryTab, optionsTab }

final class HomeState extends Equatable {
  const HomeState({
    this.selectedTab = HomeTab.solarTab,
    this.isDark = false,
    this.isCacheCleared = false,
  });

  final HomeTab selectedTab;
  final bool isDark;
  final bool isCacheCleared;

  @override
  List<Object> get props => [selectedTab, isDark, isCacheCleared];
}