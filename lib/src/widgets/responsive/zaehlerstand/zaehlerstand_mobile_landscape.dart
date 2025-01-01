import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/widgets/dashboard/dashboard.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/years_tabs.dart';

class ZaehlerstandMobileLandscape extends StatelessWidget {
  ZaehlerstandMobileLandscape({super.key});

  final Logger _log = Logger('TabletLandscape');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building mobile landscape mode');

    return const Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                    child: Dashboard(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                    child: YearsTab(),
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
