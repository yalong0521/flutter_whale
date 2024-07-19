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
      {String? name, LogLevel level = LogLevel.info}) async {
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
    var dateTime = DateTime.now();
    var dateTimeStr = dateTime.toString();
    var tag = '${name ?? appConfig.logTag} ${level.name} $dateTimeStr';
    if (kDebugMode) developer.log(log, name: tag);
    if (appConfig.log2File) {
      var logLevelDir = await _getLogLevelDir(level);
      var logFileName = formatDate(dateTime, [yyyy, mm, dd, HH]);
      var logFile = File(join(logLevelDir.path, '${logFileName}00.log'));
      logFile.writeAsString(
        '[$tag] $log${Platform.lineTerminator}',
        mode: FileMode.append,
      );
    }
  }

  static void logE(Object? object, {String? name}) {
    log(object, name: name, level: LogLevel.error);
  }

  static Future<List<File>> getLevelLogs(LogLevel level) async {
    var logLevelDir = await _getLogLevelDir(level);
    return logLevelDir.list().map((e) => File(e.path)).toList();
  }

  static Future<Directory> getLogRootDir() async {
    Directory? dir;
    if (Platform.isAndroid) {
      var externalStorageDir = await getExternalStorageDirectory();
      if (externalStorageDir != null) dir = externalStorageDir;
    }
    dir = dir ?? await getTemporaryDirectory();
    var logRootDir = Directory(join(dir.path, 'logs'));
    if (!logRootDir.existsSync()) logRootDir.createSync();
    return logRootDir;
  }

  static Future<Directory> _getLogLevelDir(LogLevel level) async {
    var logRootDir = await getLogRootDir();
    var logLevelDir = Directory(join(logRootDir.path, level.name));
    if (!logLevelDir.existsSync()) logLevelDir.createSync();
    return logLevelDir;
  }
}
