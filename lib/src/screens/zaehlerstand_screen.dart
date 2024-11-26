import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/responsive/zaehlerstand/zaehlerstand_responsive_layout.dart';
import 'package:zaehlerstand/src/widgets/zaehlerstand/show_meter_reading_dialog.dart';
import 'package:zaehlerstand/src/widgets/zaehlerstand/zaehlerstand_drawer.dart';

class ZaehlerstandScreen extends StatefulWidget {
  const ZaehlerstandScreen({super.key});

  @override
  State<ZaehlerstandScreen> createState() => _ZaehlerstandScreenState();
}

class _ZaehlerstandScreenState extends State<ZaehlerstandScreen> {
  late TextEditingController zaehlerstandController;
  final Logger _log = Logger('_ZaehlerstandScreenState');

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    // Dispose of the controller to avoid memory leaks.
    zaehlerstandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Zählerstand', style: Theme.of(context).textTheme.headlineLarge),
            centerTitle: true,
          ),
          drawer: const ZaehlerstandDrawer(),
          body: const Padding(
            padding: EdgeInsets.only(bottom: 16), // Adjust if needed
            child: ZaehlerstandResponsiveLayout(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // Show the dialog when the FAB is pressed.
              final result = await showDialog<String>(
                context: context,
                builder: (context) => MeterReadingDialog(
                  minimalReadingValue: _getMinimumValue(dataProvider),
                  zaehlerstandController: TextEditingController(text: _getFirstTwoDigitsFromNewestMeterReading(dataProvider)),
                ),
              );

              // Handle the result from the dialog.
              if (result != null) {
                dataProvider.addMeterReading(int.parse(result));
                _log.fine(result);
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  String _getFirstTwoDigitsFromNewestMeterReading(DataProvider dataProvider) => dataProvider.meterReadings.isNotEmpty ? dataProvider.meterReadings.first.reading.toString().substring(0, 2) : '';
  int _getMinimumValue(DataProvider dataProvider) => dataProvider.meterReadings.isNotEmpty ? dataProvider.meterReadings.first.reading : 0;
}
