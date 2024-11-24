import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_view/meter_reading_list_widget.dart';
import 'package:zaehlerstand/src/widgets/text/test_heading_medium.dart';

class DynamicYearsTab extends StatelessWidget {
  const DynamicYearsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return DefaultTabController(
          length: dataProvider.dataYears.length,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 6,
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Theme.of(context).indicatorColor,
                  indicatorWeight: 7.0,
                  tabs: dataProvider.dataYears.map((year) {
                    return Tab(
                      child: TextHeadingMedium(year.toString()),
                    );
                  }).toList(),
                ),
              ),
              body: TabBarView(
                children: dataProvider.dataYears.map((year) {
                  return MeterReadingListWidget(meterReadings: dataProvider.meterReadings, year: year);
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
