import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/home_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegisterScreen(),
      '/profile': (context) => ProfileScreen(),
      '/settings': (context) => SettingsScreen(),
      '/home': (context) => HomeScreen(),
    };
  }
}
