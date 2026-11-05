import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import 'api_client.dart';
import 'api_exception.dart';
import 'auth_service.dart';
import 'token_storage.dart';
import 'user_service.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    tokenStorage: ref.watch(tokenStorageProvider),
    // Token ditolak server -> paksa keluar. read() dipanggil lazy (aman).
    onUnauthorized: () => ref.read(authControllerProvider.notifier).forceLogout(),
  );
});

final authServiceProvider =
    Provider<AuthService>((ref) => AuthService(ref.watch(apiClientProvider)));

final userServiceProvider =
    Provider<UserService>((ref) => UserService(ref.watch(apiClientProvider)));

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({this.status = AuthStatus.unknown, this.user});

  final AuthStatus status;
  final UserModel? user;
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

/// Pusat status autentikasi: dipakai router (proteksi halaman) dan UI.
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  /// Dipanggil Splash: cek token tersimpan, validasi ke server.
  Future<void> checkSession() async {
    final minSplash = Future<void>.delayed(const Duration(milliseconds: 1500));
    UserModel? user;
    try {
      final token = await ref.read(tokenStorageProvider).read();
      if (token != null) {
        user = await ref.read(userServiceProvider).getMe();
      }
    } on ApiException catch (e) {
      if (e.isUnauthorized) await ref.read(tokenStorageProvider).clear();
    } catch (_) {
      // Kegagalan lain (mis. plugin/penyimpanan): anggap belum login.
    }
    await minSplash;
    state = user == null
        ? const AuthState(status: AuthStatus.unauthenticated)
        : AuthState(status: AuthStatus.authenticated, user: user);
  }

  /// Melempar [ApiException] jika gagal (ditangani halaman Login).
  Future<void> login({
    required String identifier,
    required String password,
    required bool rememberMe,
  }) async {
    final result = await ref
        .read(authServiceProvider)
        .login(identifier: identifier, password: password);
    await ref.read(tokenStorageProvider).save(result.token, persist: rememberMe);
    state = AuthState(status: AuthStatus.authenticated, user: result.user);
  }

  /// Registrasi tidak langsung login; pengguna diarahkan ke halaman Login.
  Future<void> register({
    String? fullname,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    await ref.read(authServiceProvider).register(
          fullname: fullname,
          username: username,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
        );
  }

  Future<void> refreshProfile() async {
    final user = await ref.read(userServiceProvider).getMe();
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  Future<void> updateProfile(Map<String, dynamic> body) async {
    final user = await ref.read(userServiceProvider).updateMe(body);
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  Future<void> logout() async {
    await ref.read(tokenStorageProvider).clear();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Dipanggil otomatis saat server menolak token.
  Future<void> forceLogout() async {
    if (state.status == AuthStatus.authenticated) await logout();
  }
}
