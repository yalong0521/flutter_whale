import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_whale/flutter_whale.dart';
import 'package:path/path.dart';

enum LogLevel {
  info,
  error;
}

const kDefaultPath = 'default';
const kHttpClientLogPath = 'http';

class LogUtil {
  LogUtil._();

  static final _lock = Lock();

  /// log文件头
  static String? _logFileHeader;

  static void setLogFileHeader(String? logFileHeader) {
    _logFileHeader = logFileHeader;
  }

  static void log(Object? object,
      {String path = kDefaultPath, LogLevel level = LogLevel.info}) async {
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
    var tag = '$path ${level.name} $dateTime';
    if (kDebugMode) developer.log(log, name: tag);
    if (appConfig.log2File) {
      _lock.synchronized(() => _log2File(path, level, dateTime, log));
    }
  }

  static Future _log2File(
      String path, LogLevel level, DateTime dateTime, String log) async {
    var logLevelDir = await _getLogPathLevelDir(path, level);
    var logFileName = formatDate(dateTime, [yyyy, mm, dd, HH]);
    var logFile = File(join(logLevelDir.path, '${logFileName}00.log'));
    if (!logFile.existsSync()) {
      logFile.createSync();
      var logFileHeader = _logFileHeader;
      if (logFileHeader != null) {
        // 第一次创建的时候写入文件头
        await logFile.writeAsString(logFileHeader, mode: FileMode.write);
      }
    }
    await logFile.writeAsString(
      '[ $dateTime ] $log${Platform.lineTerminator * 2}',
      mode: FileMode.append,
    );
  }

  static void logE(Object? object, {String path = kDefaultPath}) {
    log(object, path: path, level: LogLevel.error);
  }

  static Future<Directory> getLogRootDir() async {
    Directory? dir;
    if (Platform.isAndroid) {
      var externalStorageDir = await getExternalStorageDirectory();
      if (externalStorageDir != null) dir = externalStorageDir;
    } else if (Platform.isWindows) {
      dir = await getApplicationSupportDirectory();
    }
    dir = dir ?? await getApplicationDocumentsDirectory();
    var logRootDir = Directory(join(dir.path, 'logs'));
    if (!logRootDir.existsSync()) logRootDir.createSync();
    return logRootDir;
  }

  static Future<Directory> _getLogPathLevelDir(
      String path, LogLevel level) async {
    var logRootDir = await getLogRootDir();
    Directory logDir = Directory(join(logRootDir.path, path, level.name));
    if (!logDir.existsSync()) logDir.createSync(recursive: true);
    return logDir;
  }
}
