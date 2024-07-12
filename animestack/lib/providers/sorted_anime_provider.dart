import 'dart:async';
import 'dart:convert';

import 'package:animestack/models/anime_model.dart';
import 'package:animestack/models/category_model.dart';
import 'package:animestack/providers/category_provider.dart';

import 'package:animestack/providers/helper_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class SortedAnimeProvider extends AsyncNotifier<List<AnimeModel>> {
  int _currentPage = 0;

  @override
  FutureOr<List<AnimeModel>> build() {
    _currentPage = 0;
    final CategoryType? selectedCategory = ref.watch(selectedCategoryProvider);
    return getAnimeList(pageNum: _currentPage, category: selectedCategory);
  }

  Future<List<AnimeModel>> getAnimeList(
      {required int pageNum, required CategoryType? category}) async {
    List<AnimeModel> animeList = [];

    String url = getUrl(
        baseUrl: ref.read(baseUrlProvider),
        category: category,
        pageNum: pageNum);

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];

      animeList =
          data.map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList();
    }

    return animeList;
  }

  Future<void> showMoreAnime({required CategoryType? category}) async {
    List<AnimeModel> animeList = [];

    _currentPage = _currentPage + 10;
    String url = getUrl(
        baseUrl: ref.read(baseUrlProvider),
        category: category,
        pageNum: _currentPage);

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];

      animeList =
          data.map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList();
    }

    state = AsyncValue.data([...state.value!, ...animeList]);
  }

  String getUrl(
      {required String baseUrl,
      required CategoryType? category,
      required int pageNum}) {
    String url = baseUrl;

    switch (category) {
      case CategoryType.showAll:
        url = '$baseUrl?page[offset]=$pageNum';
        break;
      case CategoryType.topRated:
        url = '$baseUrl?sort=ratingRank&page[offset]=$pageNum';
        break;
      case CategoryType.popular:
        url = '$baseUrl?sort=popularityRank&page[offset]=$pageNum';
        break;
      case CategoryType.favorites:
        url = '$baseUrl?sort=-favoritesCount&page[offset]=$pageNum';
        break;
      case CategoryType.movies:
        url =
            '$baseUrl?filter[subtype]=movie&sort=-userCount&page[offset]=$pageNum';
        break;
      case CategoryType.mostWatched:
        url =
            '$baseUrl?filter[subtype]=tv&sort=-userCount&page[offset]=$pageNum';
        break;
      default:
        url = '$baseUrl?page[offset]=$pageNum';
    }

    return url;
  }
}

final sortedAnimeProvider =
    AsyncNotifierProvider<SortedAnimeProvider, List<AnimeModel>>(() {
  return SortedAnimeProvider();
});
