import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'api_exception.dart';
import 'app_config.dart';
import 'mock_api.dart';
import 'token_storage.dart';

/// Klien HTTP tunggal untuk seluruh pemanggilan REST API Cyclefy.
class ApiClient {
  ApiClient({required TokenStorage tokenStorage, this.onUnauthorized})
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Accept': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra['auth'] != false) {
            final token = await tokenStorage.read();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
        onError: (error, handler) {
          final isAuthCall = error.requestOptions.extra['auth'] == false;
          if (error.response?.statusCode == 401 && !isAuthCall) {
            onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );

    // Mode demo: API palsu tanpa backend. Aktif jika .env berisi USE_MOCK_API=true.
    // Dipasang SETELAH interceptor di atas agar header Authorization sudah terisi.
    if (dotenv.maybeGet('USE_MOCK_API') == 'true') {
      _dio.interceptors.add(MockApiInterceptor());
    }
  }

  final Dio _dio;

  /// Dipanggil saat token ditolak server (kedaluwarsa/invalid).
  void Function()? onUnauthorized;

  /// Mengirim request dan mengembalikan isi field `data` dari response.
  /// [auth] = false untuk endpoint publik (login/register).
  Future<Map<String, dynamic>> send(
    String method,
    String path, {
    Object? data,
    bool auth = true,
  }) async {
    try {
      final response = await _dio.request<Map<String, dynamic>>(
        path,
        data: data,
        options: Options(method: method, extra: {'auth': auth}),
      );
      return (response.data?['data'] as Map<String, dynamic>?) ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}