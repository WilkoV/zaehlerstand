import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/constants/provider_status.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_view/dynamic_years_tabs.dart';

class ZaehlerstandMobilePortrait extends StatelessWidget {
  ZaehlerstandMobilePortrait({super.key});

  final Logger _log = Logger('MobilePortrait');

  @override
  Widget build(BuildContext context) {
    _log.fine('Building mobile portrait mode');
    
    return Consumer<DataProvider>(
      builder: (_, notifier, __) {
        return notifier.status.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.yellow[300],
                  body: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                          child: Container(
                            color: Colors.deepOrange[400],
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                          child: DynamicYearsTab(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
