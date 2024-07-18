import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_whale/flutter_whale.dart';
import 'package:path/path.dart';

enum LogLevel {
  info,
  error;
}

class LogUtil {
  LogUtil._();

  static void log(Object? object,
      {String? name, LogLevel level = LogLevel.info}) {
    if (object == null) return;
    String log;
    if (object is List) {
      StringBuffer sb = StringBuffer();
      for (var value in object) {
        sb.write(value.toString());
        if (object.indexOf(value) != object.length - 1) {
          sb.write(Platform.lineTerminator);
        }
      }
      log = sb.toString();
    } else {
      log = object.toString();
    }
    var tag = '${name ?? appConfig.logTag} ${level.name}';
    if (kDebugMode) developer.log(log, name: tag);
    if (appConfig.log2File) _log2File(tag, log);
  }

  static void logE(Object? object, {String? name}) {
    log(object, name: name, level: LogLevel.error);
  }

  static void _log2File(String tag, String log) async {
    var logDir = await getLogDir();
    var dateTime = DateTime.now();
    var logFileName = formatDate(dateTime, [yyyy, mm, dd, HH]);
    var logFile = File(join(logDir.path, '${logFileName}00.log'));
    logFile.writeAsString(
      '[$tag ${dateTime.toString()}] $log${Platform.lineTerminator}',
      mode: FileMode.append,
    );
  }

  static Future<List<File>> getAllLogs() async {
    var logDir = await getLogDir();
    return logDir.list().map((e) => File(e.path)).toList();
  }

  static Future<Directory> getLogDir() async {
    Directory? dir;
    if (Platform.isAndroid) {
      var externalStorageDir = await getExternalStorageDirectory();
      if (externalStorageDir != null) dir = externalStorageDir;
    }
    dir = dir ?? await getTemporaryDirectory();
    var logDir = Directory(join(dir.path, 'logs'));
    if (!logDir.existsSync()) logDir.createSync();
    return logDir;
  }
}
