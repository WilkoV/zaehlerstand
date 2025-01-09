import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_yearly_view.dart';

class ZaehlerstandScreen extends StatelessWidget {
  const ZaehlerstandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DaddysYearlyView(),
    );
  }
}
