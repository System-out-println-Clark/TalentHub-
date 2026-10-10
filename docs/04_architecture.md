# 04_architecture.md

## 6. Architecture (Frontend)
- Feature‑first clean architecture. Layers: Presentation (Riverpod widgets), Domain (pure Dart entities and repository interfaces), Data (implementations).
- **Rules:** presentation never touches Firebase directly. Every repository has an interface in `domain/`. Models use `freezed` and `json_serializable`. Errors use `AsyncValue` or a `Result` type.
- **Hybrid data flow (Approach 3, approved):**
  - Live tab: Firestore stream (`status == 'live'`, `startedAt DESC`) → LiveRepository (Stream) → Riverpod StreamProvider → LiveCard.
  - Announcements and Artists: cursor pagination (10 per page, fetch next at the 8th item), cached in an AsyncNotifier, with pull‑to‑refresh.
- **Packages:** flutter_riverpod (+ generator), go_router, freezed, google_fonts, cached_network_image, image_picker, image_cropper, flutter_image_compress, url_launcher, shared_preferences (onboarding flag only), flutter_secure_storage, permission_handler, share_plus, intl, connectivity_plus, smooth_page_indicator, plus the Firebase packages.

### Folder structure
```
talenthub_plus/
├── android/  ios/
├── assets/ (images/onboarding, logo, placeholders; icons)
├── docs/
├── functions/ (TypeScript Cloud Functions)
│   └── src/ (index.ts, live/, users/, moderation/, notifications/)
├── firebase/ (firestore.rules, storage.rules, firestore.indexes.json, firebase.json, tests/)
├── lib/
│   ├── main.dart (later main_dev / main_prod flavors)
│   ├── core/ (theme, router, constants, errors, utils, services, widgets)
│   ├── features/ (splash, onboarding, auth, home_feed, live, announcements,
│   │             artists, profile, create_hub, audition, about)
│   └── shell/ (main_shell.dart with the 3‑item bottom nav)
├── test/  integration_test/
├── analysis_options.yaml  pubspec.yaml  README.md
```
