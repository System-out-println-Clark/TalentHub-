import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talenthub/features/auth/presentation/providers/auth_provider.dart';
import 'package:talenthub/features/auth/presentation/pages/login_page.dart';
import 'package:talenthub/features/auth/presentation/pages/signup_page.dart';
import 'package:talenthub/features/home/presentation/pages/home_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final status = authState.status;
      final isLoggedIn = status == AuthStatus.authenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSigningUp = state.matchedLocation == '/signup';

      if (!isLoggedIn) {
        return (isLoggingIn || isSigningUp) ? null : '/login';
      }

      if (isLoggingIn || isSigningUp) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
    ],
  );
});
