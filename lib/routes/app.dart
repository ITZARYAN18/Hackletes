import 'package:flutter/material.dart';
import '../ui/screens/splash_screen.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/name_input_screen.dart';
import '../ui/screens/main_navigation_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/workouts_screen.dart';
import '../ui/screens/progress_screen.dart';
import '../ui/screens/profile_screen.dart';
import '../ui/screens/vertical_jump_test_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String nameInput = '/name-input';
  static const String mainNavigation = '/main-navigation';
  static const String home = '/home';
  static const String workouts = '/workouts';
  static const String progress = '/progress';
  static const String profile = '/profile';
  static const String verticalJumpTest = '/vertical-jump-test';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    login: (context) => LoginScreen(),
    nameInput: (context) => NameInputScreen(),
    mainNavigation: (context) => MainNavigationScreen(),
    home: (context) => HomeScreen(),
    workouts: (context) => WorkoutsScreen(),
    progress: (context) => ProgressScreen(),
    profile: (context) => ProfileScreen(),
    verticalJumpTest: (context) => VerticalJumpTestScreen(),
  };
}
