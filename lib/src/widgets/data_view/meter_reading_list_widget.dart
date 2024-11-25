import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/responsive/meter_reading/meter_reading_responsive_layout.dart';

class MeterReadingListWidget extends StatelessWidget {
  final int year;

  const MeterReadingListWidget({
    super.key,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      return SafeArea(
        child: Scaffold(
          body: dataProvider.groupedMeterReadings.isEmpty || dataProvider.groupedMeterReadings[year]!.isEmpty
              ? Center(child: Text("Keine Daten gefunden", style: Theme.of(context).textTheme.bodyLarge))
              : ListView.builder(
                  itemCount: dataProvider.groupedMeterReadings[year]!.length,
                  itemBuilder: (context, index) {
                    final reading = dataProvider.groupedMeterReadings[year]![index];
                    final dailyConsumption = dataProvider.groupedDailyConsumptions[year]![index];

                    return MeterReadingCardResponsiveLayout(dailyConsumption: dailyConsumption, meterReading: reading);
                  },
                ),
        ),
      );
    });
  }
}
