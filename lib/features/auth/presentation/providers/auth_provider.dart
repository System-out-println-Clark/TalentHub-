import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talenthub/core/error/auth_failure.dart';
import 'package:talenthub/features/auth/domain/entities/user_entity.dart';
import 'package:talenthub/features/auth/domain/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    final repo = ref.watch(authRepositoryProvider);

    // Use a stream listener to keep the state in sync with Firebase.
    final subscription = repo.authState.listen((user) {
      if (user != null) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
      }
    });

    ref.onDispose(() => subscription.cancel());

    return const AuthState();
  }

  void setLoading() {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
  }

  void setError(String message) {
    state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: message);
  }
}
