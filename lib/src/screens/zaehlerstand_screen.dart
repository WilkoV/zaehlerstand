import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/models/base/reading.dart';
import 'package:zaehlerstand/src/models/logic/reading_logic.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/responsive/zaehlerstand/zaehlerstand_responsive_layout.dart';
import 'package:zaehlerstand/src/widgets/dialogs/reading_dialog.dart';
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
          body: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: dataProvider.isLoading ? const Center(child: CircularProgressIndicator()) : const ZaehlerstandResponsiveLayout(),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).indicatorColor,
            onPressed: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (context) => ReadingDialog(
                  minimalReadingValue: _getMinimumValue(dataProvider),
                  zaehlerstandController: TextEditingController(
                    text: dataProvider.getFirstReading().getFirstTwoDigitsFromReading(dataProvider.getAverageDailyConsumption(7)),
                  ),
                ),
              );

              if (result != null) {
                dataProvider.addReading(int.parse(result));
                _log.fine(result);
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  int _getMinimumValue(DataProvider dataProvider) => dataProvider.readings.isNotEmpty ? dataProvider.readings.first.reading : 0;
}
