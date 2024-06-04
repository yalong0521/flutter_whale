import 'dart:convert';

import 'package:flutter_whale/flutter_whale.dart';

/// Log 拦截器
class LogsInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options, handler) async {
    LogUtil.log('请求地址: ${options.uri.toString()} (${options.method})');
    for (var value in options.headers.entries) {
      if (value.value == null) options.headers[value.key] = '';
    }
    LogUtil.log('请求头: ${jsonEncode(options.headers)}');
    if (options.data != null) {
      if (options.data is FormData) {
        final formData = options.data as FormData;
        LogUtil.log('请求体(FormData@fields): ${formData.fields.toString()}');
        mapper(e) => MapEntry(e.key, e.value.filename);
        var map = formData.files.map(mapper);
        LogUtil.log('请求体(FormData@files): ${map.toString()}');
      } else {
        LogUtil.log('请求体: ${jsonEncode(options.data)}');
      }
    }
    return super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, handler) async {
    var responseType = response.requestOptions.responseType;
    if (responseType == ResponseType.json) {
      LogUtil.log('返回数据: ${jsonEncode(response.data)}');
    } else if (responseType == ResponseType.plain) {
      LogUtil.log('返回数据: ${response.data}');
    } else {
      LogUtil.log('返回数据: 暂不支持打印(${response.data.runtimeType})');
    }
    return super.onResponse(response, handler);
  }

  @override
  onError(err, handler) async {
    LogUtil.log('请求异常: DioError [${err.type}] Response [${err.response}]');
    return super.onError(err, handler);
  }
}
