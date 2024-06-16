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
  String logTag;
  TransitionType pageTransitionType;
  TransitionType dialogTransitionType;
  SizeConverter dpConverter;
  SizeConverter spConverter;
  LoadingConfig loadingConfig;

  AppConfig({
    this.toastConfig,
    required this.appTextDefaultSize,
    required this.logTag,
    required this.pageTransitionType,
    required this.dialogTransitionType,
    required this.dpConverter,
    required this.spConverter,
    required this.loadingConfig,
  });

  void updata({
    String newTag = '基础组件',
    ToastConfig? newConfig,
    double newSize = 18,
    TransitionType? newPageType,
    TransitionType? newDialogType,
    SizeConverter? newDpConverter,
    SizeConverter? newSpConverter,
    LoadingConfig? newLoadingConfig,
  }) {
    if (newTag != logTag) logTag = newTag;
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
    if (newDpConverter != dpConverter) {
      dpConverter = newDpConverter ?? ((dp) => dp.toDouble());
    }
    if (newSpConverter != spConverter) {
      spConverter = newSpConverter ?? ((sp) => sp.toDouble());
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
  final String logTag;
  final ToastConfig? toastConfig;
  final double appTextDefaultSize;
  final TransitionType pageTransitionType;
  final TransitionType dialogTransitionType;
  final SizeConverter dpConverter;
  final SizeConverter spConverter;
  final LoadingConfig loadingConfig;

  BaseApp({
    super.key,
    required this.builder,
    this.logTag = '基础组件',
    this.toastConfig,
    this.appTextDefaultSize = 18,
    this.pageTransitionType = TransitionType.theme,
    this.dialogTransitionType = TransitionType.fade,
    SizeConverter? dpConverter,
    SizeConverter? spConverter,
    LoadingConfig? loadingConfig,
  })  : dpConverter = dpConverter ?? _defaultConverter,
        spConverter = spConverter ?? _defaultConverter,
        loadingConfig = loadingConfig ?? _defaultLoadingConfig;

  @override
  State<StatefulWidget> createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  late final AppConfig _appConfig = AppConfig(
    logTag: widget.logTag,
    toastConfig: widget.toastConfig,
    appTextDefaultSize: widget.appTextDefaultSize,
    pageTransitionType: widget.pageTransitionType,
    dialogTransitionType: widget.dialogTransitionType,
    dpConverter: widget.dpConverter,
    spConverter: widget.spConverter,
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
    _appConfig.updata(
      newTag: widget.logTag,
      newConfig: widget.toastConfig,
      newSize: widget.appTextDefaultSize,
      newPageType: widget.pageTransitionType,
      newDialogType: widget.dialogTransitionType,
      newDpConverter: widget.dpConverter,
      newSpConverter: widget.spConverter,
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
