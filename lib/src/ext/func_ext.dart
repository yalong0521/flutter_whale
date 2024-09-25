import 'dart:async';

extension FuncExt on Function() {
  /// 方法防抖
  void Function() debounce([int? milliseconds]) {
    Timer? debounceTimer;
    return () {
      if (debounceTimer?.isActive ?? false) debounceTimer?.cancel();
      debounceTimer = Timer(Duration(milliseconds: milliseconds ?? 250), this);
    };
  }

  /// 方法节流
  void Function() throttle([int? milliseconds]) {
    bool isAllowed = true;
    Timer? throttleTimer;
    return () {
      if (!isAllowed) return;
      isAllowed = false;
      this();
      throttleTimer?.cancel();
      throttleTimer = Timer(
        Duration(milliseconds: milliseconds ?? 250),
        () => isAllowed = true,
      );
    };
  }
}

//带参数的函数防抖，由于参数不固定就没有用过扩展，直接用方法包裹
void Function(T value) debounce<T>(void Function(T value) callback,
    [int milliseconds = 250]) {
  Timer? debounceTimer;
  return (value) {
    if (debounceTimer?.isActive ?? false) debounceTimer?.cancel();
    debounceTimer = Timer(Duration(milliseconds: milliseconds), () {
      callback(value);
    });
  };
}

//带参数的函数节流，由于参数不固定就没有用过扩展，直接用方法包裹
void Function(T value) throttle<T>(void Function(T value) callback,
    [int milliseconds = 250]) {
  bool isAllowed = true;
  Timer? throttleTimer;
  return (value) {
    if (!isAllowed) return;
    isAllowed = false;
    callback(value);
    throttleTimer?.cancel();
    throttleTimer = Timer(Duration(milliseconds: milliseconds), () {
      isAllowed = true;
    });
  };
}
