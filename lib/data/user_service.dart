import '../models/user_model.dart';
import 'api_client.dart';

/// Pemanggilan API profil: GET dan PUT /users/me (butuh token).
class UserService {
  UserService(this._api);

  final ApiClient _api;

  Future<UserModel> getMe() async {
    final data = await _api.send('GET', '/users/me');
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<UserModel> updateMe(Map<String, dynamic> body) async {
    final data = await _api.send('PUT', '/users/me', data: body);
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }
}
