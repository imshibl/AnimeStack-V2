// ignore_for_file: prefer_const_constructors

import 'package:animestack/config/hive_db/watch_list_anime.dart';
import 'package:animestack/providers/watch_list_provider.dart';
import 'package:animestack/widgets/anime_container_widgets.dart';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GridAnimeContainer extends ConsumerWidget {
  final String title;
  final String posterImage;
  final String rating;
  final String subType;
  final String ageRating;
  final String status;
  final String popularityRank;
  final String ratingRank;
  final String favCount;

  const GridAnimeContainer({
    super.key,
    required this.title,
    required this.posterImage,
    required this.rating,
    required this.subType,
    required this.ageRating,
    required this.status,
    required this.popularityRank,
    required this.ratingRank,
    required this.favCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(watchListProvider);
    Future<bool> isAnimeAlreadyInWatchlist =
        ref.read(watchListProvider.notifier).isInWatchlist(title);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: posterImage,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingRankBadge(ratingRank: ratingRank),
                  IconButton(
                    onPressed: () async {
                      // Find the RenderBox of the GridAnimeContainer
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      final position = renderBox.localToGlobal(Offset.zero);
                      final size = renderBox.size;

                      final isInWatchlist = await isAnimeAlreadyInWatchlist;

                      showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            position.dx +
                                size.width -
                                40, // Right align the menu
                            position.dy + 40, // Position below the icon
                            position.dx + size.width,
                            position.dy + size.height,
                          ),
                          items: [
                            PopupMenuItem(
                              value: 1,
                              child: Text(isInWatchlist
                                  ? "Remove from watchlist"
                                  : "Add to watchlist"),
                              onTap: () {
                                if (isInWatchlist) {
                                  ref
                                      .read(watchListProvider.notifier)
                                      .removeFromWatchlist(title);
                                } else {
                                  WatchlistAnime anime =
                                      WatchlistAnime(id: title, title: title);
                                  ref
                                      .read(watchListProvider.notifier)
                                      .addToWatchlist(anime);
                                }
                              },
                            ),
                          ]);
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: TypeStatusContainer(subType: status),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Row(
                  children: [
                    TypeStatusContainer(subType: subType),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(rating, style: const TextStyle(fontSize: 14)),
                    Spacer(),
                    Text(
                      subType,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CountBadge(imgIcon: "trending.png", count: popularityRank),
                    CountBadge(imgIcon: "heart.png", count: favCount),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
