# App Flow & Navigation Specification
**Project:** TalentHub+ (TH+)
**Status:** Finalized Design

## 1. The Global Router (go_router)
The application uses a centralized routing system with a Guard-based redirect to ensure zero-flash transitions.

### Route Map
| Path | Screen | Access | Notes |
| :--- | :--- | :--- | :--- |
| `/splash` | SplashScreen | Public | Entry point; handles state check |
| `/onboarding` | OnboardingCarousel | Public | Full-bleed media, ends at Sign-Up |
| `/auth/login` | LoginScreen | Public | Email/Pass, Google, Apple |
| `/auth/signup` | SignupScreen | Public | Creates `users/{uid}` (Role: Viewer) |
| `/home` | HomeFeedScreen | Signed-In | The primary Nested PageView experience |
| `/profile/:uid` | ProfileScreen | Signed-In | Portfolio view; Edit mode if `uid == me` |
| `/live/broadcast` | BroadcastScreen | Artist/Admin | AWS IVS Broadcaster implementation |
| `/auditions` | AuditionForm | Signed-In | Gateway for Artist applications |
| `/about` | AboutScreen | Public | Brand story and value cards |

### Redirect Logic
`LaunchStateProvider` $\rightarrow$ `go_router` redirect:
1. `!hasSeenOnboarding` $\rightarrow$ `/onboarding`
2. `hasSeenOnboarding && !isSignedIn` $\rightarrow$ `/auth/login`
3. `hasSeenOnboarding && isSignedIn` $\rightarrow$ `/home`

## 2. The Home Feed (The Cinematic Engine)
The Home Feed is implemented as a **Nested PageView** with a **State-Driven Sync** via Riverpod.

### Navigation Hierarchy
- **Outer PageView (Horizontal):**
  - Index 0: `LiveReel` (Vertical)
  - Index 1: `AnnouncementReel` (Vertical)
  - Index 2: `ArtistReel` (Vertical)
- **Inner PageView (Vertical):**
  - TikTok-style full-screen scrolling.
  - Uses `AutomaticKeepAliveClientMixin` to preserve scroll position.

### State Sync Loop
`FeedNavigationProvider` $\rightarrow$ `{ activeTab, verticalIndex }`
- **Tab $\rightarrow$ Reel:** `tabTap` $\rightarrow$ `animateToPage()` (Outer).
- **Reel $\rightarrow$ Tab:** `onPageChanged` (Outer) $\rightarrow$ update `activeTab` $\rightarrow$ slide Gold Underline.
- **Player Management:** `VideoPlayerManager` singleton listens to state; disposes current `IVSPlayer` and initializes the next based on `(activeTab, verticalIndex)`.

## 3. The "Create Hub" Logic
The central (+) button acts as the primary entry point for Artist functionality.

**Flow:**
`BottomNav(+)` $\rightarrow$ `RoleCheck` $\rightarrow$ `CreateBottomSheet`
- **Viewer:** $\rightarrow$ "Locked" state $\rightarrow$ Redirect to `/auditions`.
- **Artist/Admin:** $\rightarrow$ "Create Announcement" or "Go Live".

### The "Go Live" Pipeline
`Create Hub` $\rightarrow$ `Pre-Live Form` $\rightarrow$ `Callable: startBroadcasting` $\rightarrow$ `Native IVS Broadcast SDK` $\rightarrow$ `BroadcastScreen`.

## 4. Design-Driven Transitions
- **Auth $\rightarrow$ Home:** Fade-through-black transition.
- **Onboarding:** la- la- slide transitions with fade-in typography.
- **Profile Edit:** Bottom-sheet dropdown for "Change Image" and "Edit Info" to avoid screen-jumping.
