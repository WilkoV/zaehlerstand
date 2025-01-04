import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/app/app_colors.dart' as app_colors;

class ReadingConsumptionArrow extends StatelessWidget {
  const ReadingConsumptionArrow({
    super.key,
    this.consumption,
    this.compareConsumptionWith,
  });

  final int? consumption;
  final int? compareConsumptionWith;

  @override
  Widget build(BuildContext context) {
    return consumption != null && compareConsumptionWith != null
        ? consumption! > compareConsumptionWith!
            ? Icon(Icons.arrow_upward, color: _getArrowColor(), size: Theme.of(context).textTheme.bodyLarge!.fontSize!)
            : consumption! < compareConsumptionWith!
                ? Icon(Icons.arrow_downward, color: _getArrowColor(), size: Theme.of(context).textTheme.bodyLarge!.fontSize!)
                : const SizedBox()
        : const SizedBox();
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
