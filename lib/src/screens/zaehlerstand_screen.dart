import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
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

class _ZaehlerstandScreenState extends State<ZaehlerstandScreen> {
  late TextEditingController zaehlerstandController;
  final Logger _log = Logger('_ZaehlerstandScreenState');

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
  }

  @override
  void dispose() {
    // Dispose of the controller to avoid memory leaks.
    zaehlerstandController.dispose();
    super.dispose();
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
        int minReadingValue = dataProvider.currentReading != null ? dataProvider.currentReading!.reading : 0;
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
              final result = await showDialog<String>(
                context: context,
                builder: (context) => ReadingDialog(
                  minimalReadingValue: minReadingValue,
                  zaehlerstandController: TextEditingController(
                    // TODO Implement average instead of 0
                    text: dataProvider.currentReading != null ? dataProvider.currentReading!.getFirstTwoDigitsFromReading(0) : '',
                  ),
                ),
              );

              if (result != null) {
                dataProvider.addReading(int.parse(result));
                _log.fine(result);
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
