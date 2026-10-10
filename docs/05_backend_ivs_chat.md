# 05_backend_ivs_chat.md

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
