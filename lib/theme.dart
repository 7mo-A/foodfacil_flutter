import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Colors.green[600]!,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    color: Colors.green[600]!,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.white,
    unselectedLabelColor: Colors.black,
    indicator: BoxDecoration(
      color: Colors.green[600]!,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green[600]!,
      foregroundColor: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green[600]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green[600]!),
    ),
    labelStyle: TextStyle(color: Colors.green[600]!),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.green[600]!,
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
  ),
);
