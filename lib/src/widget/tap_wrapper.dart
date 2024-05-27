import 'package:flutter/cupertino.dart';
import 'package:flutter_whale/flutter_whale.dart';

enum TapBehavior {
  /// 不做处理
  none,

  /// 节流：马上触发，指定时间[milliseconds]内不会再次触发
  throttle,

  /// 防抖：延迟指定时间触发[milliseconds]
  debounce;
}

class TapWrapper extends StatefulWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final GestureLongPressCallback? onLongPress;
  final double? pressedOpacity;
  final TapBehavior behavior;
  final int? milliseconds;

  const TapWrapper({
    super.key,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.pressedOpacity,
    this.behavior = TapBehavior.none,
    this.milliseconds,
  });

  @override
  State<StatefulWidget> createState() => _TapWrapperState();
}

class _TapWrapperState extends State<TapWrapper> {
  double _pressOpacity = 1.0;
  late GestureTapCallback _onTap;

  @override
  void initState() {
    _processBehavior();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(),
      onLongPress: widget.onLongPress,
      onTapDown: (details) => notifyOpacityChanged(true),
      onTapUp: (details) => notifyOpacityChanged(false),
      onTapCancel: () => notifyOpacityChanged(false),
      child: Opacity(opacity: _pressOpacity, child: widget.child),
    );
  }

  void notifyOpacityChanged(bool pressed) {
    setState(() {
      _pressOpacity = pressed ? widget.pressedOpacity ?? 0.5 : 1.0;
    });
  }

  @override
  void didUpdateWidget(covariant TapWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.behavior != widget.behavior ||
        oldWidget.onTap != widget.onTap) {
      _processBehavior();
    }
  }

  void _processBehavior() {
    _onTap = widget.behavior == TapBehavior.debounce
        ? widget.onTap.debounce(widget.milliseconds)
        : widget.behavior == TapBehavior.throttle
            ? widget.onTap.throttle(widget.milliseconds)
            : widget.onTap;
  }
}
