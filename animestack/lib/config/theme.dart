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
    ),
    checkboxTheme: const CheckboxThemeData(
      fillColor: WidgetStatePropertyAll(Colors.white),
      checkColor: WidgetStatePropertyAll(Colors.black),
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(Colors.white),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    checkboxTheme: const CheckboxThemeData(
      fillColor: WidgetStatePropertyAll(Colors.black),
      checkColor: WidgetStatePropertyAll(
        Colors.white,
      ),
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(Colors.black),
    ),
  );
}
