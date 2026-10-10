# TalentHub+ (TH+): Master Project Reference

## Index
- [01_product_and_roles.md](01_product_and_roles.md)
- [02_frontend_layout.md](02_frontend_layout.md)
- [03_design_system.md](03_design_system.md)
- [04_architecture.md](04_architecture.md)
- [05_backend_ivs_chat.md](05_backend_ivs_chat.md)
- [06_data_model.md](06_data_model.md)
- [07_security_rules.md](07_security_rules.md)
- [08_testing_and_ci.md](08_testing_and_ci.md)
- [09_status_and_open_items.md](09_status_and_open_items.md)


> Single source of truth. If any other doc, code comment, or earlier AI summary conflicts with this file, this file wins. Do not invent modules, screens, or features that are not listed here. Propose additions and wait for approval.

## 1. Product Overview
- **Name:** TalentHub+ (TH+). Tagline: "Where Talent Finds Its Stage." Hero line: "Your talent deserves the world's stage."
- **What it is:** A premium talent agency mobile app where artists and dancers are discovered, developed, and celebrated. The mobile app adapts the web version (hero, Priority Announcements, Who We Are, Why TH+, Featured Artists, Live page, My Profile form) into a TikTok‑style vertical‑scroll experience made only of **livestreams, announcements, and artist spotlights**.
- **What it is NOT:** a portfolio/Bento‑grid app, a generic social network, or a dashboard app. There are no "Talent" or "Hub" modules.
- **Brand feel:** cinematic, elegant, dark‑first, gold accents.
- **Origin:** The web version (hero, Priority Announcements, Who We Are, Why TH+, Featured Artists, Live page, My Profile form) was the reference. The mobile app adapts it.
- **Stack:** Flutter (Dart, null‑safe) + Firebase (Auth, Firestore, Storage, Messaging, App Check, Crashlytics, Analytics, Cloud Functions in TypeScript) + AWS IVS for livestreaming.

## 2. Roles
| Role | Can do |
|---|---|
| viewer | Watch lives, read announcements, browse artists, chat in lives (signed in and not banned), apply to become an artist, submit auditions |
| artist | Everything a viewer can, plus go live, post announcements, edit own profile |
| admin | Everything above, plus manage roles and bans, feature artists, pin priority announcements, moderate chat, end any stream |

- **Artist promotion (application‑based):** viewer submits an artist application, an admin approves it, a Cloud Function sets the custom claim `role='artist'`, and the client force‑refreshes its ID token (`getIdToken(true)`).
- The first admin is created manually in the Firebase Console.

## 3. App Flow
1. **Splash** checks the local `hasSeenOnboarding` flag (**shared_preferences**, per install, never Firestore) and the Firebase Auth session.
2. **First install:** Pinterest‑style onboarding carousel, then Sign Up, then Home Feed.
3. **Returning signed‑in user:** straight to the Home Feed (live reel page).
4. **Flag set but signed out:** Login.
5. Routing uses go_router redirects driven by an auth/onboarding Riverpod provider.

### Onboarding carousel
- 4 full‑bleed image slides, Playfair headline, Inter subtext, page dots, Skip and Next.
- Copy ideas: (1) "Your talent deserves the world's stage." (2) "Watch artists perform live." (3) "Never miss an announcement." (4) "Join the family."
- The **last slide** has a gold **Sign Up** button plus an "I already have an account" link.
- Set `hasSeenOnboarding = true` on finish or skip. Placeholder images live in `assets/images/onboarding/`.

### Auth
- Email/password, Google Sign‑In, Apple Sign‑In on iOS, email verification, password reset.
- Sign‑up collects full name, email, and password, then creates `users/{uid}` with role `viewer`.
- Login failures use a generic message and never reveal whether an email exists.
- Password minimum is 8 characters with a strength meter. Re‑authenticate before sensitive actions (delete account, change email or password).

