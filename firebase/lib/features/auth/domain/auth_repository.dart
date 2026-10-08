import 'package:firebase_auth/firebase_auth.dart';
import 'app_user.dart';

abstract interface class AuthRepository {
  /// Returns the current authenticated user's domain model.
  Stream<AppUser?> watchUser();

  /// Signs up a new user and initializes their Firestore profiles.
  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  /// Signs in an existing user.
  Future<void> signIn({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  Future<void> signOut();

  /// Sends a password reset email.
  Future<void> resetPassword(String email);
}
