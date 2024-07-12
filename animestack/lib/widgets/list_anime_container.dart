import 'package:animestack/utils/snack_bar.dart';
import 'package:animestack/widgets/anime_container_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ListAnimeContainer extends StatelessWidget {
  const ListAnimeContainer({
    super.key,
    required this.posterImage,
    required this.ratingRank,
    required this.animeName,
    required this.type,
    required this.ageRating,
    required this.rating,
    required this.status,
    required this.popularityRank,
    required this.favCount,
  });

  final String posterImage;
  final String ratingRank;
  final String animeName;
  final String type;
  final String ageRating;
  final double rating;
  final String status;
  final String popularityRank;
  final String favCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: posterImage,
                      fit: BoxFit.cover,
                      height: 150,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showSnackBar(
                          context: context,
                          message: "Rating Rank: $ratingRank");
                    },
                    child: RatingRankBadge(ratingRank: ratingRank),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animeName,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          type,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          " - $ageRating",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "$rating",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 18,
                        ),
                      ],
                    ),
                    Text(
                      "Status: $status",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showSnackBar(
                                context: context,
                                message: "Popularity Rank: $popularityRank");
                          },
                          child: CountBadge(
                              imgIcon: "trending.png", count: popularityRank),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            showSnackBar(
                                context: context,
                                message: "Favorite Count: $favCount");
                          },
                          child:
                              CountBadge(imgIcon: "heart.png", count: favCount),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
