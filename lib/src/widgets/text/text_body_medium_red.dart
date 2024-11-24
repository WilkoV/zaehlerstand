import 'package:flutter/material.dart';

class TextBodyMediumRed extends StatelessWidget {
  const TextBodyMediumRed(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(data, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red));
  }
}
