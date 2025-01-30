import 'package:flutter/material.dart';

abstract class ChartsBase extends StatelessWidget {
  final bool doRotate;
  final double rodWidth;

  const ChartsBase({super.key, required this.doRotate, required this.rodWidth});
}
