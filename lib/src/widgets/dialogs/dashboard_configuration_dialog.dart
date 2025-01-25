import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';

class DashboardConfigurationDialog extends StatelessWidget {
  const DashboardConfigurationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        final daysController = TextEditingController(text: settingsProvider.dashboardDays.join(', '));
        final monthsController = TextEditingController(text: settingsProvider.dashboardMonths.join(', '));
        final yearsController = TextEditingController(text: settingsProvider.dashboardYears.join(', '));

        void saveAndClose() {
          settingsProvider.updateDashboardDays(
            _parseListFromString(daysController.text),
          );
          settingsProvider.updateDashboardMonths(
            _parseListFromString(monthsController.text),
          );
          settingsProvider.updateDashboardYears(
            _parseListFromString(yearsController.text),
          );
          Navigator.of(context).pop();
        }

        return AlertDialog(
          title: Text('Versatz Konfigurieren', style: Theme.of(context).textTheme.headlineMedium),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(
                  label: 'Dashboard Days',
                  controller: daysController,
                  onSubmitted: saveAndClose,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Dashboard Months',
                  controller: monthsController,
                  onSubmitted: saveAndClose,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Dashboard Years',
                  controller: yearsController,
                  onSubmitted: saveAndClose,
                ),
              ],
            ),
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
              onPressed: saveAndClose,
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

  List<int> _parseListFromString(String input) {
    return input.split(',').map((e) => int.tryParse(e.trim())).where((e) => e != null).cast<int>().toList();
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onSubmitted,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        hintText: 'Kommagetrennte Werte eingeben',
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done, 
      onSubmitted: (_) => onSubmitted(), 
    );
  }
}
