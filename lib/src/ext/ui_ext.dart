import 'package:flutter/material.dart';

class UIExt {
  UIExt._();

  /// 测量给定文字[text]的size
  static Size getTextSize(
    BuildContext context,
    String text,
    TextStyle style, {
    int maxLines = 2 ^ 31,
    double maxWidth = double.infinity,
  }) {
    if (text.isEmpty) return Size.zero;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      locale: Localizations.localeOf(context),
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
}
