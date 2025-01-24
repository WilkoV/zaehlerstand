import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';

class ServerConfigurationDialog extends StatelessWidget {
  const ServerConfigurationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        final serverAddressController = TextEditingController(text: settingsProvider.serverAddress);
        final serverPortController = TextEditingController(text: settingsProvider.serverPort);

        void _saveAndClose() {
          if (serverAddressController.text.isNotEmpty) {
            settingsProvider.updateServerAddress(serverAddressController.text);
          }
          if (serverPortController.text.isNotEmpty) {
            settingsProvider.updateServerPort(serverPortController.text);
          }
          Navigator.of(context).pop();
        }

        return AlertDialog(
          title: Text('Server konfigurieren', style: Theme.of(context).textTheme.headlineMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: Theme.of(context).textTheme.headlineLarge,
                controller: serverAddressController,
                decoration: const InputDecoration(
                  labelText: 'Serveradresse',
                  border: OutlineInputBorder(),
                  hintText: 'Serveradresse eingeben',
                ),
                keyboardType: TextInputType.number,
                autofocus: true,
                onSubmitted: (_) => _saveAndClose(),
              ),
              const SizedBox(height: 16),
              TextField(
                style: Theme.of(context).textTheme.headlineLarge,
                controller: serverPortController,
                decoration: const InputDecoration(
                  labelText: 'Server Port',
                  border: OutlineInputBorder(),
                  hintText: 'Serverport eingeben',
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _saveAndClose(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Abbrechen',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).indicatorColor,
                    ),
              ),
            ),
            TextButton(
              onPressed: _saveAndClose,
              child: Text(
                'Speichern',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).indicatorColor,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
