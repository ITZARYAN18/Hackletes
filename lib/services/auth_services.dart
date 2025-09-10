import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static User? get _currentUser => FirebaseAuth.instance.currentUser;

  static String? get currentUser => _currentUser?.displayName;

  static String? get loginMethod {
    if (_currentUser?.isAnonymous ?? false) {
      return 'Guest';
    }
    return _currentUser?.providerData.isNotEmpty == true
        ? _currentUser!.providerData.first.providerId
        : null;
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static bool get isLoggedIn => _currentUser != null;
}