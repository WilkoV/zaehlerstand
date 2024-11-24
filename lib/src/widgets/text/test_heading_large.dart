import 'package:flutter/material.dart';

class TextHeadingLarge extends StatelessWidget {
  const TextHeadingLarge(
    this.data, {
    super.key,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(data, style: Theme.of(context).textTheme.headlineLarge);
  }
}
