import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/auth_repository_impl.dart';
import '../../domain/auth_repository.dart';
import '../../domain/app_user.dart';

// Provider for the AuthRepository implementation
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

// Provider that watches the current authenticated user
final appUserProvider = StreamProvider<AppUser?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.watchUser();
});

// Notifier to handle auth actions (Login, Signup, Logout)
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signIn(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
    });
  }
}
