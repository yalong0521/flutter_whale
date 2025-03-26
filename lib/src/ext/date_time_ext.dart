import 'package:flutter/material.dart';
import 'package:flutter_whale/src/util/date_format.dart' as f;

extension DateTimeExt on DateTime {
  bool belong(DateTimeRange range) {
    return !isBefore(range.start) && !isAfter(range.end);
  }

  String formatDate([String? split]) {
    return f.formatDate(this, [f.yyyy, split ?? '', f.mm, split ?? '', f.dd]);
  }

  /// ---> 2023-11-29
  String get formatDateLine => formatDate('-');

  /// ---> 2023.11.29
  String get formatDatePoint => formatDate('.');

  /// ---> 2023/11/29
  String get formatDateSplit => formatDate('/');

  /// ---> 10:58
  String get formatTime {
    return f.formatDate(this, [f.kHH, ':', f.nn]);
  }

  /// ---> 10:58:28
  String get formatTimeFull {
    return f.formatDate(this, [f.kHH, ':', f.nn, ':', f.ss]);
  }

  String formatDateTime(String split) {
    return f.formatDate(
        this, [f.yyyy, split, f.mm, split, f.dd, ' ', f.kHH, ':', f.nn]);
  }

  /// ---> 2023-11-29 10:58
  String get formatDateTimeLine => formatDateTime('-');

  /// ---> 2023.11.29 10:58
  String get formatDateTimePoint => formatDateTime('.');

  String formatDateTimeFull(String split) {
    return f.formatDate(this,
        [f.yyyy, split, f.mm, split, f.dd, ' ', f.kHH, ':', f.nn, ':', f.ss]);
  }

  /// ---> 2023-11-29 10:58:28
  String get formatDateTimeFullLine => formatDateTimeFull('-');

  /// ---> 2023.11.29 10:58:28
  String get formatDateTimeFullPoint => formatDateTimeFull('.');

  /// ---> 2023/11/29 10:58:28
  String get formatDateTimeFullSplit => formatDateTimeFull('/');
}
