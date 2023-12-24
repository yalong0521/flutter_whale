import 'dart:io';

import 'package:flutter_whale/flutter_whale.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

MediaQueryData get mqData {
  MediaQueryData? data = MediaQuery.maybeOf(baseContext);
  return data ?? MediaQueryData.fromView(View.of(baseContext));
}

double get screenWidth => mqData.size.width;

double get screenHeight => mqData.size.height;

double get paddingRight => mqData.padding.right;

double get paddingLeft => mqData.padding.left;

double get paddingTop => mqData.padding.top;

double get paddingBottom => mqData.padding.bottom;

bool get isDesktop =>
    !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
