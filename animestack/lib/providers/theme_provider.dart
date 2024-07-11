import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeProvider = StateProvider<ThemeMode>((ref) {
  var themeBox = Hive.box('themeBox');
  late String theme;
  if (themeBox.get('theme') != null) {
    theme = themeBox.get('theme');
    if (theme == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }
  return ThemeMode.system;
});
