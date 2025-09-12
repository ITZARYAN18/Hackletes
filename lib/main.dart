import 'package:flutter/material.dart';
import 'package:sih_ui/routes/app.dart';
import 'package:sih_ui/streamlit-view.dart';
// import 'routes/app_routes.dart';
import 'ui/screens/main_navigation_screen.dart';

void main() {
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
      // home: MainNavigationScreen(),
      home: StreamlitView(),

      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}