import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_view/dynamic_years_tabs.dart';
import 'package:zaehlerstand/src/widgets/progress_bars/add_meter_reading_progress_bar.dart';

class ZaehlerstandTabletPortrait extends StatelessWidget {
  ZaehlerstandTabletPortrait({super.key});

  final Logger _log = Logger('TabletPortrait');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building tablet portrait mode');

    return Consumer<DataProvider>(
      builder: (_, notifier, __) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                  child: Container(
                    color: Colors.deepPurple[400],
                  ),
                ),
              ),
              const Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                  child: DynamicYearsTab(),
                ),
              ),
              const AddMeterReadingProgressBar(),
            ],
          ),
        );
      },
    );
  }
}
