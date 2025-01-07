import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/widgets/dashboard_summary/dashboard_summary.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/years_tabs.dart';

class DashboardTabletPortrait extends StatelessWidget {
  DashboardTabletPortrait({super.key});

  final Logger _log = Logger('TabletPortrait');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building tablet portrait mode');

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
              // child: DashboardSummery(),
              child: Container(color: Colors.blue),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
              // child: YearsTab(),
              child: Container(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
