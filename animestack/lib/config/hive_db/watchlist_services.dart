import 'package:animestack/config/hive_db/watch_list_anime.dart';
import 'package:hive/hive.dart';

class WatchlistServices {
  static const String boxName = "watchlist";

  Future<Box<WatchlistAnime>> get _box async =>
      await Hive.openBox<WatchlistAnime>(boxName);

  Future<void> addAnimeToWatchlist(WatchlistAnime anime) async {
    final box = await _box;
    await box.put(anime.id, anime);
  }

  Future<void> removeAnimeFromWatchlist(String animeId) async {
    final box = await _box;
    await box.delete(animeId);
  }

  Future<List<WatchlistAnime>> getWatchlist() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<bool> isAlreadyInWatchlist(String animeId) async {
    final box = await _box;
    return box.containsKey(animeId);
  }

  Future<void> markAnimeAsWatched(String animeId, bool isWatched) async {
    final box = await _box;
    final anime = box.get(animeId);
    if (anime != null) {
      anime.isWatched = isWatched;
      await box.put(animeId, anime);
    }
  }

  Future<void> deleteAllWatchedAnime() async {
    final box = await _box;
    final watchedAnimes =
        box.values.where((anime) => anime.isWatched).map((anime) => anime.id);
    await box.deleteAll(watchedAnimes);
  }
}
