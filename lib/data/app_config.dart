import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static const String _defaultBaseUrl = 'http://10.0.2.2:3000/api';

  static String get apiBaseUrl =>
      dotenv.maybeGet('API_BASE_URL') ?? _defaultBaseUrl;
}