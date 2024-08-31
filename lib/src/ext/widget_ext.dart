import 'package:flutter/widgets.dart';

extension WidgetExt on Widget {
  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(padding: padding, child: this);
  }

  Widget paddingTop(double padding) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: padding),
      child: this,
    );
  }

  Widget paddingBottom(double padding) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: padding),
      child: this,
    );
  }

  Widget paddingStart(double padding) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: padding),
      child: this,
    );
  }

  Widget paddingEnd(double padding) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: padding),
      child: this,
    );
  }

  Widget paddingHorizontal(double padding) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: padding),
      child: this,
    );
  }

  Widget paddingVertical(double padding) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(vertical: padding),
      child: this,
    );
  }

  Widget paddingOnly(
      {double start = 0, double top = 0, double end = 0, double bottom = 0}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: start,
        top: top,
        end: end,
        bottom: bottom,
      ),
      child: this,
    );
  }

  Widget paddingAll(double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }
}
