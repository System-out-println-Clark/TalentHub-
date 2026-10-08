import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TalentHubApp(),
    ),
  );
}

class TalentHubApp extends ConsumerWidget {
  const TalentHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize the AppRouter.ref so the router can access Riverpod providers
    // for its redirect logic.
    AppRouter.ref = ref;

    return MaterialApp.router(
      title: 'TalentHub+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
