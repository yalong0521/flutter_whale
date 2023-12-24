import 'package:flutter_whale/flutter_whale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

typedef DpConverter = double Function(num dp);

typedef SpConverter = double Function(num sp);

typedef ToastBuilder = Widget Function(String text);

typedef BaseWidgetBuilder = Widget Function(
    BuildContext context, GlobalKey<NavigatorState> baseKey);

BuildContext get baseContext => _baseKey.currentContext!;

AppConfig get appConfig => Provider.of<AppConfig>(baseContext, listen: false);

final GlobalKey<NavigatorState> _baseKey = GlobalKey<NavigatorState>();

class AppConfig extends ChangeNotifier {
  String logTag;
  ToastBuilder? toastBuilder;
  TransitionType pageTransitionType;
  TransitionType dialogTransitionType;
  DpConverter dpConverter;
  SpConverter spConverter;

  AppConfig({
    this.logTag = '基础组件',
    this.toastBuilder,
    this.pageTransitionType = TransitionType.theme,
    this.dialogTransitionType = TransitionType.fade,
    DpConverter? dpConverter,
    SpConverter? spConverter,
  })  : dpConverter = dpConverter ?? ((dp) => dp.toDouble()),
        spConverter = spConverter ?? ((sp) => sp.toDouble());
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
