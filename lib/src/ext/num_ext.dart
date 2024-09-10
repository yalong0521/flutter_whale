import 'package:flutter_whale/flutter_whale.dart';

extension NullableNumExt on num? {
  String get removeTrailingZerosToString {
    final num? temp = this;
    if (temp == null) return '';
    final tempStr = temp.toString();
    if (!RegExp(r'^[^.]+\.[^.]+$').hasMatch(tempStr)) return tempStr;
    var split = tempStr.split('.');
    var first = split[0];
    var last = split[1];
    if (int.parse(last) == 0) return first;
    var reversed = int.parse(last.split('').reversed.join());
    var remove = reversed.toString().split('').reversed.join();
    return '$first.$remove';
  }

  num get removeTrailingZeros => num.parse(removeTrailingZerosToString);
}

extension NumExt on num {
  double get w {
    if (appConfig.scaleSizeEnable) {
      return appConfig.convertSW(this);
    } else {
      return appConfig.convertW(this);
    }
  }

  double get h {
    if (appConfig.scaleSizeEnable) {
      return appConfig.convertSH(this);
    } else {
      return appConfig.convertH(this);
    }
  }

  double get r {
    if (appConfig.scaleSizeEnable) {
      return appConfig.convertSR(this);
    } else {
      return appConfig.convertR(this);
    }
  }

  double get sw => appConfig.convertSW(this);

  double get sh => appConfig.convertSH(this);

  double get sr => appConfig.convertSR(this);
}

extension DoubleExt on double {
  double get spw => appConfig.convertSPW(this);

  double get sph => appConfig.convertSPH(this);

  double get spr => appConfig.convertSPR(this);
}
