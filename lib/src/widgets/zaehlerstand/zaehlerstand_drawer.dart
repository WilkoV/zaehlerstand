import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';

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
                  // Dark Mode Switch
                  SwitchListTile(
                    title: Text('Dark Mode', style: Theme.of(context).textTheme.bodyMedium),
                    value: settingsProvider.isDarkMode,
                    onChanged: (value) {
                      settingsProvider.toggleTheme();
                    },
                  ),
                  // Server Address Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Server Adresse',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: TextEditingController(text: settingsProvider.serverAddress)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: settingsProvider.serverAddress.length),
                        ),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Serveradresse eingeben',
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          settingsProvider.updateServerAddress(value);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Server Port',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: TextEditingController(text: settingsProvider.serverPort)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: settingsProvider.serverPort.length),
                        ),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Server port eingeben',
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          settingsProvider.updateServerAddress(value);
                        }
                      },
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
}
