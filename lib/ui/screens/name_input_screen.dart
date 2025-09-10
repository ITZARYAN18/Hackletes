import 'package:flutter/material.dart';

import '../../services/auth_services.dart';

class NameInputScreen extends StatefulWidget {
  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();
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
              // App Logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF7B68EE),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.rocket_launch,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(height: 30),

              Text(
                'What\'s your name?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We\'ll use this to personalize your experience',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // Name Input Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Color(0xFF7B68EE),
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) => setState(() {}),
                ),
              ),

              SizedBox(height: 30),

              // Continue Button
              Container(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: (_nameController.text.trim().isEmpty || _isLoading)
                      ? null
                      : _continueToApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7B68EE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Skip Button
              TextButton(
                onPressed: _isLoading ? null : _skipToApp,
                child: Text(
                  'Skip for now',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _continueToApp() async {
    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    await AuthService.updateUserName(name);

    Navigator.pushReplacementNamed(context, '/main-navigation');

    setState(() => _isLoading = false);
  }

  void _skipToApp() async {
    setState(() => _isLoading = true);

    await AuthService.updateUserName('Guest');

    Navigator.pushReplacementNamed(context, '/main-navigation');

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
