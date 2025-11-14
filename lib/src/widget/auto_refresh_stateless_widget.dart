import 'package:flutter/widgets.dart';
import 'package:flutter_whale/flutter_whale.dart';

abstract class AutoRefreshStatelessWidget extends StatefulWidget {
  const AutoRefreshStatelessWidget({super.key});

  Widget builder(BuildContext context);

  @override
  State<StatefulWidget> createState() => _AutoRefreshStatelessState();
}

class _AutoRefreshStatelessState
    extends AutoRefreshState<AutoRefreshStatelessWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
