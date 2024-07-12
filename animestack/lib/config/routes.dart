import 'package:animestack/views/anime_collection_view.dart';
import 'package:animestack/views/chat_view.dart';
import 'package:animestack/views/home_view.dart';
import 'package:animestack/views/search_view.dart';
import 'package:animestack/views/splash_view.dart';
import 'package:animestack/views/watchlist_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String watchlist = '/watchlist';
  static const String search = '/search';
  static const String animelist = '/animelist';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case home:
        return MaterialPageRoute(builder: (context) => const HomeView());
      case chat:
        return MaterialPageRoute(builder: (context) => const ChatView());
      case watchlist:
        return MaterialPageRoute(builder: (context) => const WatchlistView());
      case search:
        return MaterialPageRoute(builder: (context) => const SearchView());
      case animelist:
        return MaterialPageRoute(
            builder: (context) => const AnimeCollectionView());
      default:
        return MaterialPageRoute(builder: (context) => const SplashView());
    }
  }
}
