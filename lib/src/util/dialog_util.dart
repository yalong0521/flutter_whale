import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';
import 'package:flutter_whale/src/ext/num_ext.dart';

class DialogUtil {
  DialogUtil._();

  static void showLoading({
    String? text,
    BuildContext? context,
  }) {
    var config = appConfig.loadingConfig;
    showDialog(
      context: context,
      barrierDismissible: config.cancelable,
      barrierColor: config.barrierColor,
      (context) => config.builder(text),
    );
  }

  static void hideLoading({
    BuildContext? context,
  }) {
    Navigator.of(context ?? baseContext).pop();
  }

  static Future<T?> showDialog<T>(
    WidgetBuilder builder, {
    TransitionType? transition,
    bool useSafeArea = true,
    bool barrierDismissible = true,
    Color barrierColor = Colors.black38,
    Object? arguments,
    BuildContext? context,
  }) {
    return Navigator.of(context ?? baseContext).push<T>(
      DialogTransition(
        builder: builder,
        type: transition ?? appConfig.dialogTransitionType,
        useSafeArea: useSafeArea,
        arguments: arguments,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
      ),
    );
  }
}

class DialogTransition<T> extends RawDialogRoute<T> {
  final TransitionType type;

  final Curve _curve = Curves.ease;

  DialogTransition({
    required this.type,
    required WidgetBuilder builder,
    required bool useSafeArea,
    super.barrierDismissible,
    super.barrierColor,
    super.transitionDuration,
    Object? arguments,
  }) : super(
          settings: RouteSettings(arguments: arguments),
          pageBuilder: (buildContext, animation, secondaryAnimation) {
            final Widget pageChild = Builder(builder: builder);
            return useSafeArea ? SafeArea(child: pageChild) : pageChild;
          },
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return TransitionUtil.dialogTransition(
        type, _curve, animation, secondaryAnimation, child);
  }
}

class DefaultLoadingDialog extends Dialog {
  final String? text;

  const DefaultLoadingDialog(this.text, {super.key});

  @override
  Color? get backgroundColor => Colors.transparent;

  @override
  double? get elevation => 0;

  @override
  Widget? get child => _DefaultLoadingDialogWidget(text);
}

class _DefaultLoadingDialogWidget extends StatelessWidget {
  final String? text;

  const _DefaultLoadingDialogWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false, child: Center(child: _body()));
  }

  Widget _body() {
    return Container(
      padding: text == null
          ? EdgeInsets.all(20.dp)
          : EdgeInsets.symmetric(vertical: 20.dp, horizontal: 40.dp),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8.dp),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoActivityIndicator(color: Colors.white, radius: 12.dp),
          if (text != null) ...[
            VSpacer(15.dp),
            Text(
              text!,
              style: TextStyle(fontSize: 14.sp, color: Colors.white70),
            ),
          ]
        ],
      ),
    );
  }
}
