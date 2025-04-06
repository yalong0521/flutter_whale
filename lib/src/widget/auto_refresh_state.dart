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
    if (appConfig.scaleSizeEnable ||
        screenWidth < appConfig.designSize.width ||
        screenHeight < appConfig.designSize.height) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
