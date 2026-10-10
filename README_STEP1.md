name: talenthub
description: Flutter project scaffold with clean architecture folders and design system.
metadata:
  type: project-setup
---
# Scaffold Summary

- Added core theme files (`app_colors.dart`, `app_text_styles.dart`, `app_theme.dart`) defining the dark-first palette and typography using `google_fonts`.
- Created shared widget library (`gold_button.dart`, `outline_button.dart`, `text_field.dart`, `live_badge.dart`, `avatar.dart`, `empty_state.dart`, `shimmer_loader.dart`).
- Established folder structure `lib/core`, `lib/features`, `lib/shell`.
- Updated `lib/main.dart` with a minimal `MaterialApp.router` using a placeholder `GoRouter`.
- Added a basic widget test placeholder.
- Ran `flutter analyze` (no issues) and `flutter test` (0 tests).

## Assumptions
- Project uses Dart SDK ^3.12.2 as specified.
- Existing Firebase files remain untouched.
- No other code depends on the new theme yet.
- Assets folder will contain images later; currently none needed.
