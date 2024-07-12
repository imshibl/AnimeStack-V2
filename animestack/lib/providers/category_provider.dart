import 'package:animestack/models/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryProvider = Provider<List<CategoryModel>>((ref) {
  const String image1 =
      "https://wallpapers.com/images/featured/bleach-anime-x5ildyvb7u41kblh.jpg";
  const String image2 =
      "https://cdn.oneesports.gg/cdn-data/2024/04/Anime_OnePiece_Zoro_Sword_Attack.jpg";

  const String image3 =
      "https://facts.net/wp-content/uploads/2023/05/Naruto.jpeg";

  const String image4 =
      "https://static1.cbrimages.com/wordpress/wp-content/uploads/2023/08/luffy-is-using-gear-5-in-one-piece.jpg";
  const String image5 =
      "https://www.hindustantimes.com/ht-img/img/2024/02/01/550x309/demon_slayer_season_3_release_1681007034048_1706805706378.jpg";
  const String image6 =
      "https://m.media-amazon.com/images/I/91DAr46SxwL._AC_UF1000,1000_QL80_.jpg";

  final category1 = CategoryModel(
    categoryName: CategoryType.topRated,
    categoryImage: image1,
  );
  final category2 = CategoryModel(
    categoryName: CategoryType.popular,
    categoryImage: image2,
  );
  final category3 = CategoryModel(
    categoryName: CategoryType.favorites,
    categoryImage: image3,
  );
  final category4 = CategoryModel(
    categoryName: CategoryType.mostWatched,
    categoryImage: image4,
  );
  final category5 = CategoryModel(
    categoryName: CategoryType.movies,
    categoryImage: image5,
  );
  final category6 = CategoryModel(
    categoryName: CategoryType.showAll,
    categoryImage: image6,
  );

  return [category1, category2, category3, category4, category5, category6];
});
