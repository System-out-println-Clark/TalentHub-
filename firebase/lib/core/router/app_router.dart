import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_names.dart';
import 'package:talenthub/features/onboarding/providers/launch_provider.dart';
import 'package:talenthub/features/auth/presentation/login_screen.dart';
import 'package:talenthub/features/auth/presentation/signup_screen.dart';
import 'package:talenthub/features/onboarding/presentation/onboarding_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // We use the riverpod provider to decide the redirect
      final launchState = ref.read(launchNotifierProvider);

      // Since launchNotifierProvider is a FutureProvider, we handle the loading state
      return launchState.maybeWhen(
        data: (data) {
          final isAuthRoute = state.matchedLocation.startsWith('/auth');
          final isOnboardingRoute = state.matchedLocation == RouteNames.onboarding;

          if (data.status == LaunchStatus.onboarding && !isOnboardingRoute) {
            return RouteNames.onboarding;
          }
          if (data.status == LaunchStatus.auth && !isAuthRoute && !isOnboardingRoute) {
            return RouteNames.login;
          }
          if (data.status == LaunchStatus.home && (isAuthRoute || isOnboardingRoute)) {
            return RouteNames.home;
          }
          return null;
        },
        loading: () => null, // Stay on splash while loading
        error: (_, __) => RouteNames.login,
      );
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const Scaffold(
          backgroundColor: Color(0xFF0A0A0A),
          body: Center(child: Text('TALENTHUB+', style: TextStyle(color: Color(0xFFC9A44C), fontSize: 32, fontWeight: FontWeight.bold))),
        ),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const Scaffold(body: Center(child: Text('Home Feed'))),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const Scaffold(body: Center(child: Text('Profile'))),
      ),
      GoRoute(
        path: RouteNames.profileMe,
        builder: (context, state) => const Scaffold(body: Center(child: Text('My Profile'))),
      ),
      GoRoute(
        path: RouteNames.broadcast,
        builder: (context, state) => const Scaffold(body: Center(child: Text('Broadcast'))),
      ),
      GoRoute(
        path: RouteNames.audition,
        builder: (context, state) => const Scaffold(body: Center(child: Text('Audition'))),
      ),
      GoRoute(
        path: RouteNames.about,
        builder: (context, state) => const Scaffold(body: Center(child: Text('About'))),
      ),
    ],
  );

  // Helper to access ref inside the router
  static Ref ref = throw UnimplementedError('Ref must be initialized in main.dart');
}
