import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
  final bool enable;
  final bool focusFeedbackEnable;

  const TapWrapper({
    super.key,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.pressedOpacity,
    this.behavior = TapBehavior.none,
    this.milliseconds,
    this.enable = true,
    this.focusFeedbackEnable = false,
  });

  @override
  State<StatefulWidget> createState() => _TapWrapperState();
}

class _TapWrapperState extends State<TapWrapper> {
  double _pressOpacity = 1.0;
  late GestureTapCallback _onTap;
  bool _hasFocus = false;

  @override
  void initState() {
    _processBehavior();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = MouseRegion(
      cursor: widget.enable
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      child: widget.child,
    );
    return widget.enable
        ? Focus(
            onFocusChange: (hasFocus) => setState(() => _hasFocus = hasFocus),
            onKeyEvent: (FocusNode node, KeyEvent event) {
              if (event.logicalKey == LogicalKeyboardKey.select) {
                if (event is KeyDownEvent) {
                  notifyOpacityChanged(true);
                  return KeyEventResult.handled;
                } else if (event is KeyUpEvent) {
                  notifyOpacityChanged(false);
                  _onTap();
                  return KeyEventResult.handled;
                }
              }
              return KeyEventResult.ignored;
            },
            child: widget.focusFeedbackEnable
                ? AnimatedScale(
                    scale: _hasFocus ? 1.1 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _onTap(),
                      onLongPress: widget.onLongPress,
                      onTapDown: (details) => notifyOpacityChanged(true),
                      onTapUp: (details) => notifyOpacityChanged(false),
                      onTapCancel: () => notifyOpacityChanged(false),
                      child: Opacity(opacity: _pressOpacity, child: child),
                    ),
                  )
                : GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onTap(),
                    onLongPress: widget.onLongPress,
                    onTapDown: (details) => notifyOpacityChanged(true),
                    onTapUp: (details) => notifyOpacityChanged(false),
                    onTapCancel: () => notifyOpacityChanged(false),
                    child: Opacity(opacity: _pressOpacity, child: child),
                  ),
          )
        : Opacity(opacity: 0.5, child: child);
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
