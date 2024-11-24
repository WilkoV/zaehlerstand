import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/theme_provider.dart';
import 'package:zaehlerstand/src/widgets/responsive/zaehlerstand/zaehlerstand_responsive_layout.dart';

class ZaehlerstandScreen extends StatefulWidget {
  const ZaehlerstandScreen({super.key});

  @override
  State<ZaehlerstandScreen> createState() => _ZaehlerstandScreenState();
}

class _ZaehlerstandScreenState extends State<ZaehlerstandScreen> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Zählerstand', style: Theme.of(context).textTheme.headlineLarge),
            centerTitle: true,
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  child: Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
                ),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return SwitchListTile(
                      title: Text('Dark Mode', style: Theme.of(context).textTheme.bodyMedium),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          body: const ZaehlerstandResponsiveLayout(),
        ),
      ),
    );
  }
}
