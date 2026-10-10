import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talenthub/features/auth/domain/entities/user_entity.dart';
import 'package:talenthub/features/auth/domain/repositories/auth_repository.dart';
import 'package:talenthub/features/auth/presentation/providers/auth_provider.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  group('AuthProvider Tests', () {
    late ProviderContainer container;
    late MockAuthRepository mockRepo;
    late StreamController<UserEntity?> authStateController;

    setUp(() {
      mockRepo = MockAuthRepository();
      authStateController = StreamController<UserEntity?>.broadcast();

      when(() => mockRepo.authState).thenAnswer((_) => authStateController.stream);

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      authStateController.close();
    });

    test('starts with initial state', () {
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.initial);
    });

    test('updates to authenticated state when user is emitted', () async {
      final user = UserEntity(id: '123', email: 'test@example.com');

      // Trigger the build() method and subscription
      container.read(authProvider);

      // Ensure the build method has completed and subscription is active
      await Future.microtask(() {});

      authStateController.add(user);

      // Use a more robust delay to allow the Riverpod state update to propagate
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user, user);
    });

    test('updates to unauthenticated state when null is emitted', () async {
      final user = UserEntity(id: '123', email: 'test@example.com');

      container.read(authProvider);
      await Future.microtask(() {});

      authStateController.add(user);
      await Future.delayed(const Duration(milliseconds: 50));

      authStateController.add(null);
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, null);
    });

    test('setLoading and setError update state correctly', () {
      final notifier = container.read(authProvider.notifier);

      notifier.setLoading();
      expect(container.read(authProvider).status, AuthStatus.loading);

      notifier.setError('Invalid credentials');
      expect(container.read(authProvider).status, AuthStatus.unauthenticated);
      expect(container.read(authProvider).errorMessage, 'Invalid credentials');
    });
  });
}
