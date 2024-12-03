import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_view/reading_list_widget.dart';

class YearsTab extends StatelessWidget {
  const YearsTab({super.key});

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
                    child: Text(year.toString(), style: Theme.of(context).textTheme.headlineMedium),
                  );
                }).toList(),
              ),
            ),
            body: TabBarView(
              children: dataProvider.dataYears.map((year) {
                return ReadingListWidget(year: year);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
