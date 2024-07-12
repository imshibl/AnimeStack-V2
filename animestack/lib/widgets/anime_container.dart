import 'package:animestack/utils/snack_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AnimeContainer extends StatelessWidget {
  const AnimeContainer({
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
        border: Border.all(
          color: Colors.black38,
        ),
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
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.7),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/ranking.png",
                            width: 20,
                          ),
                          Text(
                            ratingRank,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
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
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/icons/trending.png",
                                width: 28,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                popularityRank,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            showSnackBar(
                                context: context,
                                message: "Favorite Count: $favCount");
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                favCount,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
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
