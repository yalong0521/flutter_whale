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
    String? name,
  }) {
    var route = PageTransition<T>(
      child: page,
      arguments: arguments,
      type: transition ?? appConfig.pageTransitionType,
      fullscreenDialog: fullscreenDialog,
      opaque: opaque,
      maintainState: maintainState,
      name: name,
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

  static Future<T?> toOff<T>(
    Widget page, {
    Object? arguments,
    TransitionType? transition,
    bool fullscreenDialog = false,
    bool opaque = true,
    bool maintainState = true,
    BuildContext? context,
    String? name,
    required String offToName,
  }) {
    return Navigator.of(context ?? baseContext).pushAndRemoveUntil<T>(
      PageTransition<T>(
        child: page,
        arguments: arguments,
        type: transition ?? appConfig.pageTransitionType,
        fullscreenDialog: fullscreenDialog,
        opaque: opaque,
        maintainState: maintainState,
        name: name,
      ),
      ModalRoute.withName(offToName),
    );
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
    String? name,
  }) {
    return Navigator.of(context ?? baseContext).pushReplacement<T, TO>(
      PageTransition(
        child: page,
        arguments: arguments,
        type: transition ?? appConfig.pageTransitionType,
        fullscreenDialog: fullscreenDialog,
        opaque: opaque,
        maintainState: maintainState,
        name: name,
      ),
      result: result,
    );
  }

  static void pop<T>({T? result, BuildContext? context}) {
    Navigator.of(context ?? baseContext).pop<T>(result);
  }

  static void popUntil(RoutePredicate predicate, {BuildContext? context}) {
    Navigator.of(context ?? baseContext).popUntil(predicate);
  }
}

class PageTransition<T> extends PageRouteBuilder<T> {
  final Widget child;

  final TransitionType type;

  final Object? arguments;

  final String? name;

  final Curve _curve = Curves.ease;

  PageTransition({
    Key? key,
    required this.child,
    required this.type,
    this.arguments,
    this.name,
    super.fullscreenDialog,
    super.opaque,
    super.maintainState,
    super.transitionDuration,
    super.reverseTransitionDuration,
  }) : super(
          pageBuilder: (buildContext, animation, secondaryAnimation) => child,
          settings: RouteSettings(arguments: arguments, name: name),
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
