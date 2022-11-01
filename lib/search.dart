import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'album.dart';
import 'detail.dart';
import 'map.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.keyword});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String keyword;

  @override
  State<SearchPage> createState() => _searchPageState();
}

class _searchPageState extends State<SearchPage> {
  late Future<List<Album>> futureAlbum;

  late String _sortedBy;
  int _page = 1;
  final int _limit = 20;
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  List _albums = [];

  late ScrollController _controller;

  @override
  void initState() {
    _sortedBy = "ranking";
    super.initState();

    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      _page += 1; // Increase _page by 1

      try {
        final List fetchedAlbums = await fetchAlbum(
          urlText:
              "https://www.dmm.co.jp/mono/dvd/-/search/=/searchstr=${widget.keyword}/sort=${_sortedBy}/page=$_page/",
        );

        if (fetchedAlbums.isNotEmpty) {
          setState(() {
            _albums.addAll(fetchedAlbums);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      final List fetchedAlbums = await fetchAlbum(
        urlText:
            "https://www.dmm.co.jp/mono/dvd/-/search/=/searchstr=${widget.keyword}/sort=${_sortedBy}/",
      );
      setState(() {
        _albums = fetchedAlbums;
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: IconButton(
          icon: Icon(Icons.list),
          tooltip: 'Navigation menu',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.keyword),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.yellow,
              ),
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 243, 229, 101),
                maxRadius: 30,
                child: ClipOval(
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                      "https://pics.dmm.co.jp/mono/actjpgs/hatano_yui.jpg"),
                ),
              ),
            ),
            ListTile(
              title: const Text('Popular Ranking'),
              onTap: () {
                Navigator.of(context).pop();
                _albums.clear();
                setState(() {
                  _sortedBy = "ranking";
                  _isFirstLoadRunning = false;
                  _hasNextPage = true;

                  _firstLoad();
                });
              },
            ),
            ListTile(
              title: const Text('Date Ranking'),
              onTap: () {
                Navigator.of(context).pop();
                _albums.clear();
                setState(() {
                  _sortedBy = "date";
                  _isFirstLoadRunning = false;
                  _hasNextPage = true;
                  print("rank: $_sortedBy");
                  _firstLoad();
                });
              },
            ),
            ListTile(
              title: const Text('Review Ranking'),
              onTap: () {
                Navigator.of(context).pop();
                _albums.clear();
                setState(() {
                  _sortedBy = "review_rank";
                  _isFirstLoadRunning = false;
                  _hasNextPage = true;
                  _firstLoad();
                });
              },
            ),
          ],
        ),
      ),
      body: _isFirstLoadRunning
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: _albums.length,
                    controller: _controller,
                    padding: const EdgeInsets.all(20),
                    itemBuilder: (_, index) => GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        color: Colors.white10,
                        child: Image.network(_albums[index].thumbnail_url),
                      ),
                      onTap: () {
                        if (_albums[index].url != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyDetailPage(url: _albums[index].url),
                            ),
                          );
                        }
                        ;
                      },
                    ),
                  ),
                ),
                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (_hasNextPage == false)
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    color: Colors.amber,
                    child: const Center(
                      child: Text('You have fetched all of the content'),
                    ),
                  ),
              ],
            )),
    );
  }
}
