import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'album.dart';
import 'detail.dart';
import 'viewer.dart';

class MyDetailPage extends StatefulWidget {
  const MyDetailPage({super.key, required this.url});

  final String url;

  @override
  State<MyDetailPage> createState() => _MyDetailPage();
}

class _MyDetailPage extends State<MyDetailPage> {
  late Future<AlbumDetail> futureAlbumDetail;

  @override
  void initState() {
    super.initState();
    futureAlbumDetail = fetchAlbumDetail(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Navigation menu',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.url),
      ),
      body: GestureDetector(
        child: FutureBuilder<AlbumDetail>(
          future: futureAlbumDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    color: Colors.white10,
                    child: Image.network(snapshot.data!.coverUrl),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            MyViewer(viewUrl: snapshot.data!.coverUrl),
                      ),
                    );
                  },
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final snapshotUrl in snapshot.data!.snapshopUrl)
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            color: Colors.white10,
                            child: Image.network(snapshotUrl),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MyViewer(
                                    viewUrl: snapshotHugeUrl(snapshotUrl)),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ]);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return Text('Loading...');
            }
          },
        ),
        onTap: () {},
      ),
    );
  }
}