## 4. Frontend Layout
### 4.1 Home Feed (confirmed design)
- **Top tab bar:** `Live | Announcements | Artists`. Active tab is white and bold with an animated gold underline. Search icon on the right. Small LIVE‑TV icon on the left that jumps to the Live tab. The bar overlays the media on a transparent gradient.
- **Navigation (Option B, "PageView of PageViews"):** a horizontal `PageView` (tab switcher) containing one vertical `PageView.builder` (reel) per tab.
- **Tab sync:** the tab bar is a separate, stateless widget that controls the horizontal `PageController`. A Riverpod `activeTabIndex` provider keeps both directions in sync (tap calls `animateToPage`, swipe updates the provider, and the underline animates from the provider).
- **Persistence:** each vertical reel uses `AutomaticKeepAliveClientMixin` so scroll position survives tab switches.
- **Gesture conflicts:** resolved with axis‑specific scroll behavior and physics, not a `GestureDetector` wrapper. Test with rapid diagonal swipes on real devices.
- **Single player rule:** only ONE video player is active at a time. Pause or dispose off‑screen players. Pre‑buffer at most the next item.

**Live tab cards:** video, pulsing red LIVE badge, viewer count, host avatar and name, title, description, and a live chat overlay with a message input. Empty state: "No one is live right now. Check back soon." with a button to browse artists.

**Announcements tab cards:** image or gradient background, title, body, author, timestamp. Pinned and priority items come first with a gold "Priority" badge. Includes an "Audition Available Now!" style card linking to the Audition form.

**Artists tab cards:** photo, name, specialty, short bio, Instagram/TikTok/YouTube buttons, and a "View profile" button.

### 4.2 Bottom navigation (exactly three items)
- Left: **Home**. Center: raised **"+"** pill. Right: **Profile**.
- Black bar, thin top border, active item in gold.
- The "+" opens a bottom sheet with **Create Announcement** and **Go Live**, visible to artists and admins only.
- For viewers, the "+" opens an informative sheet explaining how to become an artist, with an **"Apply to become an artist"** button that routes to the Artist Application form. If the user already applied, show the application status instead. Never open the form directly.

### 4.3 Go Live screen
- **Pre‑live:** Stream title (required, max 80) and Description ("What are you performing today?", max 300), gold **Start broadcasting** button, camera preview, flip camera, mic and camera toggles, and a permission rationale screen.
- **While live:** viewer count, End Stream with a confirm dialog, chat overlay with moderation (delete message, mute or block user).
- **On end:** a short summary screen.

### 4.4 Create Announcement
- Title (required, max 100), body (required, max 1000), optional image, optional link, admin‑only **Pin as priority** toggle, and a live card preview.

### 4.5 Profile (vertical, TikTok‑style)
- Large circular photo with a **pencil icon badge at the bottom‑left**. Below it: name, specialty, bio, and icon buttons for Instagram, TikTok, YouTube (validated only).
- Tapping the pencil **or** the photo opens a bottom‑sheet dropdown with **Change profile image** and **Edit profile info**.
- Tabs for the user's past announcements and past streams. Settings entry (notifications, privacy, sign out, delete account).
- **ONE shared profile screen with two modes:** own profile (pencil, edit actions, settings) and another user's profile (pushed route from an artist card, back button, read‑only, no pencil, no settings). Admin‑only controls (feature, ban) show only for admins and call Cloud Functions.
- **Edit Profile form** (styled after the web "My Profile" form): Full name, Specialty (hint "e.g. Contemporary Dance"), Bio (max 300), Instagram, TikTok, YouTube, gold **Save profile** button.
- **Change profile image:** gallery or camera, square crop, compress to about 1080px at JPEG quality 80, upload to Storage at `profile_photos/{uid}/avatar.jpg`, then update `photoUrl`.
- **Delete account** is done through a Cloud Function that removes the Auth user, the Firestore profile, and the Storage files.

### 4.6 Secondary screens
- Artist Application form, Audition form (name, specialty, contact, portfolio link, optional video link).
- About / "Who We Are": "TH+ is a talent agency that believes every artist deserves a team that fights for them. We do not just manage careers, we build them. Our artists are not just clients; they are family."
- "Why TH+" with four cards: Artist‑First Culture, World‑Class Coaching, Industry Connections, Ongoing Career Support.
- Notification settings, Terms, and Privacy pages.

