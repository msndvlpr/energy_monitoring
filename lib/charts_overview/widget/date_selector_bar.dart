import 'package:enpal_app_code_challenge/charts_overview/cubit/chart_date_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DateSelectorBar extends StatefulWidget {
  const DateSelectorBar({super.key});

  @override
  _DateSelectorBarState createState() => _DateSelectorBarState();
}

class _DateSelectorBarState extends State<DateSelectorBar> {
  String _selectedTab = 'DAY';

  void _changeDate(BuildContext context, int value) {
    final currentDate = context.read<ChartDateCubit>().state;
    DateTime newDate;

    switch (_selectedTab) {
      case 'WEEK':
        newDate = currentDate.add(Duration(days: 7 * value));
        break;
      case 'MONTH':
        newDate = DateTime(
            currentDate.year, currentDate.month + value, currentDate.day);
        break;
      case 'YEAR':
        newDate = DateTime(
            currentDate.year + value, currentDate.month, currentDate.day);
        break;
      default:
        newDate = currentDate.add(Duration(days: value));
    }

    if (newDate.isBefore(DateTime.now()) ||
        newDate.isAtSameMomentAs(DateTime.now())) {
      context.read<ChartDateCubit>().changeDate(newDate);
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: context.read<ChartDateCubit>().state,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      context.read<ChartDateCubit>().changeDate(picked);
    }
  }

  Widget _buildTab(String title, ThemeData theme) {
    return InkWell(
      onTap: () => setState(() => _selectedTab = title),
      splashColor: theme.splashColor,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.012, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedTab == title
                  ? theme.colorScheme.primary
                  : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          color: theme.colorScheme.surface,
          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTab('DAY', theme),
              _buildTab('WEEK', theme),
              _buildTab('MONTH', theme),
              _buildTab('YEAR', theme),
            ],
          ),
        ),
        Container(
          color: theme.colorScheme.background,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: BlocBuilder<ChartDateCubit, DateTime>(
            builder: (context, selectedDate) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => _changeDate(context, -1),
                    splashColor: theme.splashColor,
                    customBorder: const CircleBorder(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back_ios_rounded, color: theme.iconTheme.color, size: 22,),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => _pickDate(context),
                    splashColor: theme.splashColor,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_sharp, color: theme.iconTheme.color),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('dd | MMM | yy').format(selectedDate),
                            style: TextStyle(
                              color: theme.textTheme.bodyLarge?.color,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: selectedDate.isBefore(DateTime.now())
                        ? () => _changeDate(context, 1)
                        : null,
                    splashColor: theme.splashColor,
                    customBorder: const CircleBorder(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedDate.isBefore(DateTime.now())
                            ? theme.colorScheme.secondary.withOpacity(0.3)
                            : theme.colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.arrow_forward_ios_rounded, color: theme.iconTheme.color, size: 22,),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
