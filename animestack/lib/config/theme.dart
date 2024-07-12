import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.latoTextTheme(),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        elevation: 0,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.black,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blueAccent,
      ));

  static ThemeData darkTheme = ThemeData(
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        color: Colors.black,
        elevation: 0,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: GoogleFonts.latoTextTheme(),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blueAccent,
      ));
}
