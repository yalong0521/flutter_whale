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
  String logTag;
  ToastConfig? toastConfig;
  TransitionType pageTransitionType;
  TransitionType dialogTransitionType;
  DpConverter dpConverter;
  SpConverter spConverter;
  LoadingConfig loadingConfig;

  AppConfig({
    this.logTag = '基础组件',
    this.toastConfig,
    this.pageTransitionType = TransitionType.theme,
    this.dialogTransitionType = TransitionType.fade,
    DpConverter? dpConverter,
    SpConverter? spConverter,
    LoadingConfig? loadingConfig,
  })  : dpConverter = dpConverter ?? ((dp) => dp.toDouble()),
        spConverter = spConverter ?? ((sp) => sp.toDouble()),
        loadingConfig = loadingConfig ??
            LoadingConfig(
              builder: (text) => DefaultLoadingDialog(text),
              cancelable: false,
              barrierColor: Colors.black38,
            );
}

class BaseApp extends StatelessWidget {
  final AppConfig? appConfig;
  final BaseWidgetBuilder builder;

  const BaseApp({super.key, this.appConfig, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppConfig>(
      create: (BuildContext context) => appConfig ?? AppConfig(),
      child: builder(context, _baseKey),
    );
  }
}

class LoadingConfig {
  final Widget Function(String? text) builder;
  final bool cancelable;
  final Color barrierColor;

  const LoadingConfig(
      {required this.builder,
      required this.cancelable,
      required this.barrierColor});
}

class ToastConfig {
  final Toast Function(String text)? toast;
  final Widget Function(String text)? builder;

  const ToastConfig({this.toast, this.builder});
}
