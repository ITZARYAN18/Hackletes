// ui/screens/login_screen.dart
import 'package:flutter/material.dart';

import '../../services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo and Name
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFF7B68EE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.rocket_launch,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Hackletes',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Your Personal Training Companion',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60),

              // Login Options
              Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 30),

              // Google Login Button
              _buildLoginButton(
                title: 'Continue with Google',
                icon: Icons.account_circle,
                color: Colors.red,
                backgroundColor: Colors.white,
                textColor: Colors.black87,
                onPressed: _isLoading ? null : _signInWithGoogle,
              ),

              SizedBox(height: 20),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[400])),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[400])),
                ],
              ),

              SizedBox(height: 20),

              // Guest Login Button
              _buildLoginButton(
                title: 'Continue as Guest',
                icon: Icons.person_outline,
                color: Color(0xFF7B68EE),
                backgroundColor: Color(0xFF7B68EE),
                textColor: Colors.white,
                onPressed: _isLoading ? null : _signInAsGuest,
              ),

              if (_isLoading) ...[
                SizedBox(height: 20),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B68EE)),
                ),
              ],

              SizedBox(height: 30),

              // Terms and Privacy
              Text(
                'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required String title,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: backgroundColor == Colors.white
                ? BorderSide(color: Colors.grey[300]!)
                : BorderSide.none,
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await AuthService.signInWithGoogle();

      if (userCredential != null) {
        // Success - navigate to main app
        Navigator.pushReplacementNamed(context, '/main-navigation');
      } else {
        // User canceled or error occurred
        _showErrorSnackBar('Google sign-in was canceled or failed');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred during Google sign-in');
    }

    setState(() => _isLoading = false);
  }

  void _signInAsGuest() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await AuthService.signInAsGuest();

      if (userCredential != null) {
        // Success - navigate to name input for guests
        Navigator.pushReplacementNamed(context, '/name-input');
      } else {
        _showErrorSnackBar('Failed to sign in as guest');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred during guest sign-in');
    }

    setState(() => _isLoading = false);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
