import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      await dataProvider.initialize();
    } catch (e) {
      _log.severe('Error initializing data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Dispose of the controller to avoid memory leaks.
    zaehlerstandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Zählerstand', style: Theme.of(context).textTheme.headlineLarge),
            centerTitle: true,
          ),
          drawer: const ZaehlerstandDrawer(),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: dataProvider.isLoading ? const Center(child: CircularProgressIndicator()) : const ZaehlerstandResponsiveLayout(),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).indicatorColor,
            onPressed: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (context) => MeterReadingDialog(
                  minimalReadingValue: _getMinimumValue(dataProvider),
                  zaehlerstandController: TextEditingController(
                    text: _getFirstTwoDigitsFromNewestMeterReading(dataProvider),
                  ),
                ),
              );

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

  String _getFirstTwoDigitsFromNewestMeterReading(DataProvider dataProvider) {
    if (dataProvider.meterReadings.isEmpty) {
      return '';
    }

    MeterReading reading = dataProvider.meterReadings.first;
    var readingAsString = reading.reading.toString();
    int currentLength = readingAsString.length;

    if (currentLength < 3) {
      return '';
    }

    int targetPosition = currentLength - 3;

    return dataProvider.meterReadings.isNotEmpty ? readingAsString.substring(0, targetPosition) : '';
  }

  int _getMinimumValue(DataProvider dataProvider) => dataProvider.meterReadings.isNotEmpty ? dataProvider.meterReadings.first.reading : 0;
}
