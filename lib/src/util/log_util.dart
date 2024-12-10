import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_whale/flutter_whale.dart';

enum LogLevel {
  info,
  error;
}

const kDefaultPath = 'default';
const kHttpClientLogPath = 'http';
const kLogFileSuffix = '.log';

LogUtil logger = LogUtil.shared;

class LogUtil {
  LogUtil._() {
    getLogRootDir().then((value) {
      for (var file in value.listSync()) {
        _delete(file);
      }
    });
  }

  static final LogUtil shared = LogUtil._();

  final _lock = Lock();

  /// log文件头
  String? _logFileHeader;

  void _delete(FileSystemEntity file) {
    if (FileSystemEntity.isFileSync(file.path)) {
      final baseName = basename(file.path);
      if (!baseName.endsWith(kLogFileSuffix)) return;
      final split = baseName.split((kLogFileSuffix));
      if (split.length != 2) return;
      final datetime = _tryParseDatetime(split.first);
      if (datetime == null) return;
      if (DateTime.now().difference(datetime).inDays >= 7) {
        log('日志文件过期清除===>$baseName');
        file.deleteSync();
      }
    } else if (FileSystemEntity.isDirectorySync(file.path)) {
      for (var value in Directory(file.path).listSync()) {
        _delete(value);
      }
    }
  }

  DateTime? _tryParseDatetime(String datetimeStr) {
    if (datetimeStr.length != 12) return null;
    int year = int.parse(datetimeStr.substring(0, 4));
    int month = int.parse(datetimeStr.substring(4, 6));
    int day = int.parse(datetimeStr.substring(6, 8));
    int hour = int.parse(datetimeStr.substring(8, 10));
    int minute = int.parse(datetimeStr.substring(10, 12));
    return DateTime(year, month, day, hour, minute);
  }

  void setLogFileHeader(String? logFileHeader) {
    _logFileHeader = logFileHeader;
  }

  void log(Object? object,
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

  Future _log2File(
      String path, LogLevel level, DateTime dateTime, String log) async {
    var logLevelPath = (await _getLogPathLevelDir(path, level)).path;
    var logFileName = formatDate(dateTime, [yyyy, mm, dd, kHH]);
    var logFile = File(join(logLevelPath, '${logFileName}00$kLogFileSuffix'));
    if (!logFile.existsSync()) {
      logFile.createSync();
      var logFileHeader = _logFileHeader;
      if (logFileHeader != null) {
        // 第一次创建的时候写入文件头
        await logFile.writeAsString(logFileHeader, mode: FileMode.write);
      }
    }
    await logFile.writeAsString(
      '[$dateTime] $log${Platform.lineTerminator * 2}',
      mode: FileMode.append,
    );
  }

  void logE(Object? object, {String path = kDefaultPath}) {
    log(object, path: path, level: LogLevel.error);
  }

  Future<Directory> getLogRootDir() => getAppDir('logs');

  Future<Directory> _getLogPathLevelDir(String path, LogLevel level) async {
    var logRootDir = await getLogRootDir();
    Directory logDir = Directory(join(logRootDir.path, path, level.name));
    if (!logDir.existsSync()) logDir.createSync(recursive: true);
    return logDir;
  }
}
