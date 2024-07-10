// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animestack/config/routes.dart';

import 'package:animestack/providers/anime_provider.dart';
import 'package:animestack/providers/category_provider.dart';
import 'package:animestack/providers/chat_provider.dart';

import 'package:animestack/utils/helpers/convert_average_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(aiChatProvider.notifier).loadAiChat();
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
      drawer: Drawer(),
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
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ]),
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
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text("TV show"),
                                                    Text("$rating/10"),
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
