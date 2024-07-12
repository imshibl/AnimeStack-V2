import 'package:animestack/providers/watch_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WatchlistView extends ConsumerWidget {
  const WatchlistView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchList = ref.watch(watchListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: watchList.isEmpty
          ? const Center(
              child: Text("No anime in watchlist"),
            )
          : ListView.builder(
              itemCount: watchList.length,
              itemBuilder: (context, index) {
                final anime = watchList[index];
                return ListTile(
                  title: Text(
                    anime.title,
                    style: TextStyle(
                        decoration: anime.isWatched
                            ? TextDecoration.lineThrough
                            : null),
                  ),
                  leading: Checkbox(
                    value: anime.isWatched,
                    onChanged: (value) {
                      ref
                          .read(watchListProvider.notifier)
                          .markAsWatched(anime.id, value!);
                    },
                  ),
                  trailing: anime.isWatched
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            ref
                                .read(watchListProvider.notifier)
                                .removeFromWatchlist(anime.id);
                          },
                        )
                      : null,
                );
              },
            ),
    );
  }
}
