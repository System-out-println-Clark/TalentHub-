import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talenthub/core/theme/app_colors.dart';
import 'package:talenthub/core/theme/app_text_styles.dart';
import 'package:talenthub/core/router/route_names.dart';
import 'providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = ref.read(authNotifierProvider);

    await ref.read(authNotifierProvider.notifier).signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      displayName: _nameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text(
                  'Join the Family',
                  style: AppTextStyles.displayLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start your journey toward the world\'s biggest stages.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _nameController,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'e.g. Julianne Moore',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Name is required';
                    if (value.length < 2) return 'Name too short';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'email@example.com',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email is required';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: '••••••••',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    if (value.length < 6) return 'Password too short';
                    return null;
                  },
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: authAsync.isLoading
                      ? null
                      : _handleSignup,
                    child: authAsync.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text('Create Account'),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: AppTextStyles.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.go(RouteNames.login),
                        child: Text(
                          'Sign In',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
