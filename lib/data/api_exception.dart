import 'package:dio/dio.dart';

/// Error dari API yang sudah berisi pesan siap tampil ke pengguna.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.fieldErrors = const {}});

  final String message;
  final int? statusCode;

  /// Pesan error per field dari validasi server, mis. {'email': '...'}.
  final Map<String, String> fieldErrors;

  bool get isUnauthorized => statusCode == 401;

  factory ApiException.fromDio(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      final fields = <String, String>{};
      final errors = data['errors'];
      if (errors is List) {
        for (final item in errors) {
          if (item is Map && item['field'] is String && item['message'] is String) {
            fields.putIfAbsent(item['field'] as String, () => item['message'] as String);
          }
        }
      }
      return ApiException(
        data['message'] as String,
        statusCode: e.response?.statusCode,
        fieldErrors: fields,
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Koneksi ke server terlalu lama. Coba lagi.');
      case DioExceptionType.connectionError:
        return ApiException(
          'Tidak dapat terhubung ke server. Periksa koneksi internet dan alamat API.',
        );
      default:
        return ApiException('Terjadi kesalahan. Coba lagi.',
            statusCode: e.response?.statusCode);
    }
  }

  @override
  String toString() => message;
}
