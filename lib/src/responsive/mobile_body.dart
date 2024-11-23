import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/constants/provider_status.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_view/dynamic_years_tabs.dart';

class MobileBody extends StatelessWidget {
  const MobileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (_, notifier, __) {
        return notifier.status.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                backgroundColor: Colors.purple[300],
                body: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                        child: Container(
                          color: Colors.deepPurple[400],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
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
