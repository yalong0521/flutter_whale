import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';
import 'package:flutter_whale/src/ext/num_ext.dart';

class ToastUtil {
  ToastUtil._();

  /// toast动画时长，单程300，一进一出600
  static const _animDuration = Duration(milliseconds: 300);

  /// toast显示时长，加上动画时长总共1800
  static const _showDuration = Duration(milliseconds: 1500);

  /// 存放待显示的消息
  static final Queue<Toast> _msgQueue = ListQueue();

  /// 用来复用
  static Toast? _previous;

  /// 最常用的方式，单独提供一个方法
  static void show(String text) => showImmediately(Toast(text));

  /// 按顺序显示，即等待前面的都显示完(如果有的话)再显示当前的
  static void showInOrder(Toast toast) => _showByYourself(toast, false);

  /// 立即显示，即清除之前没有显示的(如果有的话)立即显示当前的
  static void showImmediately(Toast toast) => _showByYourself(toast, true);

  static void _showByYourself(Toast toast, bool isImmediately) {
    if (_previous != null) {
      if (isImmediately) {
        if (_msgQueue.isNotEmpty) {
          _msgQueue.clear();
        }
        if (_previous!.toastState != null) {
          Toast reuse = _previous!;
          reuse.text = toast.text;
          reuse.gravity = toast.gravity;
          var state = reuse.toastState!;
          state.dismissTimer?.cancel();
          state.animController.value = 0;
          _realShow(reuse);
          state.animController.value = 1;
        } else {
          _realShow(toast);
        }
      } else {
        _msgQueue.add(toast);
      }
    } else {
      _realShow(toast);
    }
  }

  static void _realShow(Toast toast) {
    var overlayState = toast.toastState == null
        ? _getOverlayState()
        : toast.toastState!.overlayState;

    var animController = toast.toastState == null
        ? AnimationController(vsync: overlayState, duration: _animDuration)
        : toast.toastState!.animController;

    var animation = toast.toastState == null
        ? Tween(begin: 0.0, end: 1.0).animate(_getToastCurve(animController))
        : toast.toastState!.animation;

    var overlayEntry = toast.toastState == null
        ? _getOverlayEntry(toast, animation)
        : toast.toastState!.overlayEntry;

    if (toast.toastState == null) {
      // 监听动画状态
      animController.addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          // 完全显示了
          var dismiss = Timer(_showDuration, () => animController.reverse());
          toast.toastState?.dismissTimer = dismiss;
        } else if (status == AnimationStatus.dismissed) {
          // 完全隐藏了
          overlayEntry.remove();
          _previous = null;
          if (_msgQueue.isNotEmpty) {
            _realShow(_msgQueue.removeFirst());
          }
        }
      });
    }
    toast.toastState ??= ToastState(
      overlayState: overlayState,
      overlayEntry: overlayEntry,
      animation: animation,
      animController: animController,
    );
    _previous = toast;
    // 显示并开始动画
    overlayState.insert(overlayEntry);
    animController.forward();
  }

  static OverlayState _getOverlayState() {
    final navigatorState = Navigator.of(baseContext);
    return navigatorState.overlay!;
  }

  static OverlayEntry _getOverlayEntry(Toast toast, Animation<double> anim) {
    return OverlayEntry(
      builder: (_) => AnimatedBuilder(
        animation: anim,
        builder: (context, child) => Opacity(
          opacity: anim.value,
          child: child,
        ),
        child: IgnorePointer(
          child: Align(
            alignment: toast.gravity,
            child: _toastBuilder(toast.text),
          ),
        ),
      ),
    );
  }

  static ToastBuilder get _toastBuilder {
    var builder = appConfig.toastBuilder;
    if (builder != null) return builder;
    return (text) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 50.dp),
        padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 8.dp),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8.dp),
        ),
        child: AppText(text, size: 14.sp, color: Colors.white),
      );
    };
  }

  static CurvedAnimation _getToastCurve(Animation<double> parent) {
    return CurvedAnimation(parent: parent, curve: Curves.ease);
  }
}

/// 定义吐司类，方便后面扩展，带图片or自定义widget啥的
class Toast {
  String text;
  AlignmentDirectional gravity;
  ToastState? toastState;

  Toast(
    this.text, {
    this.gravity = AlignmentDirectional.center,
    this.toastState,
  });
}

class ToastState {
  final OverlayState overlayState;
  final OverlayEntry overlayEntry;
  final Animation<double> animation;
  final AnimationController animController;
  Timer? dismissTimer;

  ToastState({
    required this.overlayState,
    required this.overlayEntry,
    required this.animation,
    required this.animController,
  });
}