## 5. Design System
- **Colors:** background `#0A0A0A`, surfaces `#141414` / `#1C1C1C`, gold `#C9A44C`, light gold `#E3C16F`, cream `#F8F1E0` (rare), text white `#FFFFFF` with secondary `#B8B8B8`, error `#E5484D`, live red `#FF3B30`, borders `#2A2A2A` (1px).
- **Typography:** Playfair Display for headings, wordmark, and display text. Inter for body, buttons, and labels. Small tracked caps for eyebrow labels (e.g. "TALENTHUB+ · EST. 2026").
- **Logo:** "TH+" in gold Playfair beside the spaced wordmark "TALENTHUB+".
- **Components:** 12‑16px radii, solid gold primary buttons with black text, outlined secondary buttons on a dark fill, gradients (black to transparent) over media.
- **Motion:** smooth transitions, pulsing LIVE badge, fade‑in feed items, haptics on key taps, reduced‑motion support.
- **Rules:** everything is centralized in `core/theme`, with no hardcoded colors or styles in widgets. 48px minimum tap targets, WCAG AA contrast, semantic labels, scalable text. Feed is portrait‑locked.

## 6. Architecture (Frontend)
- Feature‑first clean architecture. Layers: Presentation (Riverpod widgets), Domain (pure Dart entities and repository interfaces), Data (implementations).
- Rules: presentation never touches Firebase directly. Every repository has an interface in `domain/`. Models use `freezed` and `json_serializable`. Errors use `AsyncValue` or a `Result` type.
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

## 7. Backend
### 7.1 Video pipeline (AWS IVS)
- **Broadcast:** artist app, native IVS Broadcast SDK (Android and iOS, wrapped via platform channels), IVS ingest endpoint (RTMP), IVS channel.
- **Playback:** IVS channel, signed playback token, IVS Player SDK in a platform view, Flutter UI. `video_player` is not used for IVS.
- **Private channels with signed playback tokens.** Viewers get tokens through a callable that checks auth, App Check, not banned, and stream live.
- **Stream keys:** channel creation, stream keys, and playback tokens exist ONLY in Cloud Functions. Keys are returned only to the verified host via `startBroadcasting`, never stored in Firestore, never logged, and rotated after every stream. Ending a stream is enforceable server‑side (`endStream` by host or admin), including a server timeout.
- **Viewer count:** computed by a Cloud Function polling IVS metrics and mirrored to Firestore every 30‑60 seconds. Clients never write it.
- **Platform minimums:** NOT yet verified. An earlier AI claim of Android 24 / iOS 13 must be checked against the current official IVS SDK docs.
- **Cost/scale:** Basic channels for most artists. Standard channels for featured artists. Platform views are memory‑heavy, so use a strict singleton player manager and dispose the native view as soon as the user slides away.

### 7.2 Chat
- Chat stays on **Firestore** (`streams/{streamId}/messages`), but **ALL sends go through a `sendMessage` callable** (cooldown, profanity filter, rate limit). Clients cannot create messages directly.
- Cooldown via a server‑only `user_cooldowns` doc (about 2 seconds). TTL on `expiresAt` (24 hours).
- A profanity trigger flags or deletes messages. Hosts, authors, and admins can delete messages.

### 7.3 Data model (Firestore)
- `users/{uid}`: displayName (1‑50), photoUrl, specialty (1‑100), bio (1‑300), instagram, tiktok, youtube, role (mirror only), isFeatured, isBanned, createdAt, updatedAt
- `users/{uid}/private/profile`: email (server‑written), fcmTokens (max 5), phoneNumber
- `artist_applications/{uid}`: displayName, specialty, portfolioLink, videoLink, status (pending | approved | rejected), submittedAt
- `streams/{streamId}` (server‑write only): hostUid, hostName, hostPhotoUrl, title, description, status (live | ended), viewerCount, startedAt, endedAt
- `streams/{streamId}/messages/{id}`: uid, displayName, photoUrl, text (1‑300), createdAt, isDeleted, isFlagged, expiresAt
- `announcements/{id}`: authorUid, authorName, title (max 100), body (max 1000), imageUrl, link, isPriority, isPinned, createdAt
- `auditions/{id}`: userUid, name, specialty, contact, portfolioLink, videoLink, status (pending | reviewed), createdAt
- `reports/{id}`: reporterUid, targetType (user | stream | message), targetId, reason (1‑500), createdAt
- `audit_logs/{id}` (server‑write only): adminUid, action, targetUid, details, timestamp
- `user_cooldowns/{docId}` (server‑write only): lastSent
- Composite indexes: streams by status and startedAt, announcements by isPriority and createdAt.

