# 06_data_model.md

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
