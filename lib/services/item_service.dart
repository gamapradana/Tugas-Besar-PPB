import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../config/api_config.dart';
import '../models/cyclefy_item.dart';
import '../models/item_form_data.dart';

class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ItemService {
  Map<String, String> get _headers => {
    'Accept': 'application/json',
    if (ApiConfig.authToken != null)
      'Authorization': 'Bearer ${ApiConfig.authToken}',
  };

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}/api$path');

  /// Jalankan request, ubah semua error jadi ApiException berpesan jelas.
  Future<http.Response> _guard(Future<http.Response> Function() request) async {
    try {
      final res = await request().timeout(const Duration(seconds: 20));
      if (res.statusCode >= 400) {
        var message = 'Terjadi kesalahan (${res.statusCode})';
        try {
          final body = jsonDecode(res.body) as Map<String, dynamic>;
          message = body['message'] as String? ?? message;
        } catch (_) {}
        throw ApiException(message);
      }
      return res;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException('Server tidak merespons. Coba lagi.');
    } catch (_) {
      throw ApiException('Tidak dapat terhubung ke server.');
    }
  }

  Future<http.Response> _multipart(
    String method,
    String path,
    ItemFormData data,
  ) async {
    final request = http.MultipartRequest(method, _uri(path))
      ..headers.addAll(_headers)
      ..fields.addAll(data.toFields());

    final image = data.image;
    if (image != null) {
      final bytes = await image.readAsBytes(); // aman di Web & mobile
      request.files.add(
        http.MultipartFile.fromBytes(
          'images',
          bytes,
          filename: image.name,
          contentType: MediaType.parse(image.mimeType ?? 'image/jpeg'),
        ),
      );
    }
    return http.Response.fromStream(await request.send());
  }

  CyclefyItem _parseItem(http.Response res) {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return CyclefyItem.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<List<CyclefyItem>> fetchItems() async {
    final res = await _guard(() => http.get(_uri('/items'), headers: _headers));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return (body['data'] as List)
        .map((e) => CyclefyItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CyclefyItem> create(ItemFormData data) async {
    final path = data.isDonation ? '/donations' : '/items';
    return _parseItem(await _guard(() => _multipart('POST', path, data)));
  }

  Future<CyclefyItem> update(int id, ItemFormData data) async {
    return _parseItem(await _guard(() => _multipart('PUT', '/items/$id', data)));
  }

  Future<void> delete(int id) async {
    await _guard(() => http.delete(_uri('/items/$id'), headers: _headers));
  }
}