### 7.4 Security model ("Fort Knox", server‑first)
- **Custom claims (`role`, `banned`) are the ONLY source of authorization.** The `role` field in `users` is a mirror and rules never trust it. New viewers get `role: 'viewer'` from `onUserCreate`, and `hasRole()` fails closed if the claim is missing.
- **Server‑write only:** streams, roles, bans, featured flag, audit logs, cooldowns, and chat messages. The Admin SDK bypasses rules, so each Cloud Function must validate its own input (zod), check `context.auth`, the role claim, banned status, and App Check.
- **Rules principles:** default deny at the end of Firestore and Storage rules (no broader allow above it), strict key allow‑lists (`hasOnly` and `hasAll`), type and length validation on every field, `createdAt` and `updatedAt == request.time`, https‑only and platform‑specific URL validators, `isNotBanned()` and `isEmailVerified()` on every client write, admin updates limited to specific fields, and `audit_logs` read‑only for admins.
- **Ban flow:** a function sets claim `banned: true` (merging existing claims, never overwriting), sets the mirror, revokes refresh tokens, and ends any stream the user hosts. Role promotion must READ existing claims and MERGE them so it never un‑bans a banned user. `onApplicationUpdate` must be idempotent and safe on retry, and write an audit log.
- **Rate limiting:** rules cannot do it, so reports, auditions, and chat go through callables with cooldowns.
- **Validators:** `isHttpsUrl` (host label rules, max 300, no whitespace or control chars), `isHandle` (stored WITHOUT "@", 1‑30 chars, must start and end with a letter or number, dots and underscores only in the middle), `isInstagram`, `isTikTok` (`/@handle`), `isYouTube` (`/@handle`, `/c/`, `/channel/`, `/user/`, `youtu.be/<11 chars>`), and `isOwnStorageUrl(uid)` (must handle `%2F`‑encoded download URLs). Platform URLs allow no free tail: only an optional trailing slash and query string. Check `val is string` before `val == ''`. The client strips a leading "@" before saving.
- **Storage rules:** default deny. `profile_photos/{uid}/**` is writable only by that uid, image only, under 5 MB. `announcements/{uid}/**` is writable by artists and admins for their own uid only, image only, under 8 MB, with deletes for the owner or an admin. Banned users are blocked, and filename or extension restrictions apply.
- **Other controls:** App Check enforced on Firestore, Storage, Functions, and Auth. Secrets in Secret Manager (never in the repo or app). Least‑privilege IAM. Budget alerts. Obfuscation for release builds, no PII logging, email verification required before going live or posting, and in‑app account deletion plus a 13+ age gate.

### 7.5 Cloud Functions list
`onUserCreate`, `setUserRole` / `onApplicationUpdate`, `banUser`, `featureArtist`, `deleteAccount`, `sendMessage`, `startBroadcasting`, `endStream`, `getPlaybackToken`, `syncViewerCount`, `onStreamWrite`, chat profanity trigger, `notifyOnLive`, `notifyOnAnnouncement`, plus callables for reports and auditions.

## 8. Quality, Testing, CI
- Loading (shimmer), empty, error, and offline states on every screen. Pull‑to‑refresh where relevant. Localization‑ready (`intl`, English default).
- Tests: unit tests (validators, repositories), widget tests (onboarding, login, tab‑bar sync, "+" sheet by role, profile edit validation), Firestore and Storage rules tests with the Emulator Suite (including negative cases), and integration tests.
- CI: GitHub Actions running `flutter analyze`, `flutter test`, and the rules tests.

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

*Save the document above as `docs/00_MASTER_REFERENCE.md`. Then split it into focused files inside `docs/` (for example `01_product_and_roles.md`, `02_frontend_layout.md`, `03_design_system.md`, `04_architecture.md`, `05_backend_ivs_chat.md`, `06_data_model.md`, `07_security_rules.md`, `08_testing_and_ci.md`, `09_status_and_open_items.md`), keep the master file as an index linking to each, and do not change any content. Move any existing docs that conflict with the master into `docs/archive/` and tell me which ones you moved.*