import 'package:flutter_whale/flutter_whale.dart';

extension NumExt on num {
  double get w {
    if (appConfig.scaleSize) {
      return appConfig.convertSW(this);
    } else {
      return appConfig.convertW(this);
    }
  }

  double get h {
    if (appConfig.scaleSize) {
      return appConfig.convertSH(this);
    } else {
      return appConfig.convertH(this);
    }
  }

  double get r {
    if (appConfig.scaleSize) {
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
