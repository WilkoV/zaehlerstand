import 'package:flutter/material.dart';

class LabeledDivider extends StatelessWidget {
  final String message;
  final double spacing;
  final double thickness;

  const LabeledDivider({
    super.key,
    required this.message,
    required this.spacing,
    required this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
          flex: 4,
          child: Divider(thickness: thickness),
        ),
        SizedBox(width: spacing),
        Text(message, style: Theme.of(context).textTheme.bodySmall),
        SizedBox(width: spacing),
        Flexible(
          flex: 1, 
          child: Divider(thickness: thickness),
        ),
      ],
    );
  }
}
