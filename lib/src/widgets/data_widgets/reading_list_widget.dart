import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/reading_card.dart';

class ReadingListWidget extends StatelessWidget {
  final int year;

  const ReadingListWidget({
    super.key,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      return Scaffold(
        body: dataProvider.groupedReadings.isEmpty || dataProvider.groupedReadings[year]!.isEmpty
            ? Center(child: Text("Keine Daten gefunden", style: Theme.of(context).textTheme.bodyLarge))
            : ListView.builder(
                itemCount: dataProvider.groupedReadings[year]!.length,
                itemBuilder: (context, index) {
                  final reading = dataProvider.groupedReadings[year]![index];
                  final dailyConsumption = dataProvider.yearlyGroupedDailyConsumptions[year]![index];
      
                  return ReadingCard(dailyConsumption: dailyConsumption, reading: reading);
                },
              ),
      );
    });
  }
}
