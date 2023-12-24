import 'package:flutter/services.dart';

final _doubleExp = RegExp(r'^(?!0\d|0$|\d*\.\d{3,}|^\.)(\d+|\d*\.\d{0,2})?$');
final _singleNumExp = RegExp(r'^([0-9])?$');
final _doubleNumExp = RegExp(r'^(?!0)\d{0,2}$');

var doubleTextInputFormatter = CustomInputFormatter.fromRegExp(_doubleExp);

var singleNumTextInputFormatter =
    CustomInputFormatter.fromRegExp(_singleNumExp);

var doubleNumTextInputFormatter =
    CustomInputFormatter.fromRegExp(_doubleNumExp);

class CustomInputFormatter extends TextInputFormatter {
  final RegExp regExp;

  CustomInputFormatter._(this.regExp);

  factory CustomInputFormatter.fromRegExp(RegExp regExp) {
    return CustomInputFormatter._(regExp);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newString = newValue.text;
    if (!regExp.hasMatch(newString)) return oldValue;
    return newValue;
  }
}
