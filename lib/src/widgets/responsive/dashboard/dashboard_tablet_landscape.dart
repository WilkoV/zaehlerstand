import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/widgets/dashboard_summary/dashboard_summary.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/years_tabs.dart';

class DashboardTabletLandscape extends StatelessWidget {
  DashboardTabletLandscape({super.key});

  final Logger _log = Logger('TabletLandscape');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building tablet landscape mode');

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              // Row for horizontal layout
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                    // child: DashboardSummery(),
                    child: Container(color: Colors.yellow),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                    // child: YearsTab(),
                    child: Container(color: Colors.blue),

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
