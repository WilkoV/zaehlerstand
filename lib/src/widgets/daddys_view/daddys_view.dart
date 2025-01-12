import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_detailed_daily_view.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_detailed_monthly_view.dart';

class DaddysView extends StatefulWidget {
  const DaddysView({super.key});

  @override
  State<DaddysView> createState() => _DaddysViewState();
}

class _DaddysViewState extends State<DaddysView> {
  late String daddysSelectedView;
  late String daddysAggregation;

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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Row(
                children: ['Tag', 'Monat', 'Jahr']
                    .map((view) => Row(
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
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(width: 16),
            daddysSelectedView != 'Tag'
                ? Row(
                    children: ['Tag', 'Summe', 'Durchschnitt']
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
                : const Expanded(
                    flex: 1,
                    child: Text('Keine Aggregierung möglich'),
                  ),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 16),
        // Display the appropriate view
        Expanded(
          child: _buildView(),
        ),
      ],
    );
  }

  Widget _buildView() {
    final settingsProvider = context.read<SettingsProvider>();

    switch (daddysAggregation) {
      case 'Summe':
        return _buildSumsView(selectedView: daddysSelectedView, settingsProvider: settingsProvider);
      case 'Durchschnitt':
        return _buildAverageView(selectedView: daddysSelectedView, settingsProvider: settingsProvider);
      default:
        return _buildDetailView(selectedView: daddysSelectedView, settingsProvider: settingsProvider);
    }
  }

  Widget _buildDetailView({required String selectedView, required SettingsProvider settingsProvider}) {
    switch (selectedView) {
      case 'Woche':
        return Text('Wöchentlich / Detail ist nicht implementiert', style: Theme.of(context).textTheme.bodyMedium);
      case 'Monat':
        return DaddysDetailedMonthlyView(
          showConsumption: settingsProvider.showConsumption,
          showReading: settingsProvider.showReading,
          showTemperature: settingsProvider.showTemperature,
          showFeelsLike: settingsProvider.showFeelsLike,
        );
      case 'Jahr':
        return Text('Jährlich / Detail ist nicht implementiert', style: Theme.of(context).textTheme.bodyMedium);
      default:
        return DaddysDetailedDailyView(
          showConsumption: settingsProvider.showConsumption,
          showReading: settingsProvider.showReading,
          showTemperature: settingsProvider.showTemperature,
          showFeelsLike: settingsProvider.showFeelsLike,
        );
    }
  }

  Widget _buildSumsView({required String selectedView, required SettingsProvider settingsProvider}) {
    switch (selectedView) {
      case 'Monat':
        return Text('Monatlich / Summe ist nicht implementiert', style: Theme.of(context).textTheme.bodyMedium);
      case 'Jahr':
        return Text('Jährlich / Summe ist nicht implementiert', style: Theme.of(context).textTheme.bodyMedium);
      default:
        return Text('Täglich / Summe ist nicht implementiert', style: Theme.of(context).textTheme.bodyMedium);
    }
  }

  Widget _buildAverageView({required String selectedView, required SettingsProvider settingsProvider}) {
    switch (selectedView) {
      case 'Monat':
        return Text('Monatlich / Durchschnitt ist nicht implementiert', style: Theme.of(context).textTheme.bodyMedium);
      case 'Jahr':
        return Text('Jährlich / Durchschnitt ist nicht implementiert', style: Theme.of(context).textTheme.bodyMedium);
      default:
        return Text('Täglich / Durchschnitt ist nicht implementiert', style: Theme.of(context).textTheme.bodyMedium);
    }
  }
}
