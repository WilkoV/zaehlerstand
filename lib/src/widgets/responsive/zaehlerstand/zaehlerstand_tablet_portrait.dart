import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/reading_consumption_dashboard.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/years_tabs.dart';
import 'package:zaehlerstand/src/widgets/responsive/progress_indicators/add_reading_progress_indicator_mobile/add_reading_progress_indicator_responsive_layout.dart';
import 'package:zaehlerstand/src/widgets/responsive/progress_indicators/synchronizing_to_google_sheets_progress_indicator/synchronizing_to_google_sheets_progress_indicator_responsive_layout.dart';

class ZaehlerstandTabletPortrait extends StatelessWidget {
  ZaehlerstandTabletPortrait({super.key});

  final Logger _log = Logger('TabletPortrait');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building tablet portrait mode');

    return Consumer<DataProvider>(
      builder: (_, dataProvider, __) {
        return Scaffold(
          body: Column(
            children: [
              const Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                  child: ReadingConsumptionDashboard(),
                ),
              ),
              const Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                  child: YearsTab(),
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
