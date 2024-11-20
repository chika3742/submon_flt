import "package:flutter/material.dart";

class SubmonThemeExtension extends ThemeExtension<SubmonThemeExtension> {
  const SubmonThemeExtension({
    required this.safeDueTextColor,
    required this.nearDueTextColor,
    required this.overdueTextColor,
    required this.starColor,
  });

  final Color safeDueTextColor;
  final Color nearDueTextColor;
  final Color overdueTextColor;
  final Color starColor;

  @override
  ThemeExtension<SubmonThemeExtension> copyWith({
    Color? safeDueTextColor,
    Color? nearDueTextColor,
    Color? overdueTextColor,
    Color? starColor,
  }) {
    return SubmonThemeExtension(
      safeDueTextColor: safeDueTextColor ?? this.safeDueTextColor,
      nearDueTextColor: nearDueTextColor ?? this.nearDueTextColor,
      overdueTextColor: overdueTextColor ?? this.overdueTextColor,
      starColor: starColor ?? this.starColor,
    );
  }

  @override
  ThemeExtension<SubmonThemeExtension> lerp(covariant SubmonThemeExtension? other, double t) {
    return SubmonThemeExtension(
      safeDueTextColor: Color.lerp(safeDueTextColor, other?.safeDueTextColor, t)!,
      nearDueTextColor: Color.lerp(nearDueTextColor, other?.nearDueTextColor, t)!,
      overdueTextColor: Color.lerp(overdueTextColor, other?.overdueTextColor, t)!,
      starColor: Color.lerp(starColor, other?.starColor, t)!,
    );
  }
}
