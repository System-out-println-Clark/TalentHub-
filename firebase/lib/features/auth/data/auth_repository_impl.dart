import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/auth_repository.dart';
import '../domain/app_user.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _auth = firebaseAuth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Stream<AppUser?> watchUser() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      return AppUser.fromJson(doc.data()!);
    });
  }

  @override
  Future<void> signUp({
 la required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // 1. Create Auth User
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // 2. Initialize Public Profile
      final publicData = {
        'displayName': displayName,
        'email': email,
        'photoUrl': '',
        'specialty': '',
        'bio': '',
        'instagram': '',
        'tiktok': '',
        'youtube': '',
        'role': 'viewer',
        'isFeatured': false,
        'isBanned': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // 3. Initialize Private Profile
      final privateData = {
        'email': email,
        'fcmTokens': [],
        'phoneNumber': '',
      };

      // Use a WriteBatch for atomicity
      final batch = _firestore.batch();
      batch.set(_firestore.collection('users').doc(uid), publicData);
      batch.set(_firestore.collection('users').doc(uid).collection('private').doc('profile'), privateData);

      await batch.commit();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred during sign up.');
    }
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
