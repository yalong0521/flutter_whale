import 'package:flutter/widgets.dart';
import 'package:flutter_whale/flutter_whale.dart';

/// Auto refresh when the application's dimensions change
abstract class AutoRefreshState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  Size? _viewSize;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _viewSize = context.viewSize;
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (appConfig.scaleSizeEnable ||
        screenWidth < appConfig.designSize.width ||
        screenHeight < appConfig.designSize.height) {
      final viewSize = context.viewSize;
      if (viewSize != _viewSize) {
        _viewSize = viewSize;
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

extension _ContextExt on BuildContext {
  Size get viewSize =>
      View.of(this).physicalSize / View.of(this).devicePixelRatio;
}
