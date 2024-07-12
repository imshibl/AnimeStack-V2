// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animestack/config/routes.dart';

import 'package:animestack/providers/anime_provider.dart';
import 'package:animestack/providers/category_provider.dart';
import 'package:animestack/providers/chat_provider.dart';
import 'package:animestack/providers/helper_providers.dart';
import 'package:animestack/providers/theme_provider.dart';

import 'package:animestack/utils/helpers/convert_average_rating.dart';
import 'package:animestack/utils/snack_bar.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiChatProvider.notifier).loadAiChat();
    });

    _scrollController.addListener(() {
      if (_scrollController.offset >= 400) {
        ref.read(showBackToTopProvider.notifier).state = true;
      } else {
        ref.read(showBackToTopProvider.notifier).state = false;
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
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text("AnimeStack"),
        leading: IconButton(
          onPressed: () {
            globalKey.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.chat);
            },
            icon: Icon(Icons.chat_bubble_outline),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.bookmark_outline),
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
                  title: Text("Home"),
                  leading: Icon(Icons.home),
                ),
                ListTile(
                  title: Text("Watchlist"),
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  title: Text("Theme"),
                  leading: ref.read(themeProvider) == ThemeMode.dark
                      ? Icon(Icons.dark_mode)
                      : Icon(Icons.light_mode),
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
          Container(
            child: Text("AnimeStack"),
          ),
        ],
      )),
      body: RefreshIndicator(
        onRefresh: () {
          return ref.refresh(animeProvider.future);
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Builder(builder: (context) {
                  return Consumer(builder: (context, ref, _) {
                    final animeList = ref.watch(categoryProvider);
                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: animeList.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 2),
                      itemBuilder: (context, index) {
                        String categoryName = animeList[index].categoryName;
                        String categoryImage = animeList[index].categoryImage;
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  categoryImage,
                                ),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ]),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(
                                      0.5), // Adjust opacity to your preference
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Text(
                                categoryName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  });
                }),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Random Suggestions",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10),
                    Consumer(builder: (context, ref, _) {
                      final anime = ref.watch(animeProvider);
                      return anime.when(
                          data: (data) {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final animeName = data[index].title;
                                  final posterImage = data[index].posterImage;
                                  final rating =
                                      convertAverageRating(data[index].rating);
                                  final type = data[index].subType;
                                  final ageRating = data[index].ageRating;
                                  final status = data[index].status;
                                  final popularityRank =
                                      data[index].popularityRank;
                                  final ratingRank = data[index].ratingRank;
                                  return Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.black38,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.network(
                                                        posterImage,
                                                        height: 150,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.all(5),
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/icons/ranking.png",
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            ratingRank,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall!
                                                                .copyWith(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 10),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        animeName,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium,
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            type,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                          Text(
                                                            " - $ageRating",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "$rating",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color:
                                                                Colors.yellow,
                                                            size: 18,
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "Status: $status",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showSnackBar(
                                                              context: context,
                                                              message:
                                                                  "Popularity Rank: $popularityRank");
                                                        },
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Image.asset(
                                                              "assets/icons/trending.png",
                                                              width: 25,
                                                            ),
                                                            Text(
                                                              popularityRank,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.more_vert),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (index == data.length - 1)
                                        GestureDetector(
                                            onTap: () {
                                              ref
                                                  .read(animeProvider.notifier)
                                                  .showMoreAnime();
                                            },
                                            child: Container(
                                                margin: EdgeInsets.all(5),
                                                child: Text("Show more"))),
                                    ],
                                  );
                                });
                          },
                          error: (error, stackTrace) =>
                              Center(child: Text(error.toString())),
                          loading: () =>
                              Center(child: CircularProgressIndicator()));
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer(builder: (context, ref, _) {
        final showBackToTop = ref.watch(showBackToTopProvider);
        return showBackToTop
            ? FloatingActionButton(
                onPressed: () {
                  _scrollToTop();
                },
                child: Icon(Icons.arrow_upward_sharp),
              )
            : SizedBox();
      }),
    );
  }
}
