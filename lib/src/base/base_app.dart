import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';

typedef SizeConverter = double Function(num size);

typedef BaseWidgetBuilder = Widget Function(
    BuildContext context, GlobalKey<NavigatorState> baseKey);

BuildContext get baseContext => _baseKey.currentContext!;

AppConfig get appConfig => Provider.of<AppConfig>(baseContext, listen: false);

final GlobalKey<NavigatorState> _baseKey = GlobalKey<NavigatorState>();

class AppConfig extends ChangeNotifier {
  ToastConfig? toastConfig;
  double appTextDefaultSize;
  bool log2File;
  TransitionType pageTransitionType;
  TransitionType dialogTransitionType;
  SizeConverter awConverter;
  SizeConverter ahConverter;
  SizeConverter aspConverter;
  LoadingConfig loadingConfig;

  AppConfig({
    this.toastConfig,
    required this.appTextDefaultSize,
    required this.log2File,
    required this.pageTransitionType,
    required this.dialogTransitionType,
    required this.awConverter,
    required this.ahConverter,
    required this.aspConverter,
    required this.loadingConfig,
  });

  void update({
    bool? newLog2File,
    ToastConfig? newConfig,
    double newSize = 18,
    TransitionType? newPageType,
    TransitionType? newDialogType,
    SizeConverter? newAwConverter,
    SizeConverter? newAhConverter,
    SizeConverter? newAspConverter,
    LoadingConfig? newLoadingConfig,
  }) {
    if (newLog2File != null) log2File = newLog2File;
    if (newConfig != toastConfig) toastConfig = newConfig;
    if (newSize != appTextDefaultSize) {
      appTextDefaultSize = newSize;
      notifyListeners();
    }
    if (newPageType != pageTransitionType) {
      pageTransitionType = newPageType ?? TransitionType.theme;
    }
    if (newDialogType != dialogTransitionType) {
      dialogTransitionType = newDialogType ?? TransitionType.fade;
    }
    if (newAwConverter != awConverter) {
      awConverter = newAwConverter ?? _defaultConverter;
    }
    if (newAhConverter != ahConverter) {
      ahConverter = newAhConverter ?? _defaultConverter;
    }
    if (newAspConverter != aspConverter) {
      aspConverter = newAspConverter ?? _defaultConverter;
    }
    if (newLoadingConfig != loadingConfig) {
      loadingConfig = newLoadingConfig ??
          LoadingConfig(builder: (text) => DefaultLoadingDialog(text));
    }
  }
}

double Function(num value) _defaultConverter = (num value) => value.toDouble();

LoadingConfig _defaultLoadingConfig =
    LoadingConfig(builder: (text) => DefaultLoadingDialog(text));

class BaseApp extends StatefulWidget {
  final BaseWidgetBuilder builder;
  final bool log2File;
  final ToastConfig? toastConfig;
  final double appTextDefaultSize;
  final TransitionType pageTransitionType;
  final TransitionType dialogTransitionType;
  final SizeConverter awConverter;
  final SizeConverter ahConverter;
  final SizeConverter aspConverter;
  final LoadingConfig loadingConfig;

  BaseApp({
    super.key,
    required this.builder,
    this.log2File = false,
    this.toastConfig,
    this.appTextDefaultSize = 18,
    this.pageTransitionType = TransitionType.theme,
    this.dialogTransitionType = TransitionType.fade,
    SizeConverter? awConverter,
    SizeConverter? ahConverter,
    SizeConverter? aspConverter,
    LoadingConfig? loadingConfig,
  })  : awConverter = awConverter ?? _defaultConverter,
        ahConverter = ahConverter ?? _defaultConverter,
        aspConverter = aspConverter ?? _defaultConverter,
        loadingConfig = loadingConfig ?? _defaultLoadingConfig;

  @override
  State<StatefulWidget> createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  late final AppConfig _appConfig = AppConfig(
    log2File: widget.log2File,
    toastConfig: widget.toastConfig,
    appTextDefaultSize: widget.appTextDefaultSize,
    pageTransitionType: widget.pageTransitionType,
    dialogTransitionType: widget.dialogTransitionType,
    awConverter: widget.awConverter,
    ahConverter: widget.ahConverter,
    aspConverter: widget.aspConverter,
    loadingConfig: widget.loadingConfig,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppConfig>(
      create: (BuildContext context) => _appConfig,
      child: widget.builder(context, _baseKey),
    );
  }

  @override
  void didUpdateWidget(covariant BaseApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    _appConfig.update(
      newLog2File: widget.log2File,
      newConfig: widget.toastConfig,
      newSize: widget.appTextDefaultSize,
      newPageType: widget.pageTransitionType,
      newDialogType: widget.dialogTransitionType,
      newAwConverter: widget.awConverter,
      newAhConverter: widget.ahConverter,
      newAspConverter: widget.aspConverter,
      newLoadingConfig: widget.loadingConfig,
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

class ToastConfig {
  final Toast Function(String text)? toast;
  final Widget Function(String text)? builder;

  const ToastConfig({this.toast, this.builder});
}
