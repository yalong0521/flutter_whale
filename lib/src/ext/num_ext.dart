import 'package:flutter_whale/flutter_whale.dart';

extension DoubleExt on num {
  double get dp => appConfig.dpConverter(this);

  double get sp => appConfig.spConverter(this);
}
