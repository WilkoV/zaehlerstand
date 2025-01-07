import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/widgets/dashboard_summary/dashboard_summary.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/years_tabs.dart';

class DashboardMobilePortrait extends StatelessWidget {
  DashboardMobilePortrait({super.key});

  final Logger _log = Logger('MobilePortrait');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building mobile portrait mode');

    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
              // child: DashboardSummery(),
              child: Container(color: Colors.blue),
            ),
          ),
          Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
              // child: YearsTab(),
              child: Container(color: Colors.yellow),
            ),
          ),
        ],
      ),
    );
  }
}
