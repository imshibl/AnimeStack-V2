import 'package:hive/hive.dart';
part 'watch_list_anime.g.dart';

@HiveType(typeId: 0)
class WatchlistAnime extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(3)
  bool isWatched;

  WatchlistAnime({
    required this.id,
    required this.title,
    this.isWatched = false,
  });
}
