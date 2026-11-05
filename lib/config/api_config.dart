import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  /// Ganti lewat: flutter run --dart-define=API_URL=http://192.168.1.5:3000
  /// Default: Chrome -> localhost, Android Emulator -> 10.0.2.2
  static const String _override = String.fromEnvironment('API_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    return kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
  }

  /// JWT dari login (diisi oleh fitur Autentikasi / Orang 1 setelah login).
  /// Kalau null, header Authorization tidak dikirim.
  static String? authToken;
}
