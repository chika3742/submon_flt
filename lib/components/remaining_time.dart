import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

import "../ui_core/formatted_duration.dart";
import "../ui_core/theme_extension.dart";

class RemainingTime extends HookWidget {
  const RemainingTime(this.duration, {
    super.key,
    this.inkBorderRadius = BorderRadius.zero,
    this.nearDueThresholdDays = 2,
  });
  
  final Duration duration;

  ///
  /// The border radius of the ink effect when the user taps on the widget.
  ///
  final BorderRadius inkBorderRadius;

  ///
  /// Change the text color when the number of days remaining falls below
  /// this number (inclusive).
  ///
  final int nearDueThresholdDays;

  @override
  Widget build(BuildContext context) {
    final showInDays = useState(false);
    final formatted = FormattedDuration(duration, forceInDays: showInDays.value);
    
    return InkWell(
      borderRadius: inkBorderRadius,
      onTap: () {
        showInDays.value = !showInDays.value;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: formatted.value.toString(), style: TextStyle(fontSize: 24)),
              TextSpan(text: formatted.unit.localizedText, style: TextStyle(fontSize: 16)),
            ],
          ),
          style: TextStyle(
            color: getNumberTextColor(context),
            letterSpacing: 1.5,
            fontWeight: getTextFontWeight(),
          ),
          textAlign: TextAlign.end,
        ),
      ),
    );
  }

  Color getNumberTextColor(BuildContext context) {
    final theme = Theme.of(context).extension<SubmonThemeExtension>()!;

    if (duration.isNegative) {
      return theme.overdueTextColor;
    }
    if (duration.inDays <= nearDueThresholdDays) {
      return theme.nearDueTextColor;
    }
    return theme.safeDueTextColor;
  }

  FontWeight getTextFontWeight() {
    if (duration.isNegative || duration.inDays <= nearDueThresholdDays) {
      return FontWeight.bold;
    }
    return FontWeight.normal;
  }
}
