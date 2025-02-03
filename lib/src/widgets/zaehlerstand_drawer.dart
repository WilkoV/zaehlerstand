import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand/src/widgets/dialogs/dashboard_configuration_dialog.dart';
import 'package:zaehlerstand/src/widgets/dialogs/server_configuration_dialog.dart';
import 'package:zaehlerstand/src/widgets/labeled_divider.dart';

class ZaehlerstandDrawer extends StatelessWidget {
  const ZaehlerstandDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
          ),
          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: Text('Dark Mode', style: Theme.of(context).textTheme.bodyMedium),
                    value: settingsProvider.isDarkMode,
                    onChanged: (value) {
                      settingsProvider.toggleTheme();
                    },
                  ),
                  const LabeledDivider(message: 'Sichtbare Felder', spacing: 8, thickness: 2),
                  SwitchListTile(
                    title: Text('Verbrauch', style: Theme.of(context).textTheme.bodyMedium),
                    value: settingsProvider.showConsumption,
                    onChanged: (value) {
                      settingsProvider.toggleShowConsumption();
                    },
                  ),
                  SwitchListTile(
                    title: Text('Zählerstand', style: Theme.of(context).textTheme.bodyMedium),
                    value: settingsProvider.showReading,
                    onChanged: (value) {
                      settingsProvider.toggleShowReading();
                    },
                  ),
                  SwitchListTile(
                    title: Text('Temperatur', style: Theme.of(context).textTheme.bodyMedium),
                    value: settingsProvider.showTemperature,
                    onChanged: (value) {
                      settingsProvider.toggleShowTemperature();
                    },
                  ),
                  SwitchListTile(
                    title: Text('Gefühlt', style: Theme.of(context).textTheme.bodyMedium),
                    value: settingsProvider.showFeelsLike,
                    onChanged: (value) {
                      settingsProvider.toggleShowFeelsLike();
                    },
                  ),
                  const SizedBox(height: 100),
                  const LabeledDivider(message: 'Dashboard', spacing: 8, thickness: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const DashboardConfigurationDialog(),
                        );
                      },
                      child: Text(
                        'Versatz konfigurieren',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).indicatorColor,
                            ),
                      ),
                    ),
                  ),
                  const LabeledDivider(message: 'Server', spacing: 8, thickness: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _showServerDialog(context);
                      },
                      child: Text(
                        'Verbindung konfigurieren',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Theme.of(context).indicatorColor),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  
  void _showServerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ServerConfigurationDialog(),
    );
  }
}
