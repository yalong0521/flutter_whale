import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';

class RouteUtil {
  RouteUtil._();

  static dynamic arguments(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments;
  }

  static Future<T?> to<T>(
    Widget page, {
    Object? arguments,
    TransitionType? transition,
    bool fullscreenDialog = false,
    bool opaque = true,
    bool maintainState = true,
    bool clearStack = false,
    BuildContext? context,
  }) {
    var route = PageTransition<T>(
      child: page,
      arguments: arguments,
      type: transition ?? appConfig.pageTransitionType,
      fullscreenDialog: fullscreenDialog,
      opaque: opaque,
      maintainState: maintainState,
    );
    var navigator = Navigator.of(context ?? baseContext);
    if (clearStack) {
      return navigator.pushAndRemoveUntil<T>(
        route,
        (route) => false,
      );
    } else {
      return navigator.push<T>(route);
    }
  }

  static Future<T?> off<T, TO>(
    Widget page, {
    Object? arguments,
    TransitionType? transition,
    bool fullscreenDialog = false,
    bool opaque = true,
    bool maintainState = true,
    TO? result,
    BuildContext? context,
  }) {
    return Navigator.of(context ?? baseContext).pushReplacement<T, TO>(
      PageTransition(
        child: page,
        arguments: arguments,
        type: transition ?? appConfig.pageTransitionType,
        fullscreenDialog: fullscreenDialog,
        opaque: opaque,
        maintainState: maintainState,
      ),
      result: result,
    );
  }

  static void pop<T>({T? result, BuildContext? context}) {
    return Navigator.of(context ?? baseContext).pop<T>(result);
  }
}

class PageTransition<T> extends PageRouteBuilder<T> {
  final Widget child;

  final TransitionType type;

  final Object? arguments;

  final Curve _curve = Curves.ease;

  PageTransition({
    Key? key,
    required this.child,
    required this.type,
    this.arguments,
    super.fullscreenDialog,
    super.opaque,
    super.maintainState,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
          pageBuilder: (buildContext, animation, secondaryAnimation) => child,
          settings: RouteSettings(arguments: arguments),
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return TransitionUtil.pageTransition(
        type, _curve, context, animation, secondaryAnimation, child, this);
  }

  @override
  bool didPop(T? result) {
    if (DialogUtil.loadingIsShowing) return false;
    return super.didPop(result);
  }
}
