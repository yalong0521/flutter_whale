import 'package:flutter/widgets.dart';
import 'package:flutter_whale/flutter_whale.dart';

/// Auto refresh when the application's dimensions change
abstract class AutoRefreshState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final screenSize = MediaQuery.of(context).size;
    if (appConfig.scaleSizeEnable || screenSize < appConfig.designSize) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
