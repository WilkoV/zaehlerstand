import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_view/years_tabs.dart';
import 'package:zaehlerstand/src/widgets/responsive/progress_indicators/add_reading_progress_indicator_mobile/add_reading_progress_indicator_responsive_layout.dart';
import 'package:zaehlerstand/src/widgets/responsive/progress_indicators/synchronizing_to_google_sheets_progress_indicator/synchronizing_to_google_sheets_progress_indicator_responsive_layout.dart';

class ZaehlerstandMobileLandscape extends StatelessWidget {
  ZaehlerstandMobileLandscape({super.key});

  final Logger _log = Logger('TabletLandscape');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building mobile landscape mode');

    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        return Scaffold(
          backgroundColor: Colors.brown[300],
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
                        child: Container(
                          color: Colors.brown[600],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                        child: YearsTab(),
                      ),
                    ),
                  ],
                ),
              ),
              if (dataProvider.isAddingReadings)
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 90),
                        child: AddReadingProgressIndicatorResponsiveLayout(),
                      ),
                    ),
                  ],
                ),
              if (dataProvider.isSynchronizingToGoogleSheets)
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 90),
                        child: SynchronizingToGoogleSheetsProgressIndicatorResponsiveLayout(),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
