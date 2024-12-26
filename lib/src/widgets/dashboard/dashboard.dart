import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/dashboard/dashboard_daily_consumption_row.dart';
import 'package:zaehlerstand/src/widgets/dashboard/dashboard_monthly_consumption_row.dart';
import 'package:zaehlerstand/src/widgets/dashboard/dashboard_yearly_consumption_row.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return const Column(
          children: [
            DashboardDailyConsumptionRow(),
            Divider(),
            DashboardMonthlyConsumption(),
            Divider(),
            DashboardYearlyConsumption(),
          ],
        );
      },
    );
  }
}
