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
}
