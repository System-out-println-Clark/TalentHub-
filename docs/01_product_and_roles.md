# 01_product_and_roles.md

## 1. Product Overview
- **Name:** TalentHub+ (TH+). Tagline: "Where Talent Finds Its Stage." Hero line: "Your talent deserves the world's stage."
- **What it is:** A premium talent agency mobile app where artists and dancers are discovered, developed, and celebrated. The mobile app adapts the web version (hero, Priority Announcements, Who We Are, Why TH+, Featured Artists, Live page, My Profile form) into a TikTok‑style vertical‑scroll experience made only of **livestreams, announcements, and artist spotlights**.
- **What it is NOT:** a portfolio/Bento‑grid app, a generic social network, or a dashboard app. There are no "Talent" or "Hub" modules.
- **Brand feel:** cinematic, elegant, dark‑first, gold accents.
- **Origin:** The web version was the reference; the mobile app adapts it.

## 2. Roles
| Role | Can do |
|---|---|
| viewer | Watch lives, read announcements, browse artists, chat in lives (signed in and not banned), apply to become an artist, submit auditions |
| artist | Everything a viewer can, plus go live, post announcements, edit own profile |
| admin | Everything above, plus manage roles and bans, feature artists, pin priority announcements, moderate chat, end any stream |

- **Artist promotion (application‑based):** viewer submits an artist application, an admin approves it, a Cloud Function sets the custom claim `role='artist'`, and the client force‑refreshes its ID token (`getIdToken(true)`).
- The first admin is created manually in the Firebase Console.
