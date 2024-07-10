class AnimeModel {
  final String title;
  final String description;
  final String posterImage;
  final String rating;
  final String subType;
  final String ageRating;
  final String status;
  final String? coverImage;

  AnimeModel({
    required this.title,
    required this.description,
    required this.posterImage,
    required this.rating,
    required this.subType,
    required this.ageRating,
    required this.status,
    this.coverImage,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];
    final titles = attributes['titles'] ?? {};
    return AnimeModel(
      title: titles['en'] ?? titles['en_jp'] ?? attributes['slug'],
      description: attributes['description'] ?? '',
      posterImage: attributes['posterImage']['small'],
      rating: attributes['averageRating'] ?? '0',
      subType: attributes['subtype'] ?? '',
      ageRating: attributes['ageRating'] ?? '',
      status: attributes['status'] ?? '',
      coverImage: attributes['coverImage']?['original'],
    );
  }
}
