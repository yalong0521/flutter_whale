import 'package:flutter/material.dart';

class DateUtil {
  DateUtil._();

  static final weekDay = ['', '周一', '周二', '周三', '周四', '周五', '周六', '周日'];

  /// 获取当前为一周中的那一天
  static String getWeek(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    var today = DateTime.now();
    var parse = DateTime.parse(date);
    if (today.year == parse.year && today.month == parse.month) {
      if (today.day == parse.day) {
        return '今天';
      } else if (parse.day - today.day == 1) {
        return '明天';
      }
    }
    return weekDay[parse.weekday];
  }

  static String getMMdd(String? date) {
    if (date == null || date.isEmpty) return '';
    var parse = DateTime.parse(date);
    return '${parse.month}/${parse.day}';
  }

  static bool isAm() {
    return DateTime.now().hour >= 12;
  }

  /// 一个月有多少天
  static int daysOfMonth(int year, int month) {
    return DateTimeRange(
      start: DateTime(year, month),
      end: DateTime(year, month + 1),
    ).duration.inDays;
  }

  /// 一年有多少天
  static int daysOfYear(int year) {
    return DateTimeRange(
      start: DateTime(year),
      end: DateTime(year + 1),
    ).duration.inDays;
  }

  static String digits(int value, {int length = 2}) {
    return '$value'.padLeft(length, "0");
  }

  static bool isAtSameDay(DateTime? day1, DateTime? day2) {
    return day1 != null &&
        day2 != null &&
        day1.difference(day2).inDays == 0 &&
        day1.day == day2.day;
  }

  static bool isAtSameHour(DateTime? day1, DateTime? day2) {
    return day1 != null &&
        day2 != null &&
        day1.difference(day2).inHours == 0 &&
        day1.hour == day2.hour;
  }

  static bool isAtSameMinute(DateTime? day1, DateTime? day2) {
    return day1 != null &&
        day2 != null &&
        day1.difference(day2).inMinutes == 0 &&
        day1.minute == day2.minute;
  }
}
