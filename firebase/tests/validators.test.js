const { assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');
const { initializeTestEnvironment } = require('@firebase/rules-unit-testing');
const admin = require('firebase-admin');

let db;

beforeAll(async () => {
  await initializeTestEnvironment({
    projectId: 'talenthub-test',
    firestore: {
      rules: require('fs').readFileSync('firebase/firestore.rules', 'utf8'),
    },
  });
  db = admin.firestore();
});

describe('Firestore Validator Tests', () => {
  const alice = { uid: 'alice', email: 'alice@example.com', role: 'viewer', email_verified: true, banned: false };
  const bob = { uid: 'bob', email: 'bob@example.com', role: 'viewer', email_verified: false, banned: false };
  const adminUser = { uid: 'admin', email: 'admin@example.com', role: 'admin', email_verified: true, banned: false };

  const createAuthContext = (user) => ({
    uid: user.uid,
    token: {
      role: user.role,
      email_verified: user.email_verified,
      banned: user.banned,
    },
  });

  describe('isHttpsUrl', () => {
    const testUrl = async (url, shouldPass) => {
      const dbAuth = db.withSecurityRules({
        auth: createAuthContext(alice),
      });
      const ref = dbAuth.collection('artist_applications').doc('test');
      const data = {
        displayName: 'Test',
        specialty: 'Dance',
        portfolioLink: url,
        videoLink: url,
        status: 'pending',
        submittedAt: admin.firestore.FieldValue.serverTimestamp()
      };
      if (shouldPass) await assertSucceeds(dbAuth, 'create', ref, data);
      else await assertFails(dbAuth, 'create', ref, data);
    };

    test('valid HTTPS URLs pass', async () => {
      await testUrl('https://google.com', true);
      await testUrl('https://sub.domain.co.uk/path?q=1', true);
    });

    test('invalid URLs fail', async () => {
      await testUrl('http://google.com', false); // No HTTPS
      await testUrl('https:// a.com', false); // Space
      await testUrl('javascript:alert(1)', false); // Protocol
      await testUrl('https://evil.com/?x=instagram.com', false); // This should pass isHttpsUrl but we test the regex
      await testUrl('https://instagram.com.evil.com', false); // Not a simple domain
    });
  });

  describe('isHandle', () => {
    const testHandle = async (handle, shouldPass) => {
      const dbAuth = db.withSecurityRules({
        auth: createAuthContext(alice),
      });
      const ref = dbAuth.collection('users').doc(alice.uid);
      const data = {
        displayName: 'Test',
        photoUrl: `https://firebasestorage.googleapis.com/v0/b/test/o/profile_photos%2F${alice.uid}%2Favatar.jpg`,
        specialty: 'Dance',
        bio: 'Bio',
        instagram: handle,
        tiktok: handle,
        youtube: handle,
        role: 'viewer',
        isFeatured: false,
        isBanned: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      if (shouldPass) await assertSucceeds(dbAuth, 'create', ref, data);
      else await assertFails(dbAuth, 'create', ref, data);
    };

    test('valid handles pass', async () => {
      await testHandle('artist123', true);
      await testHandle('a', true);
      await testHandle('user.name', true);
      await testHandle('user_name', true);
      await testHandle('123artist', true);
    });

    test('invalid handles fail', async () => {
      await testHandle('.dancer', false); // Start with dot
      await testHandle('dancer.', false); // End with dot
      await testHandle('@user', false); // Starts with @
      await testHandle('a'.repeat(31), false); // Too long
      await testHandle('user name', false); // Space
    });
  });

  describe('isInstagram', () => {
    const testInsta = async (val, shouldPass) => {
      const dbAuth = db.withSecurityRules({ auth: createAuthContext(alice) });
      const ref = dbAuth.collection('users').doc(alice.uid);
      const data = {
        displayName: 'Test',
        photoUrl: `https://firebasestorage.googleapis.com/v0/b/test/o/profile_photos%2F${alice.uid}%2Favatar.jpg`,
        specialty: 'Dance',
        bio: 'Bio',
        instagram: val,
        tiktok: '',
        youtube: '',
        role: 'viewer',
        isFeatured: false,
        isBanned: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      if (shouldPass) await assertSucceeds(dbAuth, 'create', ref, data);
      else await assertFails(dbAuth, 'create', ref, data);
    };

    test('valid instagram values pass', async () => {
      await testInsta('', true);
      await testInsta('artist_handle', true);
      await testInsta('https://instagram.com/artist_handle/', true);
    });

    test('invalid instagram values fail', async () => {
      await testInsta('@artist_handle', false);
      await testInsta('https://facebook.com/artist', false);
      await testInsta('https://instagram.com/too_long_handle_over_30_chars_here/', false);
      await testInsta(' ', false);
      await testInsta('https://instagram.com@evil.com', false);
    });
  });

  describe('isYouTube', () => {
    const testYT = async (val, shouldPass) => {
      const dbAuth = db.withSecurityRules({ auth: createAuthContext(alice) });
      const ref = dbAuth.collection('users').doc(alice.uid);
      const data = {
        displayName: 'Test',
        photoUrl: `https://firebasestorage.googleapis.com/v0/b/test/o/profile_photos%2F${alice.uid}%2Favatar.jpg`,
        specialty: 'Dance',
        bio: 'Bio',
        instagram: '',
        tiktok: '',
        youtube: val,
        role: 'viewer',
        isFeatured: false,
        isBanned: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      if (shouldPass) await assertSucceeds(dbAuth, 'create', ref, data);
      else await assertFails(dbAuth, 'create', ref, data);
    };

    test('valid youtube values pass', async () => {
      await testYT('', true);
      await testYT('yt_handle', true);
      await testYT('https://youtube.com/@handle', true);
      await testYT('https://youtu.be/abc123def456', true);
      await testYT('https://youtube.com/channel/UC_long_id_here_1234567890123456', true);
    });

    test('invalid youtube values fail', async () => {
      await testYT('https://google.com', false);
      await testYT('https://youtube.com/too_long_handle_over_30_chars_here', false);
      await testYT(' ', false);
      await testYT('https://youtu.be/too_short', false);
      await testYT('https://youtube.com@evil.com', false);
    });
  });

  describe('isOwnStorageUrl', () => {
    const testStorage = async (uid, url, shouldPass) => {
      const dbAuth = db.withSecurityRules({ auth: createAuthContext({ ...alice, uid }) });
      const ref = dbAuth.collection('users').doc(uid);
      const data = {
        displayName: 'Test',
        photoUrl: url,
        specialty: 'Dance',
        bio: 'Bio',
        instagram: '',
        tiktok: '',
        youtube: '',
        role: 'viewer',
        isFeatured: false,
        isBanned: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      if (shouldPass) await assertSucceeds(dbAuth, 'create', ref, data);
      else await assertFails(dbAuth, 'create', ref, data);
    };

    test('valid storage URLs pass', async () => {
      await testStorage('user123', 'https://firebasestorage.googleapis.com/v0/b/bucket/o/profile_photos%2Fuser123%2Favatar.jpg?alt=media&token=123', true);
    });

    test('invalid storage URLs fail', async () => {
      await testStorage('user123', 'https://firebasestorage.googleapis.com/v0/b/bucket/o/profile_photos%2Fwrong_uid%2Favatar.jpg', false);
      await testStorage('user123', 'https://google.com/photo.jpg', false);
      await testStorage('user123', 'https://firebasestorage.googleapis.com/v0/b/bucket/o/public/avatar.jpg', false);
      await testStorage('user123', 'https://firebasestorage.googleapis.com/v0/b/bucket/o/profile_photos%2Fuser123%2F', false);
      await testStorage('user123', ' ', false);
    });
  });
});
