# 09_status_and_open_items.md

## 9. Current Status (update this section as work progresses)
- **Direction:** FRONTEND FIRST on mock data (no Firebase or IVS calls). Backend work is paused and resumes after frontend approval. Do not delete or modify the existing `firebase/` files.
- **Frontend steps:** (1) scaffold and theme (conditionally approved, with gaps: remove legacy theme getters and legacy UI, add SocialLinksRow, spacing and radii files, empty core folders, real widget tests, a design showcase screen, and visual proof), (2) routing and mock auth with a debug role panel, (3) onboarding and auth screens, (4) main shell and "+" sheets, (5) Home Feed tabs, (6) Go Live and Create Announcement, (7) Profile, Edit Profile, Settings, (8) secondary screens, (9) widget tests, (10) polish. One step at a time, with approval after each.
- **Backend (paused):** `firebase/firestore.rules` is written but NOT verified. Known pending fixes: isHandle regex mismatch, `@` handle rejection, `isOwnStorageUrl` `%2F` fix, validator tests (5 valid and 5 invalid each, including bypass cases), a real brace count, and a raw emulator run. Then `storage.rules`, the Cloud Functions, and the remaining tests.
- **Process rules:** never claim something is verified without raw proof (`flutter analyze`, `flutter test`, emulator output, screenshot or run log). Write code to files, not chat. Keep messages short. List assumptions after each step and wait for approval.

## 10. Open Items
- Verify current IVS Broadcast and Player SDK minimum Android and iOS versions from the official docs.
- Decide IVS channel type per artist tier, and the final cost estimate.
- Decide whether reports and auditions fully move behind callables (recommended: yes).
- Dev and prod flavors with separate Firebase projects are planned for after the frontend.
