import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/recipe_detail_screen.dart';
import '../models/recipe.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegisterScreen(),
      '/profile': (context) => ProfileScreen(),
      '/settings': (context) => SettingsScreen(),
      '/home': (context) => HomeScreen(),
      '/search': (context) => SearchScreen(),
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/recipeDetail':
        final recipe = settings.arguments as Recipe;
        return MaterialPageRoute(
          builder: (context) => RecipeDetailScreen(recipe: recipe),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
    }
  }
}
