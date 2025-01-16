import 'package:flutter/widgets.dart';

abstract class AutoRefreshStatelessWidget extends StatelessWidget {
  const AutoRefreshStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: builder);
  }

  Widget builder(BuildContext context, BoxConstraints constraints);
}
