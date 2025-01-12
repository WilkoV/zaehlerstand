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
  late String selectedView;
  late bool showAverage;

  @override
  void initState() {
    super.initState();
    // Initialize default values to avoid null issues
    final settingsProvider = context.read<SettingsProvider>();
    selectedView = settingsProvider.daddysSelectedView;
    showAverage = settingsProvider.showAverage;
  }

  void _updateSelectedView(String newValue) {
    setState(() {
      selectedView = newValue;
    });
    // Persist the selection to SettingsProvider
    context.read<SettingsProvider>().updateDaddysSelectedView(newValue);
  }

  void _toggleShowAverage(bool value) {
    setState(() {
      showAverage = value;
    });
    // Persist the toggle state to SettingsProvider
    context.read<SettingsProvider>().setShowAverage(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Row(
                children: ['Tag', 'Woche', 'Monat', 'Jahr']
                    .map((view) => Row(
                          children: [
                            Radio<String>(
                              value: view,
                              groupValue: selectedView,
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
            // Toggle for average view
            selectedView != 'Tag'
                ? Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Text('Durchschnitt', style: Theme.of(context).textTheme.bodyMedium),
                        Switch(
                          value: showAverage,
                          onChanged: (value) {
                            _toggleShowAverage(value);
                          },
                        ),
                      ],
                    ),
                  )
                : Expanded(flex: 1, child: Container()),
          ],
        ),
        const SizedBox(height: 16),
        // Display the appropriate view
        Expanded(
          child: showAverage
              ? _buildAverageView(
                  selectedView: selectedView,
                  settingsProvider: context.read<SettingsProvider>(),
                )
              : _buildDetailView(
                  selectedView: selectedView,
                  settingsProvider: context.read<SettingsProvider>(),
                ),
        ),
      ],
    );
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

  Widget _buildAverageView({required String selectedView, required SettingsProvider settingsProvider}) {
    switch (selectedView) {
      case 'Woche':
        return Text('Wöchentlich / Durchschnitt ist nicht implementiert', style: Theme.of(context).textTheme.bodyMedium);
      case 'Monat':
        return Text('Monatlich / Durchschnitt ist nicht implementiert', style: Theme.of(context).textTheme.bodyMedium);
      case 'Jahr':
        return Text('Jährlich / Durchschnitt ist nicht implementiert', style: Theme.of(context).textTheme.bodyMedium);
      default:
        return Text('Täglich / Durchschnitt ist nicht implementiert', style: Theme.of(context).textTheme.bodyMedium);
    }
  }
}
