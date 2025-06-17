import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sblog/core/constant/api_endpoints.dart';
import 'package:sblog/core/util/local_data.dart';
import 'package:sblog/service_locator.dart';

class ApiHelper {
  static late Dio _dio;
  static final localData = sl<LocalData>();

  /// Khởi tạo Dio với token từ LocalData
  static Future<void> init() async {
  String? token = localData.getAccessToken();
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    ));
  }

  static void addInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = localData.getAccessToken();

        // Nếu có token và request không phải loại bỏ token thì thêm header Authorization
        if (token != null) {
          // Ví dụ nếu bạn muốn skip token cho đường dẫn /public, /auth thì check ở đây
          if (!options.path.contains('/public') &&
              !options.path.contains('/auth')) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        log("📤 Request: ${options.method} ${options.uri}");
        log("📨 Headers: ${options.headers}");
        log("📩 Data: ${options.data}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        log("✅ Response: ${response.statusCode}");
        log("📥 Data: ${response.data}");
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        log("❌ Error: ${e.message}");
        if (e.response != null) {
          log("⚠️ Response Data: ${e.response?.data}");
        }
        return handler.next(e);
      },
    ));
  }

  /// 🟦 GET request
  static Future<Response> get(String path,
      {Map<String, dynamic>? params, Map<String, String>? headers}) async {
    final uri = Uri.parse(ApiEndpoints.baseUrl).replace(
      path: path.startsWith('/') ? path : '/$path',
      queryParameters: params?.map((k, v) => MapEntry(k, v?.toString() ?? '')),
    );
    log("[FULL URL] GET: $uri");
    return await _dio.get(
      path,
      queryParameters: params,
      options: Options(headers: headers),
    );
  }

  /// 🟩 POST request
  static Future<Response> post(String path, dynamic data,
      {Map<String, String>? headers}) async {
    final uri = Uri.parse(ApiEndpoints.baseUrl).replace(
      path: path.startsWith('/') ? path : '/$path',
    );
    log("[FULL URL] POST: $uri");
    // Nếu là upload file, loại bỏ Content-Type application/json
    Map<String, String>? customHeaders = headers;
    if (data is FormData) {
      customHeaders = {...?headers};
      customHeaders.remove('Content-Type');
    }
    return await _dio.post(
      path,
      data: data,
      options: Options(headers: customHeaders),
    );
  }

  /// 🟧 PUT request
  static Future<Response> put(String path, dynamic data,
      {Map<String, String>? headers}) async {
    final uri = Uri.parse(ApiEndpoints.baseUrl).replace(
      path: path.startsWith('/') ? path : '/$path',
    );
    log("[FULL URL] PUT: $uri");
    return await _dio.put(
      path,
      data: data,
      options: Options(headers: headers),
    );
  }

  /// 🟦 PATCH request
  static Future<Response> patch(String path, dynamic data,
      {Map<String, String>? headers}) async {
    final uri = Uri.parse(ApiEndpoints.baseUrl).replace(
      path: path.startsWith('/') ? path : '/$path',
    );
    log("[FULL URL] PATCH: $uri");
    return await _dio.patch(
      path,
      data: data,
      options: Options(headers: headers),
    );
  }

  /// 🟥 DELETE request
  static Future<Response> delete(String path,
      {Map<String, dynamic>? params, Map<String, String>? headers}) async {
    final uri = Uri.parse(ApiEndpoints.baseUrl).replace(
      path: path.startsWith('/') ? path : '/$path',
      queryParameters: params?.map((k, v) => MapEntry(k, v?.toString() ?? '')),
    );
    log("[FULL URL] DELETE: $uri");
    return await _dio.delete(
      path,
      queryParameters: params,
      options: Options(headers: headers),
    );
  }
}
