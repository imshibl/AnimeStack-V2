import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CategoryContainer extends StatelessWidget {
  const CategoryContainer({
    super.key,
    required this.categoryImage,
    required this.categoryName,
  });

  final String categoryImage;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: categoryImage,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black
                .withOpacity(0.5), // Adjust opacity to your preference
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Center(
          child: Text(
            categoryName,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5),
          ),
        ),
      ],
    );
  }
}
