import 'dart:convert';

import 'package:flutter_whale/flutter_whale.dart';

/// Log 拦截器
class LogsInterceptor extends Interceptor {
  final bool printRequest;
  final bool printResponse;

  LogsInterceptor({this.printRequest = true, this.printResponse = true});

  final Map<RequestOptions, List<String>> _logs = {};

  @override
  onRequest(RequestOptions options, handler) async {
    List<String> logList = [];
    if (printRequest) {
      logList.add('* HttpRequestBegin ${'*' * 30}');
      logList.add('请求地址: ${options.uri.toString()} (${options.method})');
      for (final value in options.headers.entries) {
        if (value.value == null) options.headers[value.key] = '';
      }
      logList.add('请求头: ${jsonEncode(options.headers)}');
      if (options.data != null) {
        if (options.data is FormData) {
          final formData = options.data as FormData;
          logList.add('请求体(FormData@fields): ${formData.fields.toString()}');
          final map =
              formData.files.map((e) => MapEntry(e.key, e.value.filename));
          logList.add('请求体(FormData@files): ${map.toString()}');
        } else if (options.data is Map<String, dynamic>) {
          logList.add('请求体(json): ${jsonEncode(options.data)}');
        } else {
          logList.add('请求体: ${options.data}');
        }
      }
    }
    _logs[options] = logList;
    return super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, handler) async {
    final options = response.requestOptions;
    List<String>? logList = _logs[options];
    if (printResponse) {
      final responseType = response.requestOptions.responseType;
      switch (responseType) {
        case ResponseType.json:
          logList?.add('返回数据(json): ${jsonEncode(response.data)}');
          break;
        case ResponseType.stream:
          logList?.add('返回数据(stream): (${response.data.runtimeType})');
          break;
        case ResponseType.plain:
          logList?.add('返回数据(plain): ${response.data}');
          break;
        case ResponseType.bytes:
          logList?.add('返回数据(bytes): ${response.data}');
          break;
      }
      logList?.add('${'*' * 30}  HttpRequestEnd  ${'*' * 30}');
    }
    if (logList.notNullAndNotEmpty) {
      logger.log(logList, path: kHttpClientLogPath);
    }
    _logs.remove(options);
    return super.onResponse(response, handler);
  }

  @override
  onError(err, handler) async {
    final options = err.requestOptions;
    List<String>? logList = _logs[options];
    logList?.add('请求异常: ${_errorToString(err)}');
    logList?.add('${'*' * 30}  HttpRequestEnd  ${'*' * 30}');
    // 取消请求导致的异常不进日志
    if (err.type != DioExceptionType.cancel) {
      logger.logE(logList, path: kHttpClientLogPath);
    }
    _logs.remove(options);
    return super.onError(err, handler);
  }

  String _errorToString(DioException err) {
    Map<String, dynamic> json = {};
    json['ExceptionType'] = err.type.toString();
    final message = err.message;
    if (message != null) json['ExceptionMessage'] = message.toString();
    final error = err.error;
    if (error != null) json['ExceptionError'] = error.toString();
    final response = err.response;
    if (response != null) json['ExceptionResponse'] = response.toString();
    return jsonEncode(json);
  }
}
