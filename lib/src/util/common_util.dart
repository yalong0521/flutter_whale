import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';

bool get isDesktop =>
    !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

double getPaddingTop([BuildContext? context]) => _insets(context).top;

double getPaddingBottom([BuildContext? context]) => _insets(context).bottom;

double getPaddingLeft([BuildContext? context]) => _insets(context).left;

double getPaddingRight([BuildContext? context]) => _insets(context).right;

double getScreenWidth([BuildContext? context]) => _size(context).width;

double getScreenHeight([BuildContext? context]) => _size(context).height;

double get paddingTop => _insets().top;

double get paddingBottom => _insets().bottom;

double get paddingLeft => _insets().left;

double get paddingRight => _insets().right;

double get screenWidth => _size().width;

double get screenHeight => _size().height;

EdgeInsets _insets([BuildContext? context]) {
  return MediaQuery.paddingOf(context ?? baseContext);
}

Size _size([BuildContext? context]) {
  return MediaQuery.sizeOf(context ?? baseContext);
}
