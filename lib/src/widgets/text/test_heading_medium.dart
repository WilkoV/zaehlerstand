import 'package:flutter/material.dart';

class TextHeadingMedium extends StatelessWidget {
  const TextHeadingMedium(
    this.data, {
    super.key,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(data, style: Theme.of(context).textTheme.headlineMedium);
  }
}
