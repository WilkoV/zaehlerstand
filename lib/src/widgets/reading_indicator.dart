import 'package:flutter/material.dart';

class ReadingIndicator extends StatelessWidget {
  final int? value; // The large 6-digit value
  final bool? isUp; // Whether the indicator is up (true), down (false), or null
  final double? percentage; // The percentage value

  const ReadingIndicator({
    super.key,
    this.value,
    this.isUp,
    this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final arrow = isUp == null
        ? null
        : Icon(
            isUp! ? Icons.arrow_upward : Icons.arrow_downward,
            size: 18,
            color: isUp! ? Colors.green : Colors.red,
          );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display the large value or '--'
        Text(
          value?.toString().padLeft(6, '0') ?? '--',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        // Display the arrow and percentage, or '--' if null
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (arrow != null) arrow,
            if (arrow != null) const SizedBox(width: 4),
            Text(
              percentage != null ? '${percentage!.toStringAsFixed(1)}%' : '--',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
