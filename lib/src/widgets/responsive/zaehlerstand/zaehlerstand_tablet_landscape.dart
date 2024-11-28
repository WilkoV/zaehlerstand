import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_view/dynamic_years_tabs.dart';

class ZaehlerstandTabletLandscape extends StatelessWidget {
  ZaehlerstandTabletLandscape({super.key});

  final Logger _log = Logger('TabletLandscape');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building tablet landscape mode');

    return Consumer<DataProvider>(
      builder: (_, notifier, __) {
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
            ],
          ),
        );
      },
    );
  }
}
