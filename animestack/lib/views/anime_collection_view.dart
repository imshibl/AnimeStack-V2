// ignore_for_file: prefer_const_constructors

import 'package:animestack/models/category_model.dart';
import 'package:animestack/providers/category_provider.dart';
import 'package:animestack/providers/sorted_anime_provider.dart';
import 'package:animestack/utils/helpers/convert_average_rating.dart';
import 'package:animestack/widgets/anime_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.grid_view_outlined),
            ),
          ],
        ),
        body: Consumer(builder: (context, ref, _) {
          final sortedAnimeList = ref.watch(sortedAnimeProvider);
          return sortedAnimeList.when(data: (data) {
            return ListView.builder(
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
                  final ratingRank = data[index].ratingRank != "null"
                      ? data[index].ratingRank
                      : "N/A";
                  final favCount = data[index].favoritesCount;
                  return Column(
                    children: [
                      AnimeContainer(
                          posterImage: posterImage,
                          ratingRank: ratingRank,
                          animeName: animeName,
                          type: type,
                          ageRating: ageRating,
                          rating: rating,
                          status: status,
                          popularityRank: popularityRank,
                          favCount: favCount),
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
                                margin: EdgeInsets.all(5),
                                child: Text("Show more"))),
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
