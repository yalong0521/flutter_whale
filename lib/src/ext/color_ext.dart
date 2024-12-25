import 'dart:ui';

extension ColorExt on Color {
  String get toHexString {
    final hexCode = value.toRadixString(16).padLeft(8, '0');
    return '#${hexCode.substring(2)}'; // #RRGGBB
  }

  String get toAlphaHexString {
    final hexCode = value.toRadixString(16).padLeft(8, '0');
    return '#${hexCode.substring(0, 2)}${hexCode.substring(2)}'; // #AARRGGBB
  }

  Brightness get brightness {
    final double relativeLuminance = computeLuminance();
    const double kThreshold = 0.15;
    if ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) > kThreshold) {
      return Brightness.light;
    }
    return Brightness.dark;
  }

  bool get isDark => brightness == Brightness.dark;

  bool get isLight => brightness == Brightness.light;
}
