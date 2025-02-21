import 'dart:io';

import 'package:dio/io.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_whale/flutter_whale.dart';

sealed class BaseResponse<T> {
  bool get isSuccess => this is SuccessResponse;
}

class SuccessResponse<T> extends BaseResponse<T> {
  /// 可能有值(有些业务场景没有数据是正常的)
  final T? data;

  SuccessResponse([this.data]);
}

class ErrorResponse<T> extends BaseResponse<T> {
  /// 错误码
  final String? errorCode;

  /// 错误信息
  final String? errorMsg;

  ErrorResponse({this.errorCode, String? errorMsg})
      : errorMsg = errorMsg.notNullAndNotEmpty ? errorMsg : null;
}

abstract class BaseClient {
  late Dio _dio;

  BaseClient() {
    // 初始化dio
    _dio = Dio(BaseOptions(
      // 请求基地址,可以包含子路径
      baseUrl: baseUrl,
      // 连接服务器超时时间
      connectTimeout: const Duration(seconds: 30),
      // 响应流上前后两次接受到数据的间隔
      receiveTimeout: const Duration(seconds: 30),
      // 请求的Content-Type，默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
      contentType: contentType,
      // 表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    ));
    // 根据不同业务添加相应拦截器
    final interceptorList = interceptors;
    if (interceptorList != null) _dio.interceptors.addAll(interceptorList);
    // 配置适配器
    initAdapter();
  }

  void resetBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  void initAdapter() {
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.findProxy = proxy;
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );
  }

  /// 根据客户端类型返回不同BaseUrl
  String get baseUrl;

  String? get contentType => Headers.jsonContentType;

  /// 需要拦截数据进行处理就重写该方法
  List<Interceptor>? get interceptors => null;

  /// 配置代理
  String Function(Uri url)? get proxy => null;

  String getDioErrorDesc(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时';
      case DioExceptionType.connectionError:
        return '连接异常';
      case DioExceptionType.sendTimeout:
        return '请求超时';
      case DioExceptionType.receiveTimeout:
        return '响应超时';
      case DioExceptionType.badResponse:
        return '请求异常';
      case DioExceptionType.badCertificate:
        return '无效证书';
      case DioExceptionType.cancel:
        return '请求取消';
      case DioExceptionType.unknown:
        final error = exception.error;
        if (error is SocketException && error.osError?.errorCode == 65) {
          return '无法连接网络，请稍后重试';
        }
        return '网络异常';
    }
  }

  Future<BaseResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? parameters,
    T Function(dynamic data)? parser,
    bool original = false,
    Options? options,
    CancelToken? cancelToken,
    bool showLoading = true,
    dynamic extra,
    String? loadingText,
    BuildContext? context,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool removeNullValue = true,
  }) async {
    return _request(
      'GET',
      path,
      showLoading,
      original,
      parameters: parameters,
      parser: parser,
      options: options,
      cancelToken: cancelToken,
      extra: extra,
      loadingText: loadingText,
      context: context,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      removeNullValue: removeNullValue,
    );
  }

  Future<BaseResponse<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? parameters,
    T Function(dynamic data)? parser,
    bool original = false,
    Options? options,
    CancelToken? cancelToken,
    bool showLoading = true,
    dynamic extra,
    String? loadingText,
    BuildContext? context,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool removeNullValue = true,
  }) async {
    return _request(
      'POST',
      path,
      showLoading,
      original,
      data: data,
      parameters: parameters,
      parser: parser,
      options: options,
      cancelToken: cancelToken,
      extra: extra,
      loadingText: loadingText,
      context: context,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      removeNullValue: removeNullValue,
    );
  }

  Future<BaseResponse<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? parameters,
    T Function(dynamic data)? parser,
    bool original = false,
    Options? options,
    CancelToken? cancelToken,
    bool showLoading = true,
    dynamic extra,
    String? loadingText,
    BuildContext? context,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool removeNullValue = true,
  }) async {
    return _request(
      'PUT',
      path,
      showLoading,
      original,
      data: data,
      parameters: parameters,
      parser: parser,
      options: options,
      cancelToken: cancelToken,
      extra: extra,
      loadingText: loadingText,
      context: context,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      removeNullValue: removeNullValue,
    );
  }

  Future<BaseResponse<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? parameters,
    T Function(dynamic data)? parser,
    bool original = false,
    Options? options,
    CancelToken? cancelToken,
    bool showLoading = true,
    dynamic extra,
    String? loadingText,
    BuildContext? context,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool removeNullValue = true,
  }) async {
    return _request(
      'DELETE',
      path,
      data: data,
      parameters: parameters,
      showLoading,
      original,
      parser: parser,
      options: options,
      cancelToken: cancelToken,
      extra: extra,
      loadingText: loadingText,
      context: context,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      removeNullValue: removeNullValue,
    );
  }

  Future<BaseResponse<T>> _request<T>(
    String method,
    String path,
    bool showLoading,
    bool original, {
    data,
    Map<String, dynamic>? parameters,
    T Function(dynamic data)? parser,
    Options? options,
    CancelToken? cancelToken,
    dynamic extra,
    String? loadingText,
    BuildContext? context,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool removeNullValue = true,
  }) async {
    if (showLoading) {
      DialogUtil.showLoading(text: loadingText, context: context);
    }
    parser = parser ?? (validData) => validData;
    options ??= Options();
    options.method = method;
    if (removeNullValue) {
      if (data is Map) {
        data.removeWhere((key, value) => value == null);
      }
      if (parameters != null) {
        parameters.removeWhere((key, value) => value == null);
      }
    }
    var response = await _dio
        .request(
      path,
      data: data,
      queryParameters: parameters,
      cancelToken: cancelToken,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    )
        .then(
      (response) {
        if (showLoading) DialogUtil.hideLoading(context: context);
        return response;
      },
      onError: (e) {
        if (showLoading) DialogUtil.hideLoading(context: context);
        return _onError(e);
      },
    );
    if (response.statusCode == 200) {
      try {
        if (original) {
          // 不解析，返回原始数据
          return SuccessResponse(parser(response.data));
        }
        return responseWrapper(response.data, parser, extra);
      } catch (e) {
        logger.logE(e.toString(), path: kHttpClientLogPath);
        return ErrorResponse(errorMsg: '数据解析异常');
      }
    } else {
      return ErrorResponse(
        errorCode: response.statusCode?.toString(),
        errorMsg: response.statusMessage,
      );
    }
  }

  BaseResponse<T> responseWrapper<T>(
      data, T Function(dynamic data) parser, dynamic extra);

  Response _onError(dynamic error) {
    if (error is DioException) {
      return Response(
        requestOptions: error.requestOptions,
        statusMessage: getDioErrorDesc(error),
      );
    }
    return Response(requestOptions: RequestOptions(), statusMessage: 'unknown');
  }
}
