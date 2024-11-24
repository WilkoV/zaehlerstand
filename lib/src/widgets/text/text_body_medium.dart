import 'package:flutter/material.dart';

class TextBodyMedium extends StatelessWidget {
  const TextBodyMedium(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(data, style: Theme.of(context).textTheme.bodyMedium);
  }
}
