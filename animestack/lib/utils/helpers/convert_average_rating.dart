double convertAverageRating(String averageRatingStr) {
  double averageRating = double.parse(averageRatingStr);
  // Scale the rating from 0-100 to 0-10
  double ratingOutOf10 = (averageRating / 10).toDouble();

  String formattedRating = ratingOutOf10.toStringAsFixed(1);

  return double.parse(formattedRating);
}
