import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_whale/flutter_whale.dart';
import 'package:path/path.dart';

class LogUtil {
  LogUtil._();

  static void log(Object? object, {String? name}) {
    var log = object?.toString() ?? '';
    var tag = name ?? appConfig.logTag;
    if (kDebugMode) developer.log(log, name: tag);
    if (appConfig.log2File) log2File(tag, log);
  }

  static void log2File(String tag, String log) async {
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
