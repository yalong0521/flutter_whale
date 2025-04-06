import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_whale/flutter_whale.dart';

typedef BaseWidgetBuilder = Widget Function(
    BuildContext context, GlobalKey<NavigatorState> baseKey);

BuildContext get baseContext => _baseKey.currentContext!;

AppConfig get appConfig => Provider.of<AppConfig>(baseContext, listen: false);

final GlobalKey<NavigatorState> _baseKey = GlobalKey<NavigatorState>();

class AppConfig extends ChangeNotifier {
  ToastBuilder? toastBuilder;
  ValueGetter<double>? appTextDefaultSize;
  bool log2File;
  TransitionType pageTransitionType;
  TransitionType dialogTransitionType;
  LoadingConfig loadingConfig;
  Size designSize;
  bool scaleSizeEnable;
  double? scaleSizeUpperLimit;

  AppConfig({
    this.toastBuilder,
    this.appTextDefaultSize,
    required this.log2File,
    required this.pageTransitionType,
    required this.dialogTransitionType,
    required this.loadingConfig,
    required this.designSize,
    required this.scaleSizeEnable,
    this.scaleSizeUpperLimit,
  });

  void update({
    bool? newLog2File,
    ToastBuilder? newToastBuilder,
    ValueGetter<double>? newAppTextDefaultSize,
    TransitionType? newPageType,
    TransitionType? newDialogType,
    LoadingConfig? newLoadingConfig,
    Size? newDesignSize,
    bool? newScaleSize,
    double? newScaleSizeUpperLimit,
  }) {
    if (newLog2File != null) log2File = newLog2File;
    if (newToastBuilder != toastBuilder) toastBuilder = newToastBuilder;
    if (newAppTextDefaultSize != null) {
      appTextDefaultSize = newAppTextDefaultSize;
    }
    if (newPageType != pageTransitionType) {
      pageTransitionType = newPageType ?? TransitionType.theme;
    }
    if (newDialogType != dialogTransitionType) {
      dialogTransitionType = newDialogType ?? TransitionType.fade;
    }
    if (newLoadingConfig != loadingConfig) {
      loadingConfig = newLoadingConfig ??
          LoadingConfig(builder: (text) => DefaultLoadingDialog(text));
    }
    if (newDesignSize != null) designSize = newDesignSize;
    if (newScaleSize != null) scaleSizeEnable = newScaleSize;
    scaleSizeUpperLimit = newScaleSizeUpperLimit;
    notifyListeners();
  }

  double convertW(num size) {
    var screenSize = MediaQuery.sizeOf(baseContext);
    return _calc(screenSize.width, designSize.width, size);
  }

  double convertH(num size) {
    var screenSize = MediaQuery.sizeOf(baseContext);
    return _calc(screenSize.height, designSize.height, size);
  }

  double convertR(num size) => min(convertW(size), convertH(size));

  double convertSW(num size) {
    var screenSize = MediaQuery.sizeOf(baseContext);
    var upperLimit = appConfig.scaleSizeUpperLimit;
    var scale = screenSize.width / designSize.width;
    return (upperLimit == null ? scale : min(scale, upperLimit)) * size;
  }

  double convertSH(num size) {
    var screenSize = MediaQuery.sizeOf(baseContext);
    var upperLimit = appConfig.scaleSizeUpperLimit;
    var scale = screenSize.height / designSize.height;
    return (upperLimit == null ? scale : min(scale, upperLimit)) * size;
  }

  double convertSR(num size) => min(convertSW(size), convertSH(size));

  double convertSPW(double percent) {
    percent = max(0, min(1, percent));
    var screenSize = MediaQuery.sizeOf(baseContext);
    return screenSize.width * percent;
  }

  double convertSPH(double percent) {
    percent = max(0, min(1, percent));
    var screenSize = MediaQuery.sizeOf(baseContext);
    return screenSize.height * percent;
  }

  double convertSPR(double size) => min(convertSPW(size), convertSPH(size));

  double _calc(double screen, double design, num value) {
    if (screen >= design) return value.toDouble();
    return value * screen / design;
  }
}

LoadingConfig _defaultLoadingConfig =
    LoadingConfig(builder: (text) => DefaultLoadingDialog(text));

class BaseApp extends StatefulWidget {
  final BaseWidgetBuilder builder;
  final Size designSize;
  final bool log2File;
  final ToastBuilder? toastBuilder;
  final ValueGetter<double>? appTextDefaultSize;
  final TransitionType pageTransitionType;
  final TransitionType dialogTransitionType;
  final LoadingConfig loadingConfig;
  final bool scaleSizeEnable;
  final double? scaleSizeUpperLimit;

  BaseApp({
    super.key,
    required this.builder,
    required this.designSize,
    this.log2File = false,
    this.toastBuilder,
    this.appTextDefaultSize,
    this.pageTransitionType = TransitionType.theme,
    this.dialogTransitionType = TransitionType.fade,
    LoadingConfig? loadingConfig,
    this.scaleSizeEnable = false,
    this.scaleSizeUpperLimit,
  }) : loadingConfig = loadingConfig ?? _defaultLoadingConfig;

  @override
  State<StatefulWidget> createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  late final AppConfig _appConfig = AppConfig(
    log2File: widget.log2File,
    toastBuilder: widget.toastBuilder,
    appTextDefaultSize: widget.appTextDefaultSize,
    pageTransitionType: widget.pageTransitionType,
    dialogTransitionType: widget.dialogTransitionType,
    loadingConfig: widget.loadingConfig,
    designSize: widget.designSize,
    scaleSizeEnable: widget.scaleSizeEnable,
    scaleSizeUpperLimit: widget.scaleSizeUpperLimit,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppConfig>(
      create: (BuildContext context) => _appConfig,
      child: Portal(child: widget.builder(context, _baseKey)),
    );
  }

  @override
  void didUpdateWidget(covariant BaseApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    _appConfig.update(
      newLog2File: widget.log2File,
      newToastBuilder: widget.toastBuilder,
      newAppTextDefaultSize: widget.appTextDefaultSize,
      newPageType: widget.pageTransitionType,
      newDialogType: widget.dialogTransitionType,
      newLoadingConfig: widget.loadingConfig,
      newDesignSize: widget.designSize,
      newScaleSize: widget.scaleSizeEnable,
      newScaleSizeUpperLimit: widget.scaleSizeUpperLimit,
    );
  }
}

class LoadingConfig {
  final Widget Function(String? text) builder;
  final bool cancelable;
  final Color barrierColor;

  const LoadingConfig(
      {required this.builder, bool? cancelable, Color? barrierColor})
      : cancelable = cancelable ?? false,
        barrierColor = barrierColor ?? Colors.black38;
}

typedef ToastBuilder = Toast Function(String text);
