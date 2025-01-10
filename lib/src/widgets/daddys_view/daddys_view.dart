import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_yearly_view.dart';

class DaddysView extends StatefulWidget {
  const DaddysView({super.key});

  @override
  State<DaddysView> createState() => _DaddysViewState();
}

class _DaddysViewState extends State<DaddysView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Column(
          children: [
            // Settings section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Show Reading Toggle
                Row(
                  children: [
                    Text('Verbrauch', style: Theme.of(context).textTheme.bodyMedium),
                    Switch(
                      value: settingsProvider.showConsumption,
                      onChanged: (value) {
                        settingsProvider.toggleShowConsumption();
                      },
                    ),
                  ],
                ),
                // Show Reading Toggle
                Row(
                  children: [
                    Text('Zählerstand', style: Theme.of(context).textTheme.bodyMedium),
                    Switch(
                      value: settingsProvider.showReading,
                      onChanged: (value) {
                        settingsProvider.toggleShowReading();
                      },
                    ),
                  ],
                ),
                // Show Temperature Toggle
                Row(
                  children: [
                    Text('Temperatur', style: Theme.of(context).textTheme.bodyMedium),
                    Switch(
                      value: settingsProvider.showTemperature,
                      onChanged: (value) {
                        settingsProvider.toggleShowTemperature();
                      },
                    ),
                  ],
                ),
                // Show Feels Like Toggle
                Row(
                  children: [
                    Text('Gefühlt', style: Theme.of(context).textTheme.bodyMedium),
                    Switch(
                      value: settingsProvider.showFeelsLike,
                      onChanged: (value) {
                        settingsProvider.toggleShowFeelsLike();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16), // Spacing between settings and view
            // DaddysYearlyView
            Expanded(
              child: DaddysYearlyView(
                showConsumption: settingsProvider.showConsumption,
                showReading: settingsProvider.showReading,
                showTemperature: settingsProvider.showTemperature,
                showFeelsLike: settingsProvider.showFeelsLike,
              ),
            ),
          ],
        );
      },
    );
  }
}
