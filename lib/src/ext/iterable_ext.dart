import 'package:flutter/material.dart';

extension IterableExt<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension ListExt<E> on List<E?> {
  List<E> removeNullValue() {
    final noneNullList = <E>[];
    for (var value in this) {
      if (value != null) noneNullList.add(value);
    }
    return noneNullList;
  }

  int? indexWhereOrNull(bool Function(E element) test) {
    for (int i = 0; i < length; i++) {
      var element = this[i];
      if (element == null) continue;
      if (test(element)) return i;
    }
    return null;
  }
}

extension NullableIterbleExt<E> on Iterable<E>? {
  bool get nullOrEmpty => this == null || this!.isEmpty;

  bool get notNullAndNotEmpty => this != null && this!.isNotEmpty;
}

extension WidgetListExt on List<Widget> {
  List<Widget> addSeparator(Widget Function(int index) separatorBuilder) {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      list.add(this[i]);
      if (i != length - 1) {
        list.add(separatorBuilder(i));
      }
    }
    return list;
  }
}

extension ListNullableExt<T> on List<T>? {
  bool containsT(T t) {
    final temp = this;
    if (temp == null || temp.isEmpty) return false;
    return temp.contains(t);
  }

  bool anyT(bool Function(T element) test) {
    final temp = this;
    if (temp == null || temp.isEmpty) return false;
    return temp.any(test);
  }
}
