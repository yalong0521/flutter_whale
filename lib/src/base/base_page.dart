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
  }) {
    return RouteUtil.to<T>(
      ChangeNotifierProvider(create: createModel, child: this),
      arguments: arguments,
      transition: transition,
      clearStack: clearStack,
      opaque: opaque ?? true,
      context: context,
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
    );
  }

  /// 如果不是页面跳转形式的，例如嵌套在PageView里面的用这个
  Widget page({Key? key}) =>
      ChangeNotifierProvider(create: createModel, key: key, child: this);
}

abstract class BaseState<E extends BasePage, T extends BaseModel>
    extends State<E> {
  T get model => Provider.of<T>(context, listen: false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) model.init();
    });
    super.initState();
  }
}
