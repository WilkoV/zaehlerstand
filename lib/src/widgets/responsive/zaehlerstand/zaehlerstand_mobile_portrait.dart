import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/widgets/data_view/dynamic_years_tabs.dart';
import 'package:zaehlerstand/src/widgets/progress_bars/add_meter_reading_progress_bar.dart';

class ZaehlerstandMobilePortrait extends StatelessWidget {
  ZaehlerstandMobilePortrait({super.key});

  final Logger _log = Logger('MobilePortrait');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building mobile portrait mode');

    return Scaffold(
      backgroundColor: Colors.yellow[300],
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
              child: Container(
                color: Colors.deepOrange[400],
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
