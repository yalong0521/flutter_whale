import 'package:flutter/cupertino.dart';
import 'package:flutter_whale/flutter_whale.dart';

enum TapType { none, throttle, debounce }

class TapWrapper extends StatefulWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final GestureLongPressCallback? onLongPress;
  final double? pressedOpacity;
  final TapType tapType;
  final int? milliseconds;

  const TapWrapper({
    super.key,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.pressedOpacity,
    this.tapType = TapType.none,
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
    _onTap = widget.tapType == TapType.debounce
        ? widget.onTap.debounce(widget.milliseconds)
        : widget.tapType == TapType.throttle
            ? widget.onTap.throttle(widget.milliseconds)
            : widget.onTap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
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
    if (oldWidget.tapType != widget.tapType) {
      _onTap = widget.tapType == TapType.debounce
          ? widget.onTap.debounce(widget.milliseconds)
          : widget.tapType == TapType.throttle
              ? widget.onTap.throttle(widget.milliseconds)
              : widget.onTap;
    }
  }
}
