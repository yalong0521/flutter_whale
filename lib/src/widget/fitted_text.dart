import 'package:flutter_whale/flutter_whale.dart';
import 'package:flutter/material.dart';

class FittedText extends StatelessWidget {
  final String data;
  final double? width;
  final double? height;
  final dynamic color;
  final FontWeight? weight;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final TextAlign? textAlign;

  const FittedText(
    this.data, {
    this.color = Colors.black,
    this.weight,
    this.overflow,
    this.width,
    this.height,
    this.maxLines,
    this.decoration,
    this.textAlign,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        child: AppText(
          data,
          color: color,
          weight: weight,
          overflow: overflow,
          maxLines: maxLines,
          decoration: decoration,
          textAlign: textAlign,
          key: key,
        ),
      ),
    );
  }
}
