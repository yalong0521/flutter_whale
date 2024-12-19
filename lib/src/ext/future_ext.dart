import 'package:flutter_whale/flutter_whale.dart';

extension FutureExt<T> on Future<T> {
  /// 加载异步任务并进行弹窗loading
  Future<T> loading({String? text}) async {
    DialogUtil.showLoading(text: text);
    var result = await this;
    DialogUtil.hideLoading();
    return result;
  }
}

extension Unwrap<T> on Future<T?> {
  Future<T> unwrap() => then(
        (value) => value != null ? Future<T>.value(value) : Future.any([]),
      );
}
