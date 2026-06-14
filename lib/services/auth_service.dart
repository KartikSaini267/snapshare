import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream that emits a User when logged in, or null when logged out.
  // SplashScreen listens to this to decide which screen to show.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // ── SIGN UP ──────────────────────────────────────────────────────────────
  Future<String> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Step 1: create the account in Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: save extra info (username, etc.) to Firestore
      UserModel newUser = UserModel(
        uid: credential.user!.uid,
        username: username,
        email: email,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(newUser.toMap());

      return 'success';
    } on FirebaseAuthException catch (e) {
      return _handleError(e.code);
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }

  // ── LOG IN ───────────────────────────────────────────────────────────────
  Future<String> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'success';
    } on FirebaseAuthException catch (e) {
      return _handleError(e.code);
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }

  // ── LOG OUT ──────────────────────────────────────────────────────────────
  Future<void> logOut() async {
    await _auth.signOut();
  }

  // ── GET USER DATA ────────────────────────────────────────────────────────
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ── ERROR MESSAGES ───────────────────────────────────────────────────────
  String _handleError(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}