// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animestack/config/routes.dart';

import 'package:animestack/providers/anime_provider.dart';
import 'package:animestack/providers/category_provider.dart';
import 'package:animestack/providers/chat_provider.dart';
import 'package:animestack/providers/theme_provider.dart';

import 'package:animestack/utils/helpers/convert_average_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiChatProvider.notifier).loadAiChat();
    });
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
                  leading: Icon(Icons.light_mode),
                  trailing: Switch(
                    value: ref.read(themeProvider) == ThemeMode.dark,
                    onChanged: (value) {
                      ref.read(themeProvider.notifier).state =
                          value ? ThemeMode.dark : ThemeMode.light;
                      var themeBox = Hive.box('themeBox');
                      themeBox.put(
                          'theme', value ? ThemeMode.dark : ThemeMode.light);
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
          ref.refresh(animeProvider);
          return Future<void>.value();
        },
        child: SingleChildScrollView(
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
                                  return Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  posterImage,
                                                  height: 150,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      animeName,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      "TV show",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    ),
                                                    Text(
                                                      "$rating/10",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ));
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
    );
  }
}
