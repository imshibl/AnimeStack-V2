import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:animestack/models/anime_model.dart';

import 'package:animestack/providers/common_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AnimeProvider extends AsyncNotifier<List<AnimeModel>> {
  @override
  FutureOr<List<AnimeModel>> build() {
    int randomPage = Random().nextInt(1000) + 1;
    return getAnimeList(pageNum: randomPage);
  }

  Future<List<AnimeModel>> getAnimeList({required int pageNum}) async {
    List<AnimeModel> animeList = [];

    String baseUrl = ref.read(baseUrlProvider);
    String url = "$baseUrl?page[offset]=$pageNum";

    // switch (category) {
    //   case 'Show All':
    //     url = '$baseUrl?page[offset]=$pageNum';
    //     break;
    //   case 'Top Rated':
    //     url = '$baseUrl?sort=ratingRank&page[offset]=$pageNum';
    //     break;
    //   case 'Popular':
    //     url = '$baseUrl?sort=popularityRank&page[offset]=$pageNum';
    //     break;
    //   case 'Favorites':
    //     url = '$baseUrl?sort=-favoritesCount&page[offset]=$pageNum';
    //     break;
    //   case 'Movies':
    //     url =
    //         '$baseUrl?filter[subtype]=movie&sort=-userCount&page[offset]=$pageNum';
    //     break;
    //   case 'Most Watched':
    //     url =
    //         '$baseUrl?filter[subtype]=tv&sort=-userCount&page[offset]=$pageNum';
    //     break;
    //   default:
    //     url = '$baseUrl?page[offset]=$pageNum';
    // }

    final response = await http.get(Uri.parse(url));

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
