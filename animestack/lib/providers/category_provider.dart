import 'package:animestack/models/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryProvider = Provider<List<CategoryModel>>((ref) {
  const String image1 =
      "https://wallpapers.com/images/featured/bleach-anime-x5ildyvb7u41kblh.jpg";
  final category1 = CategoryModel(
    categoryName: "Top Rated",
    categoryImage: image1,
  );
  final category2 = CategoryModel(
    categoryName: "Popular",
    categoryImage: image1,
  );
  final category3 = CategoryModel(
    categoryName: "Favorites",
    categoryImage: image1,
  );
  final category4 = CategoryModel(
    categoryName: "Most Watched",
    categoryImage: image1,
  );
  final category5 = CategoryModel(
    categoryName: "Movies",
    categoryImage: image1,
  );
  final category6 = CategoryModel(
    categoryName: "Show All",
    categoryImage: image1,
  );

  return [category1, category2, category3, category4, category5, category6];
});
