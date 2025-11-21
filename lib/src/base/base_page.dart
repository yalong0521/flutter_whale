import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';

abstract class BasePage<M extends BaseModel> extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  M createModel(BuildContext context);

  /// 页面跳转的时候使用
  Future<T?> to<T>({
    arguments,
    TransitionType? transition,
    bool clearStack = false,
    bool? opaque,
    BuildContext? context,
    bool fullscreenDialog = false,
  }) {
    return RouteUtil.to<T>(
      ChangeNotifierProvider(create: createModel, child: this),
      arguments: arguments,
      transition: transition,
      clearStack: clearStack,
      opaque: opaque ?? true,
      context: context,
      name: name,
      fullscreenDialog: fullscreenDialog,
    );
  }

  /// 页面跳转的时候使用
  Future<T?> toOff<T>({
    arguments,
    TransitionType? transition,
    bool? opaque,
    BuildContext? context,
    required String offToName,
  }) {
    return RouteUtil.toOff<T>(
      ChangeNotifierProvider(create: createModel, child: this),
      arguments: arguments,
      transition: transition,
      opaque: opaque ?? true,
      context: context,
      name: name,
      offToName: offToName,
    );
  }

  /// 页面跳转的时候使用
  Future<T?> off<T, TO>({
    arguments,
    TransitionType? transition,
    TO? result,
    bool? opaque,
    BuildContext? context,
  }) {
    return RouteUtil.off<T, TO>(
      ChangeNotifierProvider(create: createModel, child: this),
      arguments: arguments,
      transition: transition,
      result: result,
      opaque: opaque ?? true,
      context: context,
      name: name,
    );
  }

  /// 如果不是页面跳转形式的，例如嵌套在PageView里面的用这个
  Widget page({Key? key}) =>
      ChangeNotifierProvider(create: createModel, key: key, child: this);

  String? get name => null;
}

abstract class BaseState<P extends BasePage, M extends BaseModel>
    extends AutoRefreshState<P> {
  M get model => Provider.of<M>(context, listen: false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) model.init();
    });
    super.initState();
  }

  Selector<M, D> selector<D>({
    required D Function(BuildContext, M) selector,
    required ValueWidgetBuilder<D> builder,
    ShouldRebuild<D>? shouldRebuild,
    Widget? child,
  }) {
    return Selector<M, D>(
      selector: selector,
      builder: builder,
      shouldRebuild: shouldRebuild,
      child: child,
    );
  }

  T select<T>(T Function(M model) selector, {BuildContext? ctx}) {
    return (ctx ?? context).select<M, T>(selector);
  }
}
