import 'package:flutter/widgets.dart';

class KeyboardUtil {
  KeyboardUtil._();

  /// 隐藏软键盘
  static hide(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
