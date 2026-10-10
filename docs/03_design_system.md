# 03_design_system.md

## 5. Design System
- **Colors:** background `#0A0A0A`, surfaces `#141414` / `#1C1C1C`, gold `#C9A44C`, light gold `#E3C16F`, cream `#F8F1E0` (rare), text white `#FFFFFF` with secondary `#B8B8B8`, error `#E5484D`, live red `#FF3B30`, borders `#2A2A2A` (1px).
- **Typography:** Playfair Display for headings, wordmark, and display text. Inter for body, buttons, and labels. Small tracked caps for eyebrow labels (e.g. "TALENTHUB+ · EST. 2026").
- **Logo:** "TH+" in gold Playfair beside the spaced wordmark "TALENTHUB+".
- **Components:** 12‑16px radii, solid gold primary buttons with black text, outlined secondary buttons on a dark fill, gradients (black to transparent) over media.
- **Motion:** smooth transitions, pulsing LIVE badge, fade‑in feed items, haptics on key taps, reduced‑motion support.
- **Rules:** everything is centralized in `core/theme`, with no hardcoded colors or styles in widgets. 48px minimum tap targets, WCAG AA contrast, semantic labels, scalable text. Feed is portrait‑locked.
