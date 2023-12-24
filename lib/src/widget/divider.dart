import 'package:flutter/material.dart';

class HDivider extends Divider {
  const HDivider(double value, Color color, {double? padding, super.key})
      : super(
          height: value,
          thickness: value,
          color: color,
          endIndent: padding ?? 0,
          indent: padding ?? 0,
        );
}

class VDivider extends VerticalDivider {
  const VDivider(double value, Color color, {double? padding, super.key})
      : super(
          width: value,
          thickness: value,
          color: color,
          endIndent: padding ?? 0,
          indent: padding ?? 0,
        );
}
