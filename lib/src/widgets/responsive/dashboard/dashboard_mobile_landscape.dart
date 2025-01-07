import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/widgets/dashboard_summary/dashboard_summary.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/years_tabs.dart';

class DashboardMobileLandscape extends StatelessWidget {
  DashboardMobileLandscape({super.key});

  final Logger _log = Logger('TabletLandscape');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building mobile landscape mode');

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                    // child: DashboardSummery(),
                    child: Container(color: Colors.red),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                    // child: YearsTab(),
                    child: Container(color: Colors.yellow),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
