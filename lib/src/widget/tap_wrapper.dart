import 'package:flutter/cupertino.dart';

class TapWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final double? pressedOpacity;

  const TapWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.pressedOpacity,
  });

  @override
  State<StatefulWidget> createState() => _TapWrapperState();
}

class _TapWrapperState extends State<TapWrapper> {
  double _pressOpacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.onTap?.call(),
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
}
