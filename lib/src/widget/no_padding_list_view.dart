import 'package:flutter/widgets.dart';

class NoPaddingListView extends StatelessWidget {
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final int itemCount;
  final Axis? scrollDirection;
  final bool removeBottom;
  final bool removeLeft;
  final bool removeTop;
  final bool removeRight;

  const NoPaddingListView.builder({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.scrollDirection,
    this.removeBottom = true,
    this.removeLeft = true,
    this.removeTop = true,
    this.removeRight = true,
  }) : separatorBuilder = null;

  const NoPaddingListView.separated({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required IndexedWidgetBuilder this.separatorBuilder,
    this.scrollDirection,
    this.removeBottom = true,
    this.removeLeft = true,
    this.removeTop = true,
    this.removeRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: removeBottom,
      removeLeft: removeLeft,
      removeTop: removeTop,
      removeRight: removeRight,
      child: _listView,
    );
  }

  Widget get _listView => separatorBuilder != null
      ? ListView.separated(
          itemBuilder: itemBuilder,
          itemCount: itemCount,
          separatorBuilder: separatorBuilder!,
          scrollDirection: scrollDirection ?? Axis.vertical,
        )
      : ListView.builder(
          itemBuilder: itemBuilder,
          itemCount: itemCount,
          scrollDirection: scrollDirection ?? Axis.vertical,
        );
}
