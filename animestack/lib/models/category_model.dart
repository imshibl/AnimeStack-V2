class CategoryModel {
  final CategoryType categoryName;
  final String categoryImage;
  CategoryModel({required this.categoryName, required this.categoryImage});
}

enum CategoryType {
  topRated,
  popular,
  favorites,
  mostWatched,
  movies,
  showAll,
}

extension CategoryTypeExtension on CategoryType {
  String get displayName {
    switch (this) {
      case CategoryType.topRated:
        return 'Top Rated';
      case CategoryType.popular:
        return 'Popular';
      case CategoryType.favorites:
        return 'Favorites';
      case CategoryType.mostWatched:
        return 'Most Watched';
      case CategoryType.movies:
        return 'Movies';
      case CategoryType.showAll:
        return 'Show All';
    }
  }
}
