import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';

extension StringExt on String {
  Image squareImage(
    double size, {
    BoxFit fit = BoxFit.fill,
    Color? color,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return image(
      width: size,
      height: size,
      fit: fit,
      color: color,
      alignment: alignment,
    );
  }

  Image image({
    double? width,
    double? height,
    BoxFit fit = BoxFit.fill,
    Color? color,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return startsWith('http')
        ? Image.network(
            this,
            width: width,
            height: height,
            fit: fit,
            color: color,
            alignment: alignment,
          )
        : Image.asset(
            this,
            width: width,
            height: height,
            fit: fit,
            color: color,
            alignment: alignment,
          );
  }

  Color get color => Color(int.parse(this));

  String prefix(String prefix) => '$prefix$this';
}

extension NullableStringExt on String? {
  /// 判空
  bool get nullOrEmpty => this == null || this!.isEmpty;

  /// 不为空
  bool get notNullAndNotEmpty => this != null && this!.isNotEmpty;

  /// 防止文字自动换行
  String get fixAutoLines {
    if (this == null) return '';
    return Characters(this!).join('\u{200B}');
  }

  /// 颜色字符串转Color
  Color get ctc {
    if (nullOrEmpty) return Colors.transparent;
    // colorString未带0xff前缀并且长度为6
    String colorStr = '';
    if (this!.startsWith('0xff') && this!.length == 6) {
      colorStr = '0xff$this';
    }
    // colorString为8位，如0x000000
    if (this!.startsWith('0x') && this!.length == 8) {
      colorStr = this!.replaceRange(0, 2, '0xff');
    }
    // colorString为7位，如#000000
    if (this!.startsWith('#') && this!.length == 7) {
      colorStr = this!.replaceRange(0, 1, '0xff');
    }
    // colorString为9位，如#00000000
    if (this!.startsWith('#') && this!.length == 9) {
      colorStr = this!.replaceRange(0, 1, '0x');
    }
    if (colorStr.isNotEmpty) {
      return Color(int.parse(colorStr));
    }
    logger.logE('颜色转换失败:不支持的色值格式：$this', path: kDefaultPath);
    return Colors.transparent;
  }

  bool containsIgnoreCase(String other) {
    var str = this;
    if (str == null) return false;
    return str.toLowerCase().contains(other.toLowerCase());
  }

  String get removeTrailingZeros {
    final String? temp = this;
    if (temp == null || temp.isEmpty) return '';
    return num.tryParse(temp).removeTrailingZerosToString;
  }

  num get toNum {
    final String? temp = this;
    if (temp == null || temp.isEmpty) return 0;
    return num.tryParse(temp) ?? 0;
  }

  int get toInt {
    final String? temp = this;
    if (temp == null || temp.isEmpty) return 0;
    return num.tryParse(temp)?.toInt() ?? 0;
  }
}
