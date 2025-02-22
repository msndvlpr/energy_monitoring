import 'package:enpal_app_code_challenge/charts_overview/view/charts_overview_screen.dart';
import 'package:enpal_app_code_challenge/home/widget/home_tab_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../widget/custom_switch.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    final selectedTab = context.select((HomeCubit cubit) => cubit.state.selectedTab);
    final isDark = context.select((HomeCubit cubit) => cubit.state.isDark);

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Container(
            margin: const EdgeInsets.only(top: 24),
            child: AppBar(backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 12,
              leading: PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz_rounded, size: 32),
                onSelected: (value){
                  if(value == 'clear_cache'){
                    _confirmCacheClear();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'clear_cache',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        const Text('Clear Cache'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'about',
                    child: Row(
                      children: [
                        Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        const Text('About'),
                      ],
                    ),
                  ),
                ],
              ),
              title: const Text(
                'Energy Monitoring',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CustomSwitch(
                    value: isDark,
                    onChanged: (value) {
                      context.read<HomeCubit>().setTheme(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: const ChartsOverviewScreen(),
        bottomNavigationBar: BottomAppBar(color: Theme.of(context).bottomAppBarTheme.color,
          elevation: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeTabButton(
                groupValue: selectedTab,
                value: HomeTab.solarTab,
                icon: const Icon(Icons.sunny),
                label: 'Solar',
              ),
              HomeTabButton(
                groupValue: selectedTab,
                value: HomeTab.houseTab,
                icon: const Icon(Icons.warehouse_outlined),
                label: 'House',
              ),
              HomeTabButton(
                groupValue: selectedTab,
                value: HomeTab.batteryTab,
                icon: const Icon(Icons.battery_4_bar),
                label: 'Battery',
              ),
            ],
          ),
        ),

      ),
    );
  }

  void _confirmCacheClear() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache!'),
        content: const Text('Are you sure you want to clear the cache?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Clear'),
            onPressed: () async{
              Navigator.of(context).pop();
              context.read<HomeCubit>().setDataCacheState(true);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chart data cache was cleared successfully!')));
            },
          ),
        ],
      ),
    );
  }

}
