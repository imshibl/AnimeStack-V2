import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeProvider = StateProvider<ThemeMode>((ref) {
  var themeBox = Hive.box('themeBox');
  if (themeBox.get('theme') != null) {
    return themeBox.get('theme');
  }
  return ThemeMode.system;
});
