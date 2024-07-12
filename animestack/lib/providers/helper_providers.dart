import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final baseUrlProvider = Provider<String>((ref) {
  return "https://kitsu.io/api/edge/anime";
});

final aiChatBaseUrlProvider = Provider<String>((ref) {
  return "https://animestack-v2.onrender.com/";
});

final fabVisibilityProvider = StateProvider<bool>((ref) => false);

final gridViewProvider = StateProvider<bool>((ref) {
  final viewTypeBox = Hive.box("viewTypeBox");
  bool isGridView = viewTypeBox.get("isGridView", defaultValue: false);
  return isGridView;
});
