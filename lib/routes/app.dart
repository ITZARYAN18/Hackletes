import 'package:flutter/material.dart';
import 'package:sih_ui/models/situp_feature.dart';
import 'package:sih_ui/models/situp_screen.dart';
import '../models/jump_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/workouts_screen.dart';
import '../ui/screens/progress_screen.dart';
import '../ui/screens/profile_screen.dart';
import '../ui/screens/vertical_jump_test_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String workouts = '/workouts';
  static const String progress = '/progress';
  static const String profile = '/profile';
  static const String verticalJumpTest = '/vertical-jump-test';
  static const String situpCounter = '/situp-counter';
  static const String runningTest = '/running-test';


  static Map<String, WidgetBuilder> routes = {
    home: (context) => HomeScreen(),
    workouts: (context) => WorkoutsScreen(),
    progress: (context) => ProgressScreen(),
    profile: (context) => ProfileScreen(),
    verticalJumpTest: (context) => JumpUploadScreen(),
    runningTest: (context) => VideoSelectionScreen(),
    situpCounter: (context) =>UploadScreen(),


  };
}
