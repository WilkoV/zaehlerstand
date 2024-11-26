import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/theme_provider.dart';

class ZaehlerstandDrawer extends StatelessWidget {
  const ZaehlerstandDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}
