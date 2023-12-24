import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_whale/flutter_whale.dart';

class LogUtil {
  LogUtil._();

  static void log(Object? object, {String? name}) {
    if (!kDebugMode) return;
    developer.log(object?.toString() ?? '', name: name ?? appConfig.logTag);
  }
}
