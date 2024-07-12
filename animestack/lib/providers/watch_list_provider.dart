import 'package:animestack/config/hive_db/watch_list_anime.dart';
import 'package:animestack/config/hive_db/watchlist_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WatchlistNotifier extends StateNotifier<List<WatchlistAnime>> {
  WatchlistNotifier() : super([]) {
    _loadWatchlist();
  }

  final _watchlistService = WatchlistServices();

  Future<void> _loadWatchlist() async {
    final watchlist = await _watchlistService.getWatchlist();
    state = watchlist;
  }

  Future<void> addToWatchlist(WatchlistAnime anime) async {
    await _watchlistService.addAnimeToWatchlist(anime);
    state = [...state, anime];
  }

  Future<void> removeFromWatchlist(String animeId) async {
    await _watchlistService.removeAnimeFromWatchlist(animeId);
    state = state.where((anime) => anime.id != animeId).toList();
  }

  Future<bool> isInWatchlist(String animeId) async {
    return await _watchlistService.isAlreadyInWatchlist(animeId);
  }

  Future<void> markAsWatched(String animeId, bool isWatched) async {
    _watchlistService.markAnimeAsWatched(animeId, isWatched);
    state = state.map((anime) {
      if (anime.id == animeId) {
        return WatchlistAnime(
          id: anime.id,
          title: anime.title,
          isWatched: !anime.isWatched,
        );
      }
      return anime;
    }).toList();
  }

  Future<void> deleteAllWatchedAnime() async {
    await _watchlistService.deleteAllWatchedAnime();
    state = state.where((anime) => !anime.isWatched).toList();
  }
}

final watchListProvider =
    StateNotifierProvider<WatchlistNotifier, List<WatchlistAnime>>(
  (ref) => WatchlistNotifier(),
);
