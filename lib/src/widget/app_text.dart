import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';

class AppText extends StatelessWidget {
  final String data;
  final double? size;
  final dynamic color;
  final FontWeight? weight;
  final TextOverflow? overflow;
  final double? height;
  final int? maxLines;
  final TextDecoration? decoration;
  final TextAlign? textAlign;

  const AppText(
    this.data, {
    this.size,
    this.color = Colors.black,
    this.weight,
    this.overflow,
    this.height,
    this.maxLines,
    this.decoration,
    this.textAlign,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color? typeColor;
    if (color is String) {
      typeColor = (color as String).ctc;
    } else if (color is Color) {
      typeColor = color;
    }
    return Text(
      data,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: size ?? appConfig.appTextDefaultSize ?? 18,
        color: typeColor,
        fontWeight: weight,
        height: height,
        overflow: overflow,
        decoration: decoration,
      ),
    );
  }
}
