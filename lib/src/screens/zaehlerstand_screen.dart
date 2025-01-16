import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/models/base/reading_dialog_result.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_view.dart';
import 'package:zaehlerstand/src/widgets/dialogs/reading_dialog.dart';
import 'package:zaehlerstand/src/widgets/zaehlerstand_drawer.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class ZaehlerstandScreen extends StatefulWidget {
  const ZaehlerstandScreen({super.key});

  @override
  State<ZaehlerstandScreen> createState() => _ZaehlerstandScreenState();
}

class _ZaehlerstandScreenState extends State<ZaehlerstandScreen> with WidgetsBindingObserver {
  late TextEditingController zaehlerstandController;

  int _selectedIndex = 0;

  final List<Widget> _views = [
    const Center(child: Text('Dashboard')),
    const Center(child: Text('Diagramme')),
    const DaddysView(),
  ];

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    zaehlerstandController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _refreshData() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.refreshDisplay();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Zählerstand', style: Theme.of(context).textTheme.headlineLarge),
            centerTitle: true,
          ),
          drawer: const ZaehlerstandDrawer(),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: dataProvider.isLoading ? const Center(child: CircularProgressIndicator()) : _views[_selectedIndex],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).indicatorColor,
            onPressed: () async {
              final result = await showDialog<ReadingDialogResult>(
                context: context,
                builder: (context) {
                  int minReadingValue = dataProvider.currentReading != null ? dataProvider.currentReading!.reading : 0;
                  DateTime minimalDateValue = dataProvider.currentReading?.date != null ? dataProvider.currentReading!.date.add(const Duration(days: 1)) : DateTime.now();
                  int numberOfDays = dataProvider.currentReading != null ? DateTime.now().difference(dataProvider.currentReading!.date).inDays : 0;
                  int avgDailyConsumption = dataProvider.last7ConsumptionAverage.round();

                  return ReadingDialog(
                    minimalReadingValue: minReadingValue,
                    minimalDateValue: minimalDateValue,
                    zaehlerstandController: TextEditingController(
                      text: dataProvider.currentReading != null
                          ? dataProvider.currentReading!.getFirstTwoDigitsFromReading(
                              avgDailyConsumption: avgDailyConsumption,
                              numberOfDays: numberOfDays,
                            )
                          : '',
                    ),
                    dateController: TextEditingController(
                      text: ReadingLogic.formatDate(DateTime.now()),
                    ),
                  );
                },
              );

              if (result != null) {
                dataProvider.addReading(result.reading, result.date);
              }
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.dashboard,
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.bar_chart,
                  size: Theme.of(context).textTheme.headlineLarge!.fontSize,
                ),
                label: 'Diagramme',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.date_range,
                  size: Theme.of(context).textTheme.headlineLarge!.fontSize,
                ),
                label: 'Daten',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: _onItemTapped,
            iconSize: Theme.of(context).textTheme.bodyLarge!.fontSize!,
          ),
        );
      },
    );
  }
}
