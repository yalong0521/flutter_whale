import 'package:flutter_whale/flutter_whale.dart';

extension DoubleExt on num {
  double get aw => appConfig.awConverter(this);

  double get ah => appConfig.ahConverter(this);

  double get asp => appConfig.aspConverter(this);
}
