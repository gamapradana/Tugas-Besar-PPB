import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Menyimpan token JWT di penyimpanan aman (Keystore Android / Keychain iOS).
///
/// persist = false (tidak mencentang "Ingat saya"): token hanya di memori,
/// sehingga hilang saat aplikasi ditutup.
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _key = 'auth_token';

  final FlutterSecureStorage _storage;
  String? _memory;

  Future<void> save(String token, {required bool persist}) async {
    _memory = token;
    if (persist) {
      await _storage.write(key: _key, value: token);
    } else {
      await _storage.delete(key: _key);
    }
  }

  Future<String?> read() async {
    _memory ??= await _storage.read(key: _key);
    return _memory;
  }

  Future<void> clear() async {
    _memory = null;
    await _storage.delete(key: _key);
  }
}
