extension MapExt<K, V> on Map<K, V> {
  Map<K, V> removeNullValue() {
    removeWhere((key, value) => value == null);
    return this;
  }
}
