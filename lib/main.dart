import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'album.dart';
import 'detail.dart';
import 'map.dart';
import 'yaoyao.dart';
import "search.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.yellow,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // bool isCollapsed = true;
  late Future<List<Album>> futureAlbum;

  final searchController = TextEditingController();

  // AnimationController _animationController;
  // Animation<double> _scaleAnimation;
  // Animation<double> _menuScaleAnimation;
  // Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();

    // _animationController = AnimationController(vsync: this, duration: duration);
    // _scaleAnimation =
    //     Tween<double>(begin: 1, end: 0.8).animate(_animationController);
    // _menuScaleAnimation =
    //     Tween<double>(begin: 0.5, end: 1).animate(_animationController);
    // _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
    //     .animate(_animationController);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  // void onMenuTap() {
  //   setState(() {
  //     if (isCollapsed)
  //       _animationController.forward();
  //     else
  //       _animationController.reverse();

  //     _animationController = !isCollapsed;
  //   });
  // }

  // void onMenuItemClicked() {
  //   setState(() {
  //     _animationController.reverse();
  //   });

  //   isCollapsed = !isCollapsed;
  // }

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
          icon: Icon(Icons.map),
          tooltip: 'Navigation menu',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => YaoTop(),
            ));
          },
        ),
        title: Text(widget.title),
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
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: FutureBuilder<List<Album>>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: [
                for (final album in snapshot.data!)
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      color: Colors.white10,
                      child: Image.network(album.thumbnail_url),
                    ),
                    onTap: () {
                      if (album.url != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyDetailPage(url: album.url),
                          ),
                        );
                      }
                      ;
                    },
                  )
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
/*         GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(1),
              color: Colors.white10,
              child: Image.network(
                  'https://pics.dmm.co.jp/mono/movie/adult/tksora417/tksora417ps.jpg'),
            ),
          ],
        ), */
      )),

//       body: Center(
//           // Center is a layout widget. It takes a single child and positions it
//           // in the middle of the parent.
//           child: FutureBuilder<List<Album>>(
//         future: futureAlbum,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return GridView.count(
//               primary: false,
//               padding: const EdgeInsets.all(20),
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               crossAxisCount: 2,
//               children: [
//                 for (final album in snapshot.data!)
//                   GestureDetector(
//                     child: Container(
//                       padding: const EdgeInsets.all(1),
//                       color: Colors.white10,
//                       child: Image.network(album.thumbnail_url),
//                     ),
//                     onTap: () {
//                       if (album.url != null) {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => MyDetailPage(url: album.url),
//                           ),
//                         );
//                       }
//                       ;
//                     },
//                   )
//               ],
//             );
//           } else if (snapshot.hasError) {
//             return Text('${snapshot.error}');
//           }

//           // By default, show a loading spinner.
//           return const CircularProgressIndicator();
//         },
// /*         GridView.count(
//           primary: false,
//           padding: const EdgeInsets.all(20),
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           crossAxisCount: 2,
//           children: <Widget>[
//             Container(
//               padding: const EdgeInsets.all(1),
//               color: Colors.white10,
//               child: Image.network(
//                   'https://pics.dmm.co.jp/mono/movie/adult/tksora417/tksora417ps.jpg'),
//             ),
//           ],
//         ), */
//       )),

      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          _searchDialogBuilder(context);
        }),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _searchDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search'),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Not yet'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Search!'),
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchPage(
                      keyword: searchController.text,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
