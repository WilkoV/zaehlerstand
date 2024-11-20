import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:zaehlerstand/src/responsive/mobile_body.dart';
import 'package:zaehlerstand/src/responsive/responsive_layout.dart';
import 'package:zaehlerstand/src/responsive/tablet_body.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zählerstand', style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: const ResponsiveLayout(
        mobileBody: MobileBody(),
        tabletBody: TabletBody(),
      ),
    );
  }
}
