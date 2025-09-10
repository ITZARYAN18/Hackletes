// File: ui/screens/name_input_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NameInputScreen extends StatefulWidget {
  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                  color: const Color(0xFF7B68EE),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.rocket_launch,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'What\'s your name?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'We\'ll use this to personalize your experience',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Name Input Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _nameController,
                  decoration:  InputDecoration(
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
                  style: const TextStyle(fontSize: 16),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (text) => setState(() {}),
                ),
              ),

              const SizedBox(height: 30),

              // Continue Button
              Container(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _nameController.text.trim().isEmpty
                      ? null
                      : () => _continueToApp(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B68EE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Skip Button
              TextButton(
                onPressed: () {
                  _nameController.text = 'Guest';
                  _continueToApp();
                },
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
    final name = _nameController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.updateDisplayName(name.isNotEmpty ? name : 'Guest');
      // No navigation here. The StreamBuilder in main.dart handles it
    } else {
      debugPrint("Error: Current user is null when trying to set display name.");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}