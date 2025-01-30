import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand/src/widgets/responsive/charts/monthly_charts_layout.dart';

class ChartsView extends StatefulWidget {
  const ChartsView({super.key});

  @override
  State<ChartsView> createState() => _ChartsViewState();
}

class _ChartsViewState extends State<ChartsView> {
  late String chartsSelectedView;
  late String chartsAggregation;

  static const String groupSelectionValueMonth = 'Monat';
  static const String groupSelectionValueWeek = 'Woche';

  @override
  void initState() {
    super.initState();
    // Initialize default values to avoid null issues
    final settingsProvider = context.read<SettingsProvider>();
    chartsSelectedView = settingsProvider.chartsSelectedView;
  }

  void _updateSelectedView(String newValue) {
    setState(() {
      chartsSelectedView = newValue;
    });
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
                  children: [groupSelectionValueMonth, groupSelectionValueWeek]
                      .map(
                        (view) => Row(
                          children: [
                            Radio<String>(
                              value: view,
                              groupValue: chartsSelectedView,
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
            ],
          ),
          const SizedBox(height: 16),
          // Display the appropriate view
          Expanded(
              child: _buildView(
            context: context,
          )),
        ],
      );
    });
  }

  Widget _buildView({required BuildContext context}) {
    if (chartsSelectedView == groupSelectionValueMonth) {
      return const MonthlyChartsResponsiveLayout();
    }

    return const Text('Bla bla bla');
  }
}
