import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talenthub/core/error/auth_failure.dart';
import 'package:talenthub/features/auth/domain/entities/user_entity.dart';

part 'auth_repository.g.dart';

abstract interface class IAuthRepository {
  Stream<UserEntity?> get authState;
  Future<void> signUp({required String email, required String password});
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
}

@riverpod
IAuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl();
}

class AuthRepositoryImpl implements IAuthRepository {
  final _auth = FirebaseAuth.instance;

  @override
  Stream<UserEntity?> get authState {
    // Use .asBroadcastStream() to allow multiple listeners (crucial for Riverpod and Tests)
    return _auth.authStateChanges()
        .map((firebaseUser) => firebaseUser == null ? null : UserEntity.fromFirebaseUser(firebaseUser))
        .asBroadcastStream();
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    } catch (_) {
      throw const UnknownAuthFailure();
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    } catch (_) {
      throw const UnknownAuthFailure();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {
      throw const UnknownAuthFailure();
    }
  }

  AuthFailure _mapFirebaseError(FirebaseAuthException e) {
    return switch (e.code) {
      'email-already-in-use' => const UserAlreadyExistsFailure(),
      'invalid-email' => const InvalidCredentialsFailure('Invalid email format'),
      'user-not-found' || 'wrong-password' || 'invalid-credential' => const InvalidCredentialsFailure(),
      'network-request-failed' => const NetworkFailure(),
      _ => UnknownAuthFailure('Firebase Error: ${e.code}'),
    };
  }
}
