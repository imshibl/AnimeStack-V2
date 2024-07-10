import 'dart:async';
import 'dart:convert';

import 'package:animestack/models/anime_model.dart';

import 'package:animestack/providers/category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AnimeProvider extends AsyncNotifier<List<AnimeModel>> {
  @override
  FutureOr<List<AnimeModel>> build() {
    final category = ref.watch(randomCategoryProvider);
    return getAnimeList(category: category, pageNum: 1);
  }

  final String baseUrl = "https://kitsu.io/api/edge/anime";
  final client = http.Client();

  Future<List<AnimeModel>> getAnimeList(
      {required String category, required int pageNum}) async {
    List<AnimeModel> animeList = [];
    String url = "$baseUrl?page[offset]=$pageNum";

    switch (category) {
      case 'Show All':
        url = '$baseUrl?page[offset]=$pageNum';
        break;
      case 'Top Rated':
        url = '$baseUrl?sort=ratingRank&page[offset]=$pageNum';
        break;
      case 'Popular':
        url = '$baseUrl?sort=popularityRank&page[offset]=$pageNum';
        break;
      case 'Favorites':
        url = '$baseUrl?sort=-favoritesCount&page[offset]=$pageNum';
        break;
      case 'Movies':
        url =
            '$baseUrl?filter[subtype]=movie&sort=-userCount&page[offset]=$pageNum';
        break;
      case 'Most Watched':
        url =
            '$baseUrl?filter[subtype]=tv&sort=-userCount&page[offset]=$pageNum';
        break;
      default:
        url = '$baseUrl?page[offset]=$pageNum';
    }

    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];

      animeList =
          data.map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList();
    }

    return animeList;
  }
}

final animeProvider =
    AsyncNotifierProvider<AnimeProvider, List<AnimeModel>>(() {
  return AnimeProvider();
});
