import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/models/base/progress_update.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';

class SynchronizingToGoogleSheetsProgressIndicatorTablet extends StatelessWidget {
  const SynchronizingToGoogleSheetsProgressIndicatorTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        // Early exit if not adding meter readings
        if (!dataProvider.isSynchronizingToGoogleSheets) return const SizedBox.shrink();

        return StreamBuilder<ProgressUpdate>(
          stream: dataProvider.syncMeterReadingsProgressStream,
          builder: (context, snapshot) {
            // If the stream is not providing any data or is waiting, hide the progress bar
            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();  // Hide the progress bar if no data or waiting
            }

            final progress = snapshot.data!;
            final progressValue = progress.total > 0 ? progress.current / progress.total : 0.0;

            // Avoid displaying the progress bar for 0% progress if not desired
            if (progressValue == 0.0 && progress.current == 0) {
              return const SizedBox.shrink();  // Hide if the progress is 0%
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      minHeight: 18,
                      color: Theme.of(context).indicatorColor,
                      value: progressValue,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
