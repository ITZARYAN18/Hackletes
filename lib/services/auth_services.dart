
// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => currentUser != null;

  // Get user display name
  static String get userName {
    if (currentUser?.displayName != null && currentUser!.displayName!.isNotEmpty) {
      return currentUser!.displayName!;
    }
    return 'User';
  }

  // Check if user is anonymous (guest)
  static bool get isGuest => currentUser?.isAnonymous ?? false;

  // Google Sign In
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Save login method
      await _saveLoginMethod('google');

      return userCredential;
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  // Guest Sign In (Anonymous)
  static Future<UserCredential?> signInAsGuest() async {
    try {
      final UserCredential userCredential = await _auth.signInAnonymously();
      await _saveLoginMethod('guest');
      return userCredential;
    } catch (e) {
      print('Anonymous Sign-In Error: $e');
      return null;
    }
  }

  // Update user display name
  static Future<void> updateUserName(String name) async {
    try {
      await currentUser?.updateDisplayName(name);
      // Save name locally for guest users
      if (isGuest) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('guest_name', name);
      }
    } catch (e) {
      print('Update name error: $e');
    }
  }

  // Get guest name from local storage
  static Future<String?> getGuestName() async {
    if (isGuest) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('guest_name');
    }
    return null;
  }

  // Get user display name (including guest names)
  static Future<String> getDisplayName() async {
    if (currentUser?.displayName != null && currentUser!.displayName!.isNotEmpty) {
      return currentUser!.displayName!;
    }

    if (isGuest) {
      final guestName = await getGuestName();
      if (guestName != null && guestName.isNotEmpty) {
        return guestName;
      }
    }

    return 'User';
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await _clearLoginMethod();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Get login method
  static Future<String> getLoginMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('login_method') ?? 'guest';
  }

  // Save login method
  static Future<void> _saveLoginMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_method', method);
  }

  // Clear login method
  static Future<void> _clearLoginMethod() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login_method');
    await prefs.remove('guest_name');
  }

  // Auth state changes stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
}