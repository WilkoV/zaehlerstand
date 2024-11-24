import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/theme_provider.dart';
import 'package:zaehlerstand/src/responsive/mobile_body.dart';
import 'package:zaehlerstand/src/responsive/responsive_layout.dart';
import 'package:zaehlerstand/src/responsive/tablet_body.dart';
import 'package:zaehlerstand/src/widgets/text/test_heading_large.dart';
import 'package:zaehlerstand/src/widgets/text/test_heading_medium.dart';
import 'package:zaehlerstand/src/widgets/text/text_body_medium.dart';

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
            title: const TextHeadingLarge('Zählerstand'),
            centerTitle: true,
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                const DrawerHeader(
                  child: TextHeadingMedium('Settings'),
                ),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return SwitchListTile(
                      title: const TextBodyMedium('Dark Mode'),
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
          body: const ResponsiveLayout(
            mobileBody: MobileBody(),
            tabletBody: TabletBody(),
          ),
        ),
      ),
    );
  }
}
