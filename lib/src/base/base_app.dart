import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';

typedef DpConverter = double Function(num dp);

typedef SpConverter = double Function(num sp);

typedef BaseWidgetBuilder = Widget Function(
    BuildContext context, GlobalKey<NavigatorState> baseKey);

BuildContext get baseContext => _baseKey.currentContext!;

AppConfig get appConfig => Provider.of<AppConfig>(baseContext, listen: false);

final GlobalKey<NavigatorState> _baseKey = GlobalKey<NavigatorState>();

class AppConfig extends ChangeNotifier {
  String? logTag;
  ToastConfig? toastConfig;
  double? appTextDefaultSize;
  TransitionType pageTransitionType;
  TransitionType dialogTransitionType;
  DpConverter dpConverter;
  SpConverter spConverter;
  LoadingConfig loadingConfig;
  ScreenValueGetter screenValueGetter;

  AppConfig({
    this.logTag,
    this.toastConfig,
    this.appTextDefaultSize,
    TransitionType? pageTransitionType,
    TransitionType? dialogTransitionType,
    DpConverter? dpConverter,
    SpConverter? spConverter,
    LoadingConfig? loadingConfig,
    required this.screenValueGetter,
  })  : pageTransitionType = TransitionType.theme,
        dialogTransitionType = TransitionType.fade,
        dpConverter = dpConverter ?? ((dp) => dp.toDouble()),
        spConverter = spConverter ?? ((sp) => sp.toDouble()),
        loadingConfig = loadingConfig ??
            LoadingConfig(builder: (text) => DefaultLoadingDialog(text));

  void updata({
    String? newTag,
    ToastConfig? newConfig,
    double? newSize,
    TransitionType? newPageType,
    TransitionType? newDialogType,
    DpConverter? newDpConverter,
    SpConverter? newSpConverter,
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

mixin ScreenValueGetter {
  double get screenWidth;

  double get screenHeight;

  double get bottomBarHeight;

  double get statusBarHeight;
}

class BaseApp extends StatefulWidget {
  final BaseWidgetBuilder builder;
  final String? logTag;
  final ToastConfig? toastConfig;
  final double? appTextDefaultSize;
  final TransitionType? pageTransitionType;
  final TransitionType? dialogTransitionType;
  final DpConverter dpConverter;
  final SpConverter spConverter;
  final LoadingConfig loadingConfig;
  final ScreenValueGetter screenValueGetter;

  const BaseApp({
    super.key,
    required this.builder,
    this.logTag,
    this.toastConfig,
    this.appTextDefaultSize,
    this.pageTransitionType,
    this.dialogTransitionType,
    required this.dpConverter,
    required this.spConverter,
    required this.loadingConfig,
    required this.screenValueGetter,
  });

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
    screenValueGetter: widget.screenValueGetter,
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
