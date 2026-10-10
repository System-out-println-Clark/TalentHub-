import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'core/theme/app_theme.dart';
import 'design_showcase.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: TalentHubApp()));
}

class TalentHubApp extends ConsumerWidget {
  const TalentHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Placeholder Home')),
          ),
        ),
        if (kDebugMode)
          GoRoute(
            path: '/showcase',
            builder: (context, state) => const DesignShowcase(),
          ),
      ],
    );

    return MaterialApp.router(
      title: 'TalentHub+',
      theme: AppTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
