import 'dart:math';

import 'package:flutter/widgets.dart';

extension TextEditingControllerExt on TextEditingController {
  void delete() {
    if (text.isEmpty) return;
    var baseOffset = selection.baseOffset;
    baseOffset = baseOffset == -1 ? text.length : baseOffset;
    var extentOffset = selection.extentOffset;
    extentOffset = extentOffset == -1 ? text.length : extentOffset;
    if (baseOffset != extentOffset) {
      var start = min(baseOffset, extentOffset);
      var end = max(baseOffset, extentOffset);
      value = value.copyWith(
        text: (text.characters.toList()..removeRange(start, end)).join(),
        selection: TextSelection.collapsed(offset: start),
      );
    } else {
      if (baseOffset == 0) return;
      value = value.copyWith(
        text: (text.characters.toList()..removeAt(baseOffset - 1)).join(),
        selection: TextSelection.collapsed(offset: baseOffset - 1),
      );
    }
  }

  void insert(String str, BuildContext? context) {
    var baseOffset = selection.baseOffset;
    baseOffset = baseOffset == -1 ? text.length : baseOffset;
    var extentOffset = selection.extentOffset;
    extentOffset = extentOffset == -1 ? text.length : extentOffset;
    TextEditingValue newValue;
    if (baseOffset != extentOffset) {
      var start = min(baseOffset, extentOffset);
      var end = max(baseOffset, extentOffset);
      newValue = value.copyWith(
        text: (text.characters.toList()
              ..removeRange(start, end)
              ..insert(start, str))
            .join(),
        selection: TextSelection.collapsed(offset: start + str.length),
      );
    } else {
      newValue = value.copyWith(
        text: (text.characters.toList()..insert(baseOffset, str)).join(),
        selection: TextSelection.collapsed(offset: baseOffset + str.length),
      );
    }
    context?.visitChildElements((element) => _visitor(element, newValue));
  }

  void clearSelection(BuildContext? context) {
    if (text.isEmpty) return;
    var baseOffset = selection.baseOffset;
    baseOffset = baseOffset == -1 ? text.length : baseOffset;
    var extentOffset = selection.extentOffset;
    extentOffset = extentOffset == -1 ? text.length : extentOffset;
    TextEditingValue newValue;
    if (baseOffset != extentOffset) {
      var start = min(baseOffset, extentOffset);
      var end = max(baseOffset, extentOffset);
      newValue = value.copyWith(
        text: (text.characters.toList()..removeRange(start, end)).join(),
        selection: TextSelection.collapsed(offset: start),
      );
    } else {
      if (baseOffset == 0) return;
      newValue = value.copyWith(
        text: (text.characters.toList()..removeRange(0, baseOffset)).join(),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    context?.visitChildElements((element) => _visitor(element, newValue));
  }

  void _visitor(Element element, TextEditingValue value) {
    var widget = element.widget;
    if (widget is! EditableText) {
      element.visitChildren((element) => _visitor(element, value));
      return;
    }
    final state = (widget.key as GlobalKey<EditableTextState>).currentState;
    state?.userUpdateTextEditingValue(value, SelectionChangedCause.keyboard);
  }
}
