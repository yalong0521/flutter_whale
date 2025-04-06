import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AppVisibilityDetector extends StatefulWidget {
  /// 是否忽略第一次可见，如果忽略，第一次可见时不会回调onVisible
  final bool ignoreFirstVisible;
  final VoidCallback onVisible;
  final Widget child;

  const AppVisibilityDetector({
    super.key,
    required this.onVisible,
    this.ignoreFirstVisible = false,
    required this.child,
  });

  @override
  State<AppVisibilityDetector> createState() => _AppVisibilityDetectorState();
}

class _AppVisibilityDetectorState extends State<AppVisibilityDetector> {
  bool _firstVisibleFlag = false;
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(this),
      onVisibilityChanged: (info) {
        final visibleFraction = info.visibleFraction;
        if (visibleFraction == 1) {
          if (_isVisible) return;
          _isVisible = true;
          if (_firstVisibleFlag || !widget.ignoreFirstVisible) {
            widget.onVisible();
          }
          _firstVisibleFlag = true;
        } else if (visibleFraction == 0) {
          _isVisible = false;
        }
      },
      child: widget.child,
    );
  }
}
