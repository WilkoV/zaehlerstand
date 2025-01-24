import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/app/app_colors.dart' as app_colors;

class ReadingAvgConsumptionArrow extends StatelessWidget {
  final double? consumption;
  final double? compareConsumptionWith;

  const ReadingAvgConsumptionArrow({
    super.key,
    this.consumption,
    this.compareConsumptionWith,
  });

  @override
  Widget build(BuildContext context) {
    return consumption != null && compareConsumptionWith != null
        ? consumption! > compareConsumptionWith!
            ? Icon(Icons.arrow_upward, color: _getArrowColor(), size: Theme.of(context).textTheme.bodyLarge!.fontSize!)
            : consumption! < compareConsumptionWith!
                ? Icon(Icons.arrow_downward, color: _getArrowColor(), size: Theme.of(context).textTheme.bodyLarge!.fontSize!)
                : Row(
                    children: [
                      Icon(Icons.arrow_upward, color: _getArrowColor(), size: Theme.of(context).textTheme.bodyLarge!.fontSize!),
                      Icon(Icons.arrow_downward, color: _getArrowColor(), size: Theme.of(context).textTheme.bodyLarge!.fontSize!),
                    ],
                  )
        : Row(
            children: [
              Icon(Icons.arrow_upward, color: _getArrowColor(), size: Theme.of(context).textTheme.bodyLarge!.fontSize!),
              Icon(Icons.arrow_downward, color: _getArrowColor(), size: Theme.of(context).textTheme.bodyLarge!.fontSize!),
            ],
          );
  }

  Color _getArrowColor() {
    return compareConsumptionWith != null
        ? consumption! > compareConsumptionWith!
            ? app_colors.arrowUpColor
            : consumption! < compareConsumptionWith!
                ? app_colors.arrowDownColor
                : app_colors.arrowNeutralColor
        : app_colors.arrowNeutralColor;
  }
}
