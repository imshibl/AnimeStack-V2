import 'package:animestack/config/routes.dart';
import 'package:animestack/models/category_model.dart';

import 'package:animestack/providers/random_anime_provider.dart';
import 'package:animestack/providers/category_provider.dart';
import 'package:animestack/providers/chat_provider.dart';
import 'package:animestack/providers/helper_providers.dart';
import 'package:animestack/providers/theme_provider.dart';

import 'package:animestack/utils/helpers/convert_average_rating.dart';
import 'package:animestack/utils/helpers/package_info.dart';
import 'package:animestack/widgets/anime_description_dialog.dart';
import 'package:animestack/widgets/list_anime_container.dart';
import 'package:animestack/widgets/category_container.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(aiChatProvider.notifier).loadAiChat();
    });

    _scrollController.addListener(() {
      if (_scrollController.offset >= 400) {
        ref.read(fabVisibilityProvider.notifier).state = true;
      } else {
        ref.read(fabVisibilityProvider.notifier).state = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: const Text("AnimeStack"),
        leading: IconButton(
          onPressed: () {
            globalKey.currentState!.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.chat);
            },
            icon: const Icon(Icons.chat_bubble_outline),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.watchlist);
            },
            icon: const Icon(Icons.favorite_border_outlined),
          ),
        ],
      ),
      drawer: Drawer(
          child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text("Home"),
                  leading: const Icon(Icons.home_outlined),
                  onTap: () => globalKey.currentState!.closeDrawer(),
                ),
                ListTile(
                    title: const Text("Stack - AI Otaku friend"),
                    leading: const Icon(Icons.chat_bubble_outline),
                    onTap: () {
                      globalKey.currentState!.closeDrawer();
                      Navigator.of(context).pushNamed(AppRoutes.chat);
                    }),
                ListTile(
                  title: const Text("Watchlist"),
                  leading: const Icon(Icons.favorite_outline),
                  onTap: () {
                    globalKey.currentState!.closeDrawer();
                    Navigator.pushNamed(context, AppRoutes.watchlist);
                  },
                ),
                ListTile(
                  title: const Text("Theme"),
                  leading: ref.read(themeProvider) == ThemeMode.dark
                      ? const Icon(Icons.dark_mode_outlined)
                      : const Icon(Icons.light_mode_outlined),
                  trailing: Switch(
                    value: ref.read(themeProvider) == ThemeMode.dark,
                    onChanged: (value) {
                      ref.read(themeProvider.notifier).state =
                          value ? ThemeMode.dark : ThemeMode.light;
                      var themeBox = Hive.box('themeBox');
                      themeBox.put('theme', value ? "dark" : "light");
                    },
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: getVersionCode(),
              builder: (context, data) {
                if (data.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/stack_logo.png",
                          width: 60,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "AnimeStack",
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              "V${data.data}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              }),
        ],
      )),
      body: RefreshIndicator(
        onRefresh: () {
          return ref.refresh(randomAnimeProvider.future);
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Consumer(builder: (context, ref, _) {
                  final categoryList = ref.watch(categoryProvider);
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categoryList.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 2),
                    itemBuilder: (context, index) {
                      String categoryName =
                          categoryList[index].categoryName.displayName;
                      String categoryImage = categoryList[index].categoryImage;

                      return CategoryContainer(
                        categoryImage: categoryImage,
                        categoryName: categoryName,
                        onTap: () {
                          ref.read(selectedCategoryProvider.notifier).state =
                              categoryList[index].categoryName;
                          Navigator.pushNamed(context, AppRoutes.animelist);
                        },
                      );
                    },
                  );
                }),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Random Suggestions",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Consumer(builder: (context, ref, _) {
                      final randomAnimes = ref.watch(randomAnimeProvider);
                      return randomAnimes.when(
                          data: (data) {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final animeName = data[index].title;
                                  final animeDescription =
                                      data[index].description;
                                  final posterImage = data[index].posterImage;
                                  final coverImage = data[index].coverImage;
                                  final rating =
                                      convertAverageRating(data[index].rating);
                                  final type = data[index].subType;
                                  final ageRating = data[index].ageRating;
                                  final status = data[index].status;
                                  final popularityRank =
                                      data[index].popularityRank;
                                  final ratingRank =
                                      data[index].ratingRank != "null"
                                          ? data[index].ratingRank
                                          : "N/A";
                                  final favCount = data[index].favoritesCount;

                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AnimeDescriptionDialog(
                                                    coverImage: coverImage,
                                                    posterImage: posterImage,
                                                    animeName: animeName,
                                                    animeDescription:
                                                        animeDescription);
                                              });
                                        },
                                        child: ListAnimeContainer(
                                          posterImage: posterImage,
                                          ratingRank: ratingRank,
                                          animeName: animeName,
                                          type: type,
                                          ageRating: ageRating,
                                          rating: rating,
                                          status: status,
                                          popularityRank: popularityRank,
                                          favCount: favCount,
                                        ),
                                      ),
                                      if (index == data.length - 1)
                                        GestureDetector(
                                          onTap: () {
                                            ref
                                                .read(randomAnimeProvider
                                                    .notifier)
                                                .showMoreAnime();
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            child: const Text("Show more"),
                                          ),
                                        ),
                                    ],
                                  );
                                });
                          },
                          error: (error, stackTrace) =>
                              Center(child: Text(error.toString())),
                          loading: () => const Center(
                              child: CircularProgressIndicator.adaptive()));
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer(builder: (context, ref, _) {
        final isFabVisible = ref.watch(fabVisibilityProvider);
        return isFabVisible
            ? FloatingActionButton(
                onPressed: () {
                  _scrollToTop();
                },
                child: const Icon(Icons.arrow_upward_sharp),
              )
            : const SizedBox();
      }),
    );
  }
}
