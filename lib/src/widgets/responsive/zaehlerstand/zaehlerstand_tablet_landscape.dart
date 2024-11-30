import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_view/dynamic_years_tabs.dart';
import 'package:zaehlerstand/src/widgets/responsive/progress_indicators/add_meter_reading_progress_indicator_mobile/add_meter_reading_progress_indicator_responsive_layout.dart';
import 'package:zaehlerstand/src/widgets/responsive/progress_indicators/synchronizing_to_google_sheets_progress_indicator/synchronizing_to_google_sheets_progress_indicator_responsive_layout.dart';

class ZaehlerstandTabletLandscape extends StatelessWidget {
  ZaehlerstandTabletLandscape({super.key});

  final Logger _log = Logger('TabletLandscape');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building tablet landscape mode');

    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        return Scaffold(
          backgroundColor: Colors.green[300],
          body: Column(
            // Use Column as the top-level container for vertical layout
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
              ),
              if (dataProvider.isAddingMeterReadings)
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 90),
                        child: AddMeterReadingProgressIndicatorResponsiveLayout(),
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
