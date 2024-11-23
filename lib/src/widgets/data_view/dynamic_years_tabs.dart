import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';

class DynamicYearsTab extends StatelessWidget {
  const DynamicYearsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return DefaultTabController(
          length: dataProvider.dataYears.length,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 6,
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Theme.of(context).indicatorColor,
                indicatorWeight: 7.0,
                tabs: dataProvider.dataYears.map((year) {
                  return Tab(
                    // Use the text style from the theme
                    child: Text(
                      year.toString(), style: Theme.of(context).textTheme.headlineMedium, // Apply the desired text style here
                    ),
                  );
                }).toList(),
              ),
            ),
            body: TabBarView(
              children: dataProvider.dataYears.map((year) {
                // Replace this with the actual content for the specific year
                return Center(
                    child: Text(
                  'Content for year $year',
                  style: Theme.of(context).textTheme.bodyLarge,
                ));
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
