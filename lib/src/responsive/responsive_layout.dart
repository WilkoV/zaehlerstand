import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;

  const ResponsiveLayout({super.key, required this.mobileBody, required this.tabletBody});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // TODO: Find solution and values for emulator vs physical device execution
        if (constraints.maxWidth <= 800) {
          return mobileBody;
        }

        return tabletBody;
      },
    );
  }
}
