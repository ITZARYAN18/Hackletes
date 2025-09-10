// File: main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sih_ui/routes/app.dart';

import 'ui/screens/login_screen.dart';
import 'ui/screens/main_navigation_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(HackletesApp());
}

class HackletesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hackletes',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Inter',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            // User is signed in, go to the main app screen
            return MainNavigationScreen();
          } else {
            // User is not signed in, show the login screen
            return LoginScreen();
          }
        },
      ),
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}