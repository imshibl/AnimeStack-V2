import 'package:flutter/material.dart';

class RatingRankBadge extends StatelessWidget {
  const RatingRankBadge({
    super.key,
    required this.ratingRank,
  });

  final String ratingRank;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class CountBadge extends StatelessWidget {
  const CountBadge({
    super.key,
    required this.imgIcon,
    required this.count,
  });

  final String imgIcon;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          "assets/icons/$imgIcon",
          width: 28,
        ),
        const SizedBox(width: 5),
        Text(
          count,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class TypeStatusContainer extends StatelessWidget {
  const TypeStatusContainer({
    super.key,
    required this.subType,
  });

  final String subType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.black.withOpacity(0.5),
      ),
      child: Text(
        subType,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
