import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:must_invest_service_man/app.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/api/end_points.dart';
import 'package:must_invest_service_man/core/api/response/response.dart';
import 'package:must_invest_service_man/core/errors/app_error.dart';
import 'package:must_invest_service_man/core/errors/exceptions.dart';
import 'package:must_invest_service_man/core/errors/handle_error_response.dart';
import 'package:must_invest_service_man/core/preferences/shared_pref.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

enum RequestMethod { get, post, put, delete, patch }

enum ContentType {
  json,
  formData;

  String get value {
    switch (this) {
      case ContentType.json:
        return 'application/json';
      case ContentType.formData:
        return 'application/x-www-form-urlencoded';
    }
  }
}

class DioClient {
  final MustInvestServiceManPreferences _preferences;
  final Dio _dio;

  DioClient(this._preferences) : _dio = Dio(BaseOptions(baseUrl: EndPoints.baseUrl)) {
    _dio.interceptors.add(
      PrettyDioLogger(
        error: true,
        request: true,
        logPrint: (message) {
          log(message.toString());
        },
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
        maxWidth: 90,
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          if (response.statusCode == 401 || response.statusCode == 403) {
            _handleUnauthorized();
          }
          handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            _handleUnauthorized();
          }
          handler.next(e);
        },
      ),
    );
  }

  void _handleUnauthorized() {
    appRouter.router.go(Routes.login);
  }

  Dio get dio => _dio;

  // function that cancel all pending requests
  void cancelRequests() {
    _dio.close();
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ContentType contentType = ContentType.json,
  }) async {
    // Create options with proper content type for data
    Options requestOptions = Options(contentType: contentType.value);

    // Merge with provided options if any
    if (options != null) {
      requestOptions = requestOptions.copyWith(
        method: options.method,
        sendTimeout: options.sendTimeout,
        receiveTimeout: options.receiveTimeout,
        extra: options.extra,
        headers: options.headers,
        responseType: options.responseType,
        validateStatus: options.validateStatus,
        receiveDataWhenStatusError: options.receiveDataWhenStatusError,
        followRedirects: options.followRedirects,
        maxRedirects: options.maxRedirects,
        requestEncoder: options.requestEncoder,
        responseDecoder: options.responseDecoder,
        listFormat: options.listFormat,
      );
    }

    // Convert data to FormData if contentType is formData
    Object? requestData = data;
    if (contentType == ContentType.formData && data != null) {
      if (data is Map<String, dynamic>) {
        requestData = FormData.fromMap(data);
      }
    }

    return _sendRequest(
      () => _dio.get(
        path,
        data: requestData,
        queryParameters: queryParameters,
        options: requestOptions,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ContentType contentType = ContentType.json,
  }) async {
    // Create options with proper content type
    Options requestOptions = Options(contentType: contentType.value);

    // Merge with provided options if any
    if (options != null) {
      requestOptions = requestOptions.copyWith(
        method: options.method,
        sendTimeout: options.sendTimeout,
        receiveTimeout: options.receiveTimeout,
        extra: options.extra,
        headers: options.headers,
        responseType: options.responseType,
        validateStatus: options.validateStatus,
        receiveDataWhenStatusError: options.receiveDataWhenStatusError,
        followRedirects: options.followRedirects,
        maxRedirects: options.maxRedirects,
        requestEncoder: options.requestEncoder,
        responseDecoder: options.responseDecoder,
        listFormat: options.listFormat,
      );
    }

    // Convert data to FormData if contentType is formData
    Object? requestData = data;
    if (contentType == ContentType.formData && data != null) {
      if (data is Map<String, dynamic>) {
        requestData = FormData.fromMap(data);
      }
    }

    return _sendRequest(
      () => _dio.post(path, data: requestData, queryParameters: queryParameters, options: requestOptions),
    );
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ContentType contentType = ContentType.json,
  }) async {
    // Create options with proper content type
    Options requestOptions = Options(contentType: contentType.value);

    // Merge with provided options if any
    if (options != null) {
      requestOptions = requestOptions.copyWith(
        method: options.method,
        sendTimeout: options.sendTimeout,
        receiveTimeout: options.receiveTimeout,
        extra: options.extra,
        headers: options.headers,
        responseType: options.responseType,
        validateStatus: options.validateStatus,
        receiveDataWhenStatusError: options.receiveDataWhenStatusError,
        followRedirects: options.followRedirects,
        maxRedirects: options.maxRedirects,
        requestEncoder: options.requestEncoder,
        responseDecoder: options.responseDecoder,
        listFormat: options.listFormat,
      );
    }

    // Convert data to FormData if contentType is formData
    Object? requestData = data;
    if (contentType == ContentType.formData && data != null) {
      if (data is Map<String, dynamic>) {
        requestData = FormData.fromMap(data);
      }
    }

    return _sendRequest(
      () => _dio.patch(path, data: requestData, queryParameters: queryParameters, options: requestOptions),
    );
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ContentType contentType = ContentType.json,
  }) async {
    // Create options with proper content type
    Options requestOptions = Options(contentType: contentType.value);

    // Merge with provided options if any
    if (options != null) {
      requestOptions = requestOptions.copyWith(
        method: options.method,
        sendTimeout: options.sendTimeout,
        receiveTimeout: options.receiveTimeout,
        extra: options.extra,
        headers: options.headers,
        responseType: options.responseType,
        validateStatus: options.validateStatus,
        receiveDataWhenStatusError: options.receiveDataWhenStatusError,
        followRedirects: options.followRedirects,
        maxRedirects: options.maxRedirects,
        requestEncoder: options.requestEncoder,
        responseDecoder: options.responseDecoder,
        listFormat: options.listFormat,
      );
    }

    // Convert data to FormData if contentType is formData
    Object? requestData = data;
    if (contentType == ContentType.formData && data != null) {
      if (data is Map<String, dynamic>) {
        requestData = FormData.fromMap(data);
      }
    }

    return _sendRequest(
      () => _dio.put(path, data: requestData, queryParameters: queryParameters, options: requestOptions),
    );
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ContentType contentType = ContentType.json,
  }) async {
    // Create options with proper content type
    Options requestOptions = Options(contentType: contentType.value);

    // Merge with provided options if any
    if (options != null) {
      requestOptions = requestOptions.copyWith(
        method: options.method,
        sendTimeout: options.sendTimeout,
        receiveTimeout: options.receiveTimeout,
        extra: options.extra,
        headers: options.headers,
        responseType: options.responseType,
        validateStatus: options.validateStatus,
        receiveDataWhenStatusError: options.receiveDataWhenStatusError,
        followRedirects: options.followRedirects,
        maxRedirects: options.maxRedirects,
        requestEncoder: options.requestEncoder,
        responseDecoder: options.responseDecoder,
        listFormat: options.listFormat,
      );
    }

    // Convert data to FormData if contentType is formData
    Object? requestData = data;
    if (contentType == ContentType.formData && data != null) {
      if (data is Map<String, dynamic>) {
        requestData = FormData.fromMap(data);
      }
    }

    return _sendRequest(
      () => _dio.delete(path, data: requestData, queryParameters: queryParameters, options: requestOptions),
    );
  }

  Future<ApiResponse<T>> request<T>(
    String endpoint, {
    Object? data,
    required T Function(Object? json) fromJson,
    Map<String, dynamic>? queryParams,
    required RequestMethod method,
    Options? options,
    void Function()? onSuccess,
    ContentType contentType = ContentType.json,
  }) async {
    Map<String, dynamic> response;

    switch (method) {
      case RequestMethod.get:
        response = await get(
          endpoint,
          data: data,
          queryParameters: queryParams,
          options: options,
          contentType: contentType,
        );
        break;
      case RequestMethod.post:
        response = await post(endpoint, data: data, options: options, contentType: contentType);
        break;
      case RequestMethod.put:
        response = await put(endpoint, data: data, options: options, contentType: contentType);
        break;
      case RequestMethod.delete:
        response = await delete(endpoint, data: data, options: options, contentType: contentType);
        break;
      case RequestMethod.patch:
        response = await patch(endpoint, data: data, options: options, contentType: contentType);
        break;
    }

    // Check if the response contains an error message
    if (response['status'] == false) {
      throw AppError(message: handleResponseErrors(response), type: ErrorType.api);
    }

    // Call onSuccess callback if provided
    onSuccess?.call();

    // Parse the response
    return ApiResponse.fromJson(response, (json) => fromJson(json));
  }

  Future<Map<String, dynamic>> _sendRequest(Future<Response> Function() request) async {
    late final Response response;

    // Update the localization header before every request
    _dio.options.headers["accept-lang"] = _preferences.getLang();
    _dio.options.headers["Accept"] = 'application/json';

    try {
      response = await request();
    } on DioException catch (e) {
      if (e.response != null) {
        response = e.response!;
      } else {
        log("$e");
        throw ServerException();
      }
    }
    return response.data ?? {};
  }
}
