import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/widgets/data_view/dynamic_years_tabs.dart';
import 'package:zaehlerstand/src/widgets/progress_bars/add_meter_reading_progress_bar.dart';

class ZaehlerstandTabletLandscape extends StatelessWidget {
  ZaehlerstandTabletLandscape({super.key});

  final Logger _log = Logger('TabletLandscape');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building tablet landscape mode');

    return Scaffold(
      backgroundColor: Colors.green[300],
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
              child: Container(
                color: Colors.green[600],
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
  }
}
