import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/models/base/progress_update.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';

class AddMeterReadingProgressBar extends StatelessWidget {
  const AddMeterReadingProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        if (!dataProvider.isAddingMeterReadings) return const SizedBox.shrink();

        return StreamBuilder<ProgressUpdate>(
          stream: dataProvider.addMeterProgressStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Return an empty widget or placeholder when no data is present
              return const SizedBox.shrink();
            }

            if (snapshot.hasData) {
              final progress = snapshot.data!;
              double progressValue = progress.total > 0 ? progress.current / progress.total : 0.0;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      minHeight: 10,
                      color: Theme.of(context).indicatorColor,
                      value: progressValue,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Sichere: ${progress.current} von ${progress.total}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            // Return a fallback for an indeterminate progress indicator
            return const Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 30, 8),
              child: LinearProgressIndicator(), // Indeterminate progress
            );
          },
        );
      },
    );
  }
}
