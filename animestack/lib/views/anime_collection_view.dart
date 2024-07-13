// ignore_for_file: prefer_const_constructors

import 'package:animestack/config/hive_db/watch_list_anime.dart';
import 'package:animestack/models/category_model.dart';
import 'package:animestack/providers/category_provider.dart';
import 'package:animestack/providers/helper_providers.dart';
import 'package:animestack/providers/sorted_anime_provider.dart';
import 'package:animestack/providers/watch_list_provider.dart';
import 'package:animestack/utils/helpers/convert_average_rating.dart';
import 'package:animestack/widgets/grid_anime_container.dart';
import 'package:animestack/widgets/list_anime_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AnimeCollectionView extends ConsumerStatefulWidget {
  const AnimeCollectionView({super.key});

  @override
  ConsumerState<AnimeCollectionView> createState() =>
      _AnimeCollectionViewState();
}

class _AnimeCollectionViewState extends ConsumerState<AnimeCollectionView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.read(selectedCategoryProvider);
    String categoryName = selectedCategory!.displayName;
    if (selectedCategory == CategoryType.showAll) {
      categoryName = "All";
    }

    final isGridView = ref.watch(gridViewProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
          actions: [
            IconButton(
              onPressed: () {
                ref.read(gridViewProvider.notifier).state = !isGridView;
                var viewTypeBox = Hive.box("viewTypeBox");
                viewTypeBox.put("isGridView", !isGridView);
              },
              icon: isGridView
                  ? Icon(Icons.list_alt_outlined)
                  : Icon(Icons.grid_view_outlined),
            ),
          ],
        ),
        body: Consumer(builder: (context, ref, _) {
          final sortedAnimeList = ref.watch(sortedAnimeProvider);
          return sortedAnimeList.when(data: (data) {
            return isGridView
                ? CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.all(10),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.6,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final animeName = data[index].title;
                              final posterImage = data[index].posterImage;
                              final rating =
                                  convertAverageRating(data[index].rating);
                              final type = data[index].subType;
                              final ageRating = data[index].ageRating;
                              final status = data[index].status;
                              final popularityRank = data[index].popularityRank;
                              final favCount = data[index].favoritesCount;
                              final ratingRank =
                                  data[index].ratingRank != "null"
                                      ? data[index].ratingRank
                                      : "N/A";

                              Future<bool> isAnimeAlreadyInWatchlist = ref
                                  .read(watchListProvider.notifier)
                                  .isInWatchlist(data[index].title);

                              return GridAnimeContainer(
                                posterImage: posterImage,
                                title: animeName,
                                rating: rating.toString(),
                                subType: type,
                                ageRating: ageRating,
                                status: status,
                                popularityRank: popularityRank,
                                ratingRank: ratingRank,
                                favCount: favCount,
                                onMenuIconPressed:
                                    (BuildContext context) async {
                                  // Find the RenderBox of the GridAnimeContainer
                                  final RenderBox renderBox =
                                      context.findRenderObject() as RenderBox;
                                  final position =
                                      renderBox.localToGlobal(Offset.zero);
                                  final size = renderBox.size;
                                  ref.watch(watchListProvider);
                                  showMenu(
                                      context: context,
                                      position: RelativeRect.fromLTRB(
                                        position.dx +
                                            size.width -
                                            40, // Right align the menu
                                        position.dy +
                                            40, // Position below the icon
                                        position.dx + size.width,
                                        position.dy + size.height,
                                      ),
                                      items: [
                                        PopupMenuItem(
                                          value: 1,
                                          child: await isAnimeAlreadyInWatchlist
                                              ? Text("Remove from watchlist")
                                              : Text("Add to watchlist"),
                                          onTap: () async {
                                            if (await isAnimeAlreadyInWatchlist) {
                                              ref
                                                  .read(watchListProvider
                                                      .notifier)
                                                  .removeFromWatchlist(
                                                      data[index].title);
                                            } else {
                                              WatchlistAnime anime =
                                                  WatchlistAnime(
                                                      id: data[index].title,
                                                      title: data[index].title);
                                              ref
                                                  .read(watchListProvider
                                                      .notifier)
                                                  .addToWatchlist(anime);
                                            }
                                          },
                                        ),
                                      ]);
                                },
                              );
                            },
                            childCount: data.length,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            ref
                                .read(sortedAnimeProvider.notifier)
                                .showMoreAnime(
                                  category: ref.read(selectedCategoryProvider),
                                );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Show more",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final animeName = data[index].title;
                      final posterImage = data[index].posterImage;
                      final rating = convertAverageRating(data[index].rating);
                      final type = data[index].subType;
                      final ageRating = data[index].ageRating;
                      final status = data[index].status;
                      final popularityRank = data[index].popularityRank;
                      final favCount = data[index].favoritesCount;
                      final ratingRank = data[index].ratingRank != "null"
                          ? data[index].ratingRank
                          : "N/A";

                      Future<bool> isAnimeAlreadyInWatchlist = ref
                          .read(watchListProvider.notifier)
                          .isInWatchlist(data[index].title);

                      return Column(
                        children: [
                          ListAnimeContainer(
                            posterImage: posterImage,
                            ratingRank: ratingRank,
                            animeName: animeName,
                            type: type,
                            ageRating: ageRating,
                            rating: rating,
                            status: status,
                            popularityRank: popularityRank,
                            favCount: favCount,
                            onMenuIconPressed: (BuildContext context) async {
                              // Find the RenderBox of the GridAnimeContainer
                              final RenderBox renderBox =
                                  context.findRenderObject() as RenderBox;
                              final position =
                                  renderBox.localToGlobal(Offset.zero);
                              final size = renderBox.size;
                              ref.watch(watchListProvider);
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
                                      child: await isAnimeAlreadyInWatchlist
                                          ? Text("Remove from watchlist")
                                          : Text("Add to watchlist"),
                                      onTap: () async {
                                        if (await isAnimeAlreadyInWatchlist) {
                                          ref
                                              .read(watchListProvider.notifier)
                                              .removeFromWatchlist(
                                                  data[index].title);
                                        } else {
                                          WatchlistAnime anime = WatchlistAnime(
                                              id: data[index].title,
                                              title: data[index].title);
                                          ref
                                              .read(watchListProvider.notifier)
                                              .addToWatchlist(anime);
                                        }
                                      },
                                    ),
                                  ]);
                            },
                          ),
                          if (index == data.length - 1)
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(sortedAnimeProvider.notifier)
                                    .showMoreAnime(
                                      category:
                                          ref.read(selectedCategoryProvider),
                                    );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "Show more",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                        ],
                      );
                    });
          }, error: (error, stacktrace) {
            return Center(child: Text(error.toString()));
          }, loading: () {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
        }));
  }
}
