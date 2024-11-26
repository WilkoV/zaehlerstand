import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/constants/provider_status.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_view/dynamic_years_tabs.dart';

class ZaehlerstandMobileLandscape extends StatelessWidget {
  ZaehlerstandMobileLandscape({super.key});

  final Logger _log = Logger('TabletLandscape');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building mobile landscape mode'); 

    return Consumer<DataProvider>(
      builder: (_, notifier, __) {
        return notifier.status.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
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
                ],
              ),
            );
      },
    );
  }
}
