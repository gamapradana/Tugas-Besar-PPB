import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/recycling_locator/pages/recycling_locator_page.dart';
import '../features/receiver_management/pages/receiver_list_page.dart';
import '../features/notifications/pages/notification_page.dart';

import '../data/auth_controller.dart';
import 'auth/login_page.dart';
import 'auth/register_page.dart';
import 'home/home_page.dart';
import 'main_navigation.dart';
import 'barter_borrowing_shell.dart';
import 'main_shell.dart';
import 'profile/edit_profile_page.dart';
import 'profile/profile_page.dart';
import 'splash/splash_page.dart';

/// Memberi tahu GoRouter agar mengevaluasi ulang redirect saat status login berubah.
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Ref ref) {
    ref.listen<AuthState>(authControllerProvider, (_, _) => notifyListeners());
  }
}

const _publicRoutes = {'/login', '/register'};

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    // Proteksi halaman berdasarkan status autentikasi.
    redirect: (context, state) {
      final status = ref.read(authControllerProvider).status;
      final location = state.matchedLocation;

      return switch (status) {
        // Status belum diketahui: tahan di Splash.
        AuthStatus.unknown => location == '/splash' ? null : '/splash',
        // Sudah login: tidak boleh ke Splash/Login/Register.
        AuthStatus.authenticated =>
          (location == '/splash' || _publicRoutes.contains(location))
              ? '/home'
              : null,
        // Belum login / sudah logout: hanya boleh Login dan Register.
        AuthStatus.unauthenticated =>
          _publicRoutes.contains(location) ? null : '/login',
      };
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
      GoRoute(
        path: '/recycling-locator',
        builder: (_, _) => const RecyclingLocatorPage(),
      ),
      GoRoute(
        path: '/receiver-management',
        builder: (_, _) => const ReceiverListPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, _) => const NotificationPage(),
      ),
      // Modul dengan navigasi internal diletakkan di luar StatefulShellRoute
      // agar navbar global Beranda/Profil tidak tampil bertumpuk.
      GoRoute(
        path: '/barter',
        builder: (_, _) => const BarterBorrowingShell(),
      ),
      GoRoute(
        path: '/items',
        builder: (_, _) => const MainNavigation(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, _) => const HomePage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, _) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      // Di luar shell agar bottom navigation tersembunyi saat mengedit.
      GoRoute(
        path: '/edit-profile',
        builder: (_, _) => const EditProfilePage(),
      ),
    ],
  );
});
