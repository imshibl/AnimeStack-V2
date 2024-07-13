import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AnimeDescriptionDialog extends StatelessWidget {
  const AnimeDescriptionDialog({
    super.key,
    required this.coverImage,
    required this.posterImage,
    required this.animeName,
    required this.animeDescription,
  });

  final String? coverImage;
  final String posterImage;
  final String animeName;
  final String animeDescription;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                width: double.infinity,
                height: 150,
                child: CachedNetworkImage(
                  imageUrl: coverImage ?? "",
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: posterImage,
                    fit: BoxFit.cover,
                    height: 150,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Column(
                  children: [
                    Text(
                      animeName,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(animeDescription),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
