import 'package:dio/dio.dart';

/// HANYA UNTUK DEMO FRONTEND TANPA BACKEND.
/// Data disimpan di memori dan hilang saat aplikasi dimatikan.
class MockApiInterceptor extends Interceptor {
  static final List<Map<String, dynamic>> _users = [
    _newUser(1, 'Pengguna Demo', 'demo', 'demo@cyclefy.com', 'rahasia123'),
  ];

  static Map<String, dynamic> _newUser(
    int id,
    String? fullname,
    String username,
    String email,
    String password,
  ) =>
      {
        'id': id,
        'fullname': fullname,
        'username': username,
        'email': email,
        'password': password,
        'isEmailVerified': false,
        'profilePicture': null,
        'isActive': true,
        'profile': <String, dynamic>{
          'phoneNumber': null,
          'address': null,
          'city': null,
          'state': null,
          'country': null,
          'zipcode': null,
        },
      };

  static Map<String, dynamic> _public(Map<String, dynamic> u) =>
      Map<String, dynamic>.from(u)..remove('password');

  static String? _clean(dynamic v) {
    final s = (v as String?)?.trim();
    return (s == null || s.isEmpty) ? null : s;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final method = options.method.toUpperCase();
    final path = options.path;
    final body = options.data is Map
        ? Map<String, dynamic>.from(options.data as Map)
        : <String, dynamic>{};

    if (method == 'POST' && path == '/auth/login') {
      return _login(options, handler, body);
    }
    if (method == 'POST' && path == '/auth/register') {
      return _register(options, handler, body);
    }
    if (path == '/users/me') {
      final user = _userFromToken(options);
      if (user == null) {
        return _fail(options, handler, 401, 'Token tidak valid');
      }
      if (method == 'GET') {
        return _ok(options, handler, {'user': _public(user)});
      }
      if (method == 'PUT') {
        return _updateMe(options, handler, user, body);
      }
    }
    _fail(options, handler, 404, 'Endpoint mock tidak ditemukan');
  }

  void _login(RequestOptions o, RequestInterceptorHandler h, Map<String, dynamic> body) {
    final id = ((body['identifier'] as String?) ?? '').trim().toLowerCase();
    final password = (body['password'] as String?) ?? '';
    final user = _users
        .where((u) =>
            u['username'].toString().toLowerCase() == id ||
            u['email'].toString().toLowerCase() == id)
        .firstOrNull;
    if (user == null || user['password'] != password) {
      return _fail(o, h, 401, 'Email/username atau password salah');
    }
    _ok(o, h, {'token': 'mock-token-${user['id']}', 'user': _public(user)});
  }

  void _register(RequestOptions o, RequestInterceptorHandler h, Map<String, dynamic> body) {
    final email = ((body['email'] as String?) ?? '').trim().toLowerCase();
    final username = ((body['username'] as String?) ?? '').trim();
    if (_users.any((u) => u['email'].toString().toLowerCase() == email)) {
      return _fail(o, h, 409, 'Email sudah terdaftar');
    }
    if (_users.any((u) => u['username'].toString().toLowerCase() == username.toLowerCase())) {
      return _fail(o, h, 409, 'Username sudah digunakan');
    }
    final user = _newUser(
      _users.length + 1,
      _clean(body['fullname']),
      username,
      email,
      (body['password'] as String?) ?? '',
    );
    _users.add(user);
    _ok(o, h, {'user': _public(user)}, status: 201);
  }

  void _updateMe(
    RequestOptions o,
    RequestInterceptorHandler h,
    Map<String, dynamic> user,
    Map<String, dynamic> body,
  ) {
    final newUsername = (body['username'] as String?)?.trim();
    if (newUsername != null &&
        _users.any((u) =>
            u['id'] != user['id'] &&
            u['username'].toString().toLowerCase() == newUsername.toLowerCase())) {
      return _fail(o, h, 409, 'Username sudah digunakan');
    }
    if (body.containsKey('fullname')) user['fullname'] = _clean(body['fullname']);
    if (newUsername != null && newUsername.isNotEmpty) user['username'] = newUsername;
    final profile = user['profile'] as Map<String, dynamic>;
    for (final key in ['phoneNumber', 'address', 'city', 'state', 'country', 'zipcode']) {
      if (body.containsKey(key)) profile[key] = _clean(body[key]);
    }
    _ok(o, h, {'user': _public(user)});
  }

  Map<String, dynamic>? _userFromToken(RequestOptions options) {
    final header = options.headers['Authorization'] as String?;
    if (header == null) return null;
    final id = int.tryParse(header.replaceFirst('Bearer mock-token-', ''));
    return _users.where((u) => u['id'] == id).firstOrNull;
  }

  void _ok(RequestOptions o, RequestInterceptorHandler h, Map<String, dynamic> data,
      {int status = 200}) {
    h.resolve(Response(
      requestOptions: o,
      statusCode: status,
      data: {'success': true, 'message': 'Berhasil', 'data': data},
    ));
  }

  void _fail(RequestOptions o, RequestInterceptorHandler h, int status, String message) {
    h.reject(DioException(
      requestOptions: o,
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: o,
        statusCode: status,
        data: {'success': false, 'message': message},
      ),
    ));
  }
}