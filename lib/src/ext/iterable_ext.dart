extension IterbleExt<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension ListExt<E> on List<E?> {
  List<E> removeNullValue() {
    removeWhere((e) => e == null);
    final noneNullList = <E>[];
    for (var value in this) {
      if (value != null) noneNullList.add(value);
    }
    return noneNullList;
  }
}

extension NullableIterbleExt<E> on Iterable<E>? {
  bool get nullOrEmpty => this == null || this!.isEmpty;

  bool get notNullAndNotEmpty => this != null && this!.isNotEmpty;
}
