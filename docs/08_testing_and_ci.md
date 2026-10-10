# 08_testing_and_ci.md

## 8. Quality, Testing, CI
- Loading (shimmer), empty, error, and offline states on every screen. Pull‑to‑refresh where relevant. Localization‑ready (`intl`, English default).
- **Tests:**
  - Unit tests (validators, repositories)
  - Widget tests (onboarding, login, tab‑bar sync, "+" sheet by role, profile edit validation)
  - Firestore and Storage rules tests with the Emulator Suite (including negative cases)
  - Integration tests
- **CI:** GitHub Actions running `flutter analyze`, `flutter test`, and the rules tests.
