import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:animestack/models/anime_model.dart';

import 'package:animestack/providers/helper_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class RandomAnimeProvider extends AsyncNotifier<List<AnimeModel>> {
  int _currentPage = 1;
  @override
  FutureOr<List<AnimeModel>> build() {
    int randomPage = Random().nextInt(1000) + 1;
    _currentPage = randomPage;
    return getAnimeList(pageNum: _currentPage);
  }

  Future<List<AnimeModel>> getAnimeList({required int pageNum}) async {
    List<AnimeModel> animeList = [];

    String baseUrl = ref.read(baseUrlProvider);
    String url = "$baseUrl?page[offset]=$pageNum";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];

      animeList =
          data.map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList();
    }

    return animeList;
  }

  Future<void> showMoreAnime() async {
    List<AnimeModel> animeList = [];

    String baseUrl = ref.read(baseUrlProvider);
    int randomPage = Random().nextInt(1000) + _currentPage;
    _currentPage = randomPage;
    String url = "$baseUrl?page[offset]=$_currentPage";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];

      animeList =
          data.map<AnimeModel>((json) => AnimeModel.fromJson(json)).toList();
    }

    state = AsyncValue.data([...state.value!, ...animeList]);
  }
}

final randomAnimeProvider =
    AsyncNotifierProvider<RandomAnimeProvider, List<AnimeModel>>(() {
  return RandomAnimeProvider();
});
