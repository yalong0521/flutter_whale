import 'package:flutter/material.dart';
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
  final TapBehavior behavior;
  final int? milliseconds;
  final bool enable;
  final bool focusFeedbackEnable;

  const TapWrapper({
    super.key,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.behavior = TapBehavior.throttle,
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
    Widget child = isMobile
        ? widget.child
        : MouseRegion(
            cursor: widget.enable
                ? SystemMouseCursors.click
                : SystemMouseCursors.forbidden,
            child: widget.child,
            onEnter: (event) => _notifyOpacityChanged(0.9),
            onExit: (event) => _notifyOpacityChanged(1),
          );
    return widget.enable
        ? Focus(
            onFocusChange: (hasFocus) => setState(() => _hasFocus = hasFocus),
            onKeyEvent: (FocusNode node, KeyEvent event) {
              if (event.logicalKey == LogicalKeyboardKey.select) {
                if (event is KeyDownEvent) {
                  _notifyOpacityChanged(0.8);
                  return KeyEventResult.handled;
                } else if (event is KeyUpEvent) {
                  _notifyOpacityChanged(1);
                  _onTap();
                  return KeyEventResult.handled;
                }
              }
              return KeyEventResult.ignored;
            },
            child: widget.focusFeedbackEnable
                ? AnimatedScale(
                    scale: _hasFocus ? 1.1 : 1,
                    duration: kThemeAnimationDuration,
                    child: _gestureDetector(child),
                  )
                : _gestureDetector(child),
          )
        : Opacity(opacity: 0.5, child: child);
  }

  Widget _gestureDetector(Widget child) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: widget.onLongPress,
      onTapDown: (details) => _notifyOpacityChanged(0.8),
      onTapUp: (details) {
        _notifyOpacityChanged(1);
        _onTap();
      },
      onTapCancel: () => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _pressOpacity = 1);
      }),
      child: AnimatedOpacity(
        opacity: _pressOpacity,
        duration: kThemeAnimationDuration,
        child: child,
      ),
    );
  }

  void _notifyOpacityChanged(double opacity) {
    setState(() => _pressOpacity = opacity);
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
