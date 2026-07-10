import 'dart:ui';

import 'package:flutter/widgets.dart';

/// 全局物理安全区域工具类
///
/// 获取的是设备原始安全区域（viewPadding），
/// 不受软键盘弹出影响。
class ScreenUtil with WidgetsBindingObserver {
  ScreenUtil._();

  static final ScreenUtil _instance = ScreenUtil._();

  static EdgeInsets _padding = EdgeInsets.zero;
  static Size _screenSize = Size.zero;

  /// 初始化
  static void init() {
    WidgetsBinding.instance.addObserver(_instance);
    refresh();
  }

  /// 刷新安全区域
  static void refresh() {
    final FlutterView view =
        WidgetsBinding.instance.platformDispatcher.views.first;

    _padding = EdgeInsets.fromViewPadding(
      view.viewPadding,
      view.devicePixelRatio,
    );

    _screenSize = view.physicalSize / view.devicePixelRatio;
  }

  /// 释放（一般无需调用）
  static void dispose() {
    WidgetsBinding.instance.removeObserver(_instance);
  }

  @override
  void didChangeMetrics() => refresh();

  /// 整个安全区域
  static EdgeInsets get padding => _padding;

  /// 顶部安全距离（状态栏/刘海）
  static double get paddingTop => _padding.top;

  /// 底部安全距离（Home Indicator）
  static double get paddingBottom => _padding.bottom;

  /// 左侧安全距离
  static double get paddingLeft => _padding.left;

  /// 右侧安全距离
  static double get paddingRight => _padding.right;

  /// 屏幕尺寸
  static Size get screenSize => _screenSize;

  /// 屏幕宽度
  static double get screenWidth => _screenSize.width;

  /// 屏幕高度
  static double get screenHeight => _screenSize.height;
}
