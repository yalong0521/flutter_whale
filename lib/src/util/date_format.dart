/// Outputs year as four digits
///
/// Example:
///     formatDate(DateTime(1989), [yyyy]);
///     // => 1989
const String yyyy = 'yyyy';

/// Outputs year as two digits
///
/// Example:
///     formatDate(DateTime(1989), [yy]);
///     // => 89
const String yy = 'yy';

/// Outputs month as two digits
///
/// Example:
///     formatDate(DateTime(1989, 11), [mm]);
///     // => 11
///     formatDate(DateTime(1989, 5), [mm]);
///     // => 05
const String mm = 'mm';

/// Outputs month compactly
///
/// Example:
///     formatDate(DateTime(1989, 11), [mm]);
///     // => 11
///     formatDate(DateTime(1989, 5), [m]);
///     // => 5
const String m = 'm';

/// Outputs month as long name
///
/// Example:
///     formatDate(DateTime(1989, 2), [kMM]);
///     // => february
const String kMM = 'MM';

/// Outputs month as short name
///
/// Example:
///     formatDate(DateTime(1989, 2), [kM]);
///     // => feb
const String kM = 'M';

/// Outputs day as two digits
///
/// Example:
///     formatDate(DateTime(1989, 2, 21), [dd]);
///     // => 21
///     formatDate(DateTime(1989, 2, 5), [dd]);
///     // => 05
const String dd = 'dd';

/// Outputs day compactly
///
/// Example:
///     formatDate(DateTime(1989, 2, 21), [d]);
///     // => 21
///     formatDate(DateTime(1989, 2, 5), [d]);
///     // => 5
const String d = 'd';

/// Outputs week in month
///
/// Example:
///     formatDate(DateTime(1989, 2, 21), [w]);
///     // => 4
const String w = 'w';

/// Outputs week in year as two digits
///
/// Example:
///     formatDate(DateTime(1989, 12, 31), [W]);
///     // => 53
///     formatDate(DateTime(1989, 2, 21), [W]);
///     // => 08
const String kWW = 'WW';

/// Outputs week in year compactly
///
/// Example:
///     formatDate(DateTime(1989, 2, 21), [W]);
///     // => 8
const String W = 'W';

/// Outputs week day as long name
///
/// Example:
///     formatDate(DateTime(2018, 1, 14), [kDD]);
///     // => sunday
const String kDD = 'DD';

/// Outputs week day as long name
///
/// Example:
///     formatDate(DateTime(2018, 1, 14), [D]);
///     // => sun
const String D = 'D';

/// Outputs hour (0 - 11) as two digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15), [hh]);
///     // => 03
const String hh = 'hh';

/// Outputs hour (0 - 11) compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15), [h]);
///     // => 3
const String h = 'h';

/// Outputs hour (0 to 23) as two digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15), [kHH]);
///     // => 15
const String kHH = 'HH';

/// Outputs hour (0 to 23) compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 5), [H]);
///     // => 5
const String H = 'H';

/// Outputs minute as two digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40), [nn]);
///     // => 40
///     formatDate(DateTime(1989, 02, 1, 15, 4), [nn]);
///     // => 04
const String nn = 'nn';

/// Outputs minute compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 4), [n]);
///     // => 4
const String n = 'n';

/// Outputs second as two digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10), [ss]);
///     // => 10
///     formatDate(DateTime(1989, 02, 1, 15, 40, 5), [ss]);
///     // => 05
const String ss = 'ss';

/// Outputs second compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 5), [s]);
///     // => 5
const String s = 's';

/// Outputs millisecond as three digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 999), [kSSS]);
///     // => 999
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 99), [SS]);
///     // => 099
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0), [SS]);
///     // => 009
const String kSSS = 'SSS';

/// Outputs millisecond compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 999), [kSSS]);
///     // => 999
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 99), [SS]);
///     // => 99
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 9), [SS]);
///     // => 9
const String kS = 'S';

/// Outputs microsecond as three digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 999), [uuu]);
///     // => 999
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 99), [uuu]);
///     // => 099
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 9), [uuu]);
///     // => 009
const String uuu = 'uuu';

/// Outputs millisecond compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 999), [u]);
///     // => 999
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 99), [u]);
///     // => 99
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 9), [u]);
///     // => 9
const String u = 'u';

/// Outputs if hour is AM or PM
///
/// Example:
///     print(formatDate(DateTime(1989, 02, 1, 5), [am]));
///     // => AM
///     print(formatDate(DateTime(1989, 02, 1, 15), [am]));
///     // => PM
const String am = 'am';

/// Outputs timezone as time offset
///
/// Example:
///
const String z = 'z';
const String Z = 'Z';

/// Escape delimiters to be used as normal string.
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40), [HH,'\\h',nn]);
///     // => 15h40
///

const String escape = '\\';

