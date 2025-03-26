import 'package:flutter/widgets.dart';

class NoPaddingSingleChildScrollView extends SingleChildScrollView {
  const NoPaddingSingleChildScrollView({
    super.key,
    super.scrollDirection,
    super.controller,
    super.physics,
    super.child,
  }) : super(padding: EdgeInsets.zero);
}
