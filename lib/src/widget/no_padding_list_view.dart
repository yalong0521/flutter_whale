import 'package:flutter/widgets.dart';

class NoPaddingListView extends ListView {
  NoPaddingListView.builder({
    super.key,
    required NullableIndexedWidgetBuilder itemBuilder,
    int? itemCount,
    Axis scrollDirection = Axis.vertical,
    bool shrinkWrap = false,
    ScrollController? controller,
    ScrollPhysics? physics,
  }) : super.builder(
          itemBuilder: itemBuilder,
          itemCount: itemCount,
          padding: EdgeInsets.zero,
          scrollDirection: scrollDirection,
          shrinkWrap: shrinkWrap,
          controller: controller,
          physics: physics,
        );

  NoPaddingListView.separated({
    super.key,
    required NullableIndexedWidgetBuilder itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
    required int itemCount,
    Axis scrollDirection = Axis.vertical,
    bool shrinkWrap = false,
    ScrollController? controller,
    ScrollPhysics? physics,
  }) : super.separated(
          itemBuilder: itemBuilder,
          separatorBuilder: separatorBuilder,
          itemCount: itemCount,
          padding: EdgeInsets.zero,
          scrollDirection: scrollDirection,
          shrinkWrap: shrinkWrap,
          controller: controller,
          physics: physics,
        );
}
