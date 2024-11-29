import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/widgets/data_view/dynamic_years_tabs.dart';
import 'package:zaehlerstand/src/widgets/progress_bars/add_meter_reading_progress_bar.dart';

class ZaehlerstandMobileLandscape extends StatelessWidget {
  ZaehlerstandMobileLandscape({super.key});

  final Logger _log = Logger('TabletLandscape');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building mobile landscape mode');

    return Scaffold(
      backgroundColor: Colors.brown[300],
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
              child: Container(
                color: Colors.brown[600],
              ),
            ),
          ),
          const Expanded(
            flex: 2,
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
