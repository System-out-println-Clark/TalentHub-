import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LaunchStatus { loading, onboarding, auth, home }

class LaunchState {
  final LaunchStatus status;
  final bool isFirstInstall;
  final bool isSignedIn;

  LaunchState({
    required this.status,
    required this.isFirstInstall,
    required this.isSignedIn,
  });

  LaunchState copyWith({
    LaunchStatus? status,
    bool? isFirstInstall,
    bool? isSignedIn,
  }) {
    return LaunchState(
      status: status ?? this.status,
      isFirstInstall: isFirstInstall ?? this.isFirstInstall,
      isSignedIn: isSignedIn ?? this.isSignedIn,
    );
  }
}

@riverpod
class LaunchNotifier extends _$LaunchNotifier {
  @override
  Future<LaunchState> build() async {
    // Initial loading state
    final prefs = await SharedPreferences.getInstance();
    final auth = FirebaseAuth.instance;

    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    final isSignedIn = auth.currentUser != null;

    if (!hasSeenOnboarding) {
      return LaunchState(status: LaunchStatus.onboarding, isFirstInstall: true, isSignedIn: isSignedIn);
    } else if (!isSignedIn) {
      return LaunchState(status: LaunchStatus.auth, isFirstInstall: false, isSignedIn: false);
    } else {
      return LaunchState(status: LaunchStatus.home, isFirstInstall: false, isSignedIn: true);
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    state = AsyncValue.data(state.value!.copyWith(status: LaunchStatus.auth, isFirstInstall: false));
  }

  void updateAuthStatus(bool signedIn) {
    state = AsyncValue.data(state.value!.copyWith(
      status: signedIn ? LaunchStatus.home : LaunchStatus.auth,
      isSignedIn: signedIn,
    ));
  }
}