String formatDate(DateTime date, List<String> formats,
    {DateLocale locale = const EnglishDateLocale()}) {
  final sb = StringBuffer();

  for (String format in formats) {
    if (format.startsWith(escape)) {
      format = format.substring(1);
      sb.write(format);
    } else if (format == yyyy) {
      sb.write(_digits(date.year, 4));
    } else if (format == yy) {
      sb.write(_digits(date.year % 100, 2));
    } else if (format == mm) {
      sb.write(_digits(date.month, 2));
    } else if (format == m) {
      sb.write(date.month);
    } else if (format == kMM) {
      sb.write(locale.monthsLong[date.month - 1]);
    } else if (format == kM) {
      sb.write(locale.monthsShort[date.month - 1]);
    } else if (format == dd) {
      sb.write(_digits(date.day, 2));
    } else if (format == d) {
      sb.write(date.day);
    } else if (format == w) {
      sb.write((date.day + 7) ~/ 7);
    } else if (format == W) {
      sb.write((dayInYear(date) + 7) ~/ 7);
    } else if (format == kWW) {
      sb.write(_digits((dayInYear(date) + 7) ~/ 7, 2));
    } else if (format == kDD) {
      sb.write(locale.daysLong[date.weekday - 1]);
    } else if (format == D) {
      sb.write(locale.daysShort[date.weekday - 1]);
    } else if (format == kHH) {
      sb.write(_digits(date.hour, 2));
    } else if (format == H) {
      sb.write(date.hour);
    } else if (format == hh) {
      int hour = date.hour % 12;
      if (hour == 0) hour = 12;
      sb.write(_digits(hour, 2));
    } else if (format == h) {
      int hour = date.hour % 12;
      if (hour == 0) hour = 12;
      sb.write(hour);
    } else if (format == am) {
      sb.write(date.hour < 12 ? locale.am : locale.pm);
    } else if (format == nn) {
      sb.write(_digits(date.minute, 2));
    } else if (format == n) {
      sb.write(date.minute);
    } else if (format == ss) {
      sb.write(_digits(date.second, 2));
    } else if (format == s) {
      sb.write(date.second);
    } else if (format == kSSS) {
      sb.write(_digits(date.millisecond, 3));
    } else if (format == kS) {
      sb.write(date.millisecond);
    } else if (format == uuu) {
      sb.write(_digits(date.microsecond, 3));
    } else if (format == u) {
      sb.write(date.microsecond);
    } else if (format == z) {
      if (date.timeZoneOffset.inMinutes == 0) {
        sb.write('Z');
      } else {
        if (date.timeZoneOffset.isNegative) {
          sb.write('-');
          sb.write(_digits((-date.timeZoneOffset.inHours) % 24, 2));
          sb.write(_digits((-date.timeZoneOffset.inMinutes) % 60, 2));
        } else {
          sb.write('+');
          sb.write(_digits(date.timeZoneOffset.inHours % 24, 2));
          sb.write(_digits(date.timeZoneOffset.inMinutes % 60, 2));
        }
      }
    } else if (format == Z) {
      sb.write(date.timeZoneName);
    } else {
      sb.write(format);
    }
  }

  return sb.toString();
}

String _digits(int value, int length) {
  String ret = '$value';
  if (ret.length < length) {
    ret = '0' * (length - ret.length) + ret;
  }
  return ret;
}

int dayInYear(DateTime date) =>
    date.difference(DateTime(date.year, 1, 1)).inDays;

abstract class DateLocale {
  List<String> get monthsShort;

  List<String> get monthsLong;

  List<String> get daysShort;

  List<String> get daysLong;

  String get am;

  String get pm;
}

class EnglishDateLocale implements DateLocale {
  const EnglishDateLocale();

  @override
  final List<String> monthsShort = const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  final List<String> monthsLong = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  final List<String> daysShort = const [
    'Mon',
    'Tue',
    'Wed',
    'Thur',
    'Fri',
    'Sat',
    'Sun'
  ];

  @override
  final List<String> daysLong = const [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  String get am => "AM";

  @override
  String get pm => "PM";
}

class SimplifiedChineseDateLocale implements DateLocale {
  const SimplifiedChineseDateLocale();

  @override
  final List<String> monthsShort = const [
    '1月',
    '2月',
    '3月',
    '4月',
    '5月',
    '6月',
    '7月',
    '8月',
    '9月',
    '10月',
    '11月',
    '12月'
  ];

  @override
  final List<String> monthsLong = const [
    '一月',
    '二月',
    '三月',
    '四月',
    '五月',
    '六月',
    '七月',
    '八月',
    '九月',
    '十月',
    '十一月',
    '十二月'
  ];

  @override
  final List<String> daysShort = const [
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日'
  ];

  @override
  final List<String> daysLong = const [
    '星期一',
    '星期二',
    '星期三',
    '星期四',
    '星期五',
    '星期六',
    '星期日'
  ];

  @override
  String get am => "上午";

  @override
  String get pm => "下午";
}
