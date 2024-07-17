import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_whale/flutter_whale.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LogUtil {
  LogUtil._();

  static void log(Object? object, {String? name}) {
    var log = object?.toString() ?? '';
    var tag = name ?? appConfig.logTag;
    if (kDebugMode) {
      developer.log(log, name: tag);
    }
    if (appConfig.log2File) log2File(tag, log);
  }

  static void log2File(String tag, String log) async {
    var logDir = await getLogDir();
    var dateTime = DateTime.now();
    var logFileName = formatDate(dateTime, [yyyy, mm, dd, HH]);
    var logFile = File(p.join(logDir.path, '$logFileName.log'));
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
    var dir = await getApplicationDocumentsDirectory();
    var logDir = Directory(p.join(dir.path, 'logs'));
    if (!logDir.existsSync()) logDir.createSync();
    return logDir;
  }
}
