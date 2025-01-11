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
  String selectedView = 'Täglich';
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text('Ansicht: ', style: Theme.of(context).textTheme.bodyMedium),
                    DropdownButton<String>(
                      value: selectedView,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedView = newValue!;
                        });
                      },
                      items: <String>['Täglich', 'Wöchentlich', 'Monatlich', 'Jährlich'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Durchschnitt Toggle (only available if "Täglich" is selected)
                if (selectedView != 'Täglich')
                  Row(
                    children: [
                      Text('Durchschnitt', style: Theme.of(context).textTheme.bodyMedium),
                      Switch(
                        value: settingsProvider.showAverage,
                        onChanged: (value) {
                          settingsProvider.toggleShowAverage();
                        },
                      ),
                    ],
                  )
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
