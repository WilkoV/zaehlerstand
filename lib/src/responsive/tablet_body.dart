import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/constants/provider_status.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_view/dynamic_years_tabs.dart';

class TabletBody extends StatelessWidget {
  const TabletBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (_, notifier, __) {
        return notifier.status.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                backgroundColor: Colors.lightBlue[300],
                body: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
                        child: Container(
                          color: Colors.blue[400],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(6, 12, 12, 12),
                        child: DynamicYearsTab(),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
