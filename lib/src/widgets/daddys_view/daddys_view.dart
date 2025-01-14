import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_weekly_daily_view.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_yearly_avg_view.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_yearly_sum_view.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_yearly_daily_view.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_monthly_daily_view.dart';

class DaddysView extends StatefulWidget {
  const DaddysView({super.key});

  @override
  State<DaddysView> createState() => _DaddysViewState();
}

class _DaddysViewState extends State<DaddysView> {
  late String daddysSelectedView;
  late String daddysAggregation;

  static const String groupSelectionValueYear = 'Jahr';
  static const String groupSelectionValueMonth = 'Monat';
  static const String groupSelectionValueWeek = 'Woche';
  static const String aggregationSelectionValueDay = 'Tag';
  static const String aggregationSelectionValueSum = 'Summe';
  static const String aggregationSelectionValueAvg = 'Durchschnitt';

  @override
  void initState() {
    super.initState();
    // Initialize default values to avoid null issues
    final settingsProvider = context.read<SettingsProvider>();
    daddysSelectedView = settingsProvider.daddysSelectedView;
    daddysAggregation = settingsProvider.daddysAggregation;
  }

  void _updateSelectedView(String newValue) {
    setState(() {
      daddysSelectedView = newValue;
    });
    // Persist the selection to SettingsProvider
    context.read<SettingsProvider>().updateDaddysSelectedView(newValue);
  }

  void _updateSelectedAggregation(String newValue) {
    setState(() {
      daddysAggregation = newValue;
    });
    // Persist the toggle state to SettingsProvider
    context.read<SettingsProvider>().setShowDaddysAggregation(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, settingsProvider, child) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Row(
                  children: [groupSelectionValueYear, groupSelectionValueMonth, groupSelectionValueWeek]
                      .map(
                        (view) => Row(
                          children: [
                            Radio<String>(
                              value: view,
                              groupValue: daddysSelectedView,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  _updateSelectedView(newValue);
                                }
                              },
                            ),
                            Text(view, style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(width: 16),
              settingsProvider.daddysSelectedView == groupSelectionValueYear
                  ? Row(
                      children: [aggregationSelectionValueDay, aggregationSelectionValueSum, aggregationSelectionValueAvg]
                          .map(
                            (aggregation) => Row(
                              children: [
                                Radio<String>(
                                  value: aggregation,
                                  groupValue: daddysAggregation,
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      _updateSelectedAggregation(newValue);
                                    }
                                  },
                                ),
                                Text(aggregation, style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          )
                          .toList(),
                    )
                  : const SizedBox(width: 100),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 16),
          // Display the appropriate view
          Expanded(child: _buildView(showConsumption: settingsProvider.showConsumption, showReading: settingsProvider.showReading, showTemperature: settingsProvider.showTemperature, showFeelsLike: settingsProvider.showFeelsLike)),
        ],
      );
    });
  }

  Widget _buildView({required bool showConsumption, required bool showReading, required bool showTemperature, required bool showFeelsLike}) {
    switch (daddysAggregation) {
      case aggregationSelectionValueSum:
        return _buildSumsView(selectedView: daddysSelectedView, showConsumption: showConsumption, showReading: showReading, showTemperature: showTemperature, showFeelsLike: showFeelsLike);
      case aggregationSelectionValueAvg:
        return _buildAverageView(selectedView: daddysSelectedView, showConsumption: showConsumption, showReading: showReading, showTemperature: showTemperature, showFeelsLike: showFeelsLike);
      default:
        return _buildGroupView(selectedView: daddysSelectedView, showConsumption: showConsumption, showReading: showReading, showTemperature: showTemperature, showFeelsLike: showFeelsLike);
    }
  }

  Widget _buildGroupView({required String selectedView, required bool showConsumption, required bool showReading, required bool showTemperature, required bool showFeelsLike}) {
    switch (selectedView) {
      case groupSelectionValueMonth:
        return DaddysMonthlyDailyView(showConsumption: showConsumption, showReading: showReading, showTemperature: showTemperature, showFeelsLike: showFeelsLike);
      case groupSelectionValueWeek:
        return DaddysWeeklyDailyView(showConsumption: showConsumption, showReading: showReading, showTemperature: showTemperature, showFeelsLike: showFeelsLike);
      default:
        return DaddysYearlyDailyView(showConsumption: showConsumption, showReading: showReading, showTemperature: showTemperature, showFeelsLike: showFeelsLike);
    }
  }

  Widget _buildSumsView({required String selectedView, required bool showConsumption, required bool showReading, required bool showTemperature, required bool showFeelsLike}) {
    switch (selectedView) {
      case groupSelectionValueYear:
        return DaddysYearlySumView(showConsumption: showConsumption, showReading: showReading, showTemperature: showTemperature, showFeelsLike: showFeelsLike);
      default:
        return Text('Summierung nicht möglich', style: Theme.of(context).textTheme.bodyMedium);
    }
  }

  Widget _buildAverageView({required String selectedView, required bool showConsumption, required bool showReading, required bool showTemperature, required bool showFeelsLike}) {
    switch (selectedView) {
      case groupSelectionValueYear:
        return DaddysYearlyAvgView(showConsumption: showConsumption, showReading: showReading, showTemperature: showTemperature, showFeelsLike: showFeelsLike);
      default:
        return Text('Aggregation nicht möglich', style: Theme.of(context).textTheme.bodyMedium);
    }
  }
}
