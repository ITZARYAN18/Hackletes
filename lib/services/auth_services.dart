// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Current user
  static User? get currentUser => _auth.currentUser;

  // Logged in?
  static bool get isLoggedIn => currentUser != null;

  // Is anonymous guest?
  static bool get isGuest => currentUser?.isAnonymous ?? false;

  // User display name (sync)
  static String get userName {
    if (currentUser?.displayName != null && currentUser!.displayName!.isNotEmpty) {
      return currentUser!.displayName!;
    }
    return 'User';
  }

  // --- Google Sign In (unchanged, with extra logging) ---
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // user cancelled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      await _saveLoginMethod('google');
      return userCredential;
    } catch (e, st) {
      print('Google Sign-In Error: $e');
      print(st);
      return null;
    }
  }

  // --- Anonymous / Guest Sign In (robust) ---
  // Keep return type UserCredential? so your LoginScreen checks still work.
  static Future<UserCredential?> signInAsGuest() async {
    try {
      // Ensure Firebase is ready and call the platform API exactly once
      final UserCredential userCredential = await _auth.signInAnonymously();

      // optional: force reload so currentUser is up-to-date
      await userCredential.user?.reload();

      // save login method locally
      await _saveLoginMethod('guest');

      return userCredential;
    } catch (e, st) {
      // Log full stack trace to help debug platform cast errors
      print('Anonymous Sign-In Error: $e');
      print(st);
      return null;
    }
  }

  // Update Firebase display name + persist guest name locally (safe checks)
  static Future<void> updateUserName(String name) async {
    try {
      if (currentUser != null) {
        // Update Firebase user display name (works for anonymous users too)
        await currentUser!.updateDisplayName(name);
        // refresh
        await currentUser!.reload();
      }

      // always save guest name locally if login method is guest
      final prefs = await SharedPreferences.getInstance();
      final loginMethod = prefs.getString('login_method') ?? '';
      if (loginMethod == 'guest') {
        await prefs.setString('guest_name', name);
      }
    } catch (e, st) {
      print('Update name error: $e');
      print(st);
    }
  }

  static Future<String?> getGuestName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('guest_name');
  }

  static Future<String> getDisplayName() async {
    if (currentUser?.displayName != null && currentUser!.displayName!.isNotEmpty) {
      return currentUser!.displayName!;
    }

    final prefs = await SharedPreferences.getInstance();
    final loginMethod = prefs.getString('login_method') ?? '';
    if (loginMethod == 'guest') {
      final guestName = prefs.getString('guest_name');
      if (guestName != null && guestName.isNotEmpty) return guestName;
    }

    return 'User';
  }

  static Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginMethod = prefs.getString('login_method') ?? '';

      // Only sign out Google session if the saved login method was google
      if (loginMethod == 'google') {
        try {
          await _googleSignIn.signOut();
        } catch (e) {
          print('Google signOut error (ignored): $e');
        }
      }

      await _auth.signOut();
      await _clearLoginMethod();
    } catch (e, st) {
      print('Sign out error: $e');
      print(st);
    }
  }

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ------- local helpers ----------
  static Future<String> getLoginMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('login_method') ?? 'guest';
  }

  static Future<void> _saveLoginMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_method', method);
  }

  static Future<void> _clearLoginMethod() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login_method');
    await prefs.remove('guest_name');
  }
}
