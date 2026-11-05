import '../models/user_model.dart';
import 'api_client.dart';

/// Pemanggilan API autentikasi: POST /auth/register dan POST /auth/login.
class AuthService {
  AuthService(this._api);

  final ApiClient _api;

  Future<UserModel> register({
    String? fullname,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final data = await _api.send(
      'POST',
      '/auth/register',
      auth: false,
      data: {
        if (fullname != null && fullname.isNotEmpty) 'fullname': fullname,
        'username': username,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<({String token, UserModel user})> login({
    required String identifier,
    required String password,
  }) async {
    final data = await _api.send(
      'POST',
      '/auth/login',
      auth: false,
      data: {'identifier': identifier, 'password': password},
    );
    return (
      token: data['token'] as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
    );
  }
}
