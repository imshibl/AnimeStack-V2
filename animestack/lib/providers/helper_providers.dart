import 'package:flutter_riverpod/flutter_riverpod.dart';

final baseUrlProvider = Provider<String>((ref) {
  return "https://kitsu.io/api/edge/anime";
});

final aiChatBaseUrlProvider = Provider<String>((ref) {
  return "https://animestack-v2.onrender.com/";
});

final showBackToTopProvider = StateProvider<bool>((ref) => false);
