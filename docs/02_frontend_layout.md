# 02_frontend_layout.md

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
- **Edit Profile form:** Full name, Specialty (hint "e.g. Contemporary Dance"), Bio (max 300), Instagram, TikTok, YouTube, gold **Save profile** button.
- **Change profile image:** gallery or camera, square crop, compress to about 1080px at JPEG quality 80, upload to Storage at `profile_photos/{uid}/avatar.jpg`, then update `photoUrl`.
- **Delete account** is done through a Cloud Function that removes the Auth user, the Firestore profile, and the Storage files.

### 4.6 Secondary screens
- Artist Application form, Audition form (name, specialty, contact, portfolio link, optional video link).
- About / "Who We Are": "TH+ is a talent agency that believes every artist deserves a team that fights for them. We do not just manage careers, we build them. Our artists are not just clients; they are family."
- "Why TH+" with four cards: Artist‑First Culture, World‑Class Coaching, Industry Connections, Ongoing Career Support.
- Notification settings, Terms, and Privacy pages.
