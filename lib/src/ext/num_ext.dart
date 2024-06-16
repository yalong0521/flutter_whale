import 'package:flutter_whale/flutter_whale.dart';

extension DoubleExt on num {
  double get aw => appConfig.dpConverter(this);

  double get asp => appConfig.spConverter(this);
}
