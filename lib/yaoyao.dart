import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/createYaoJob.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "map.dart";

import 'yaoApi.dart';

class YaoTop extends StatefulWidget {
  const YaoTop({super.key});

  @override
  State<YaoTop> createState() => _YaoTopState();
}

class _YaoTopState extends State<YaoTop> {
  late Future<List<YaoJob>> futureYaoJobs;

  List<TextEditingController> createYaoJobControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    super.initState();
    futureYaoJobs = fetchYaoJobs();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    for (final c in createYaoJobControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: IconButton(
          icon: Icon(Icons.refresh),
          tooltip: 'refresh',
          onPressed: () {
            futureYaoJobs = fetchYaoJobs();
            setState(() {});
          },
        ),
        title: Text("开心摇摇乐"),
      ),
      body: FutureBuilder<List<YaoJob>>(
        future: futureYaoJobs,
        builder: (((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                child: RefreshIndicator(
              color: Colors.white,
              backgroundColor: Colors.yellow,
              strokeWidth: 4.0,
              onRefresh: () async {
                // Replace this delay with the code to be executed during refresh
                // and return a Future when code finishs execution.
                // return Future<void>.delayed(const Duration(seconds: 3));
                futureYaoJobs = fetchYaoJobs();
                setState(() {});
              },
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  for (final job in snapshot.data!) YaoJobItem(yaoJob: job)
                ],
              ),
            )

                // By default, show a loading spinner.

                );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return Text('Loading...');
          }
        })),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (() {
          _dialogCreateYaoJobBuilder(context);
        }),
        label: Text('我要摇人'),
        icon: Icon(Icons.back_hand),
      ),
    );
  }

  Future<void> _dialogCreateYaoJobBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('请输入摇人信息'),
          content: Column(
            children: [
              const Text('标题'),
              TextField(
                controller: createYaoJobControllers[0],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '请输入一个标题',
                ),
              ),
              const Text('简介'),
              TextField(
                controller: createYaoJobControllers[1],
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '请输入一些简短的介绍',
                ),
              ),
            ],
          ),
          // const Text('A dialog is a type of modal window that\n'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                print(createYaoJobControllers[0].text);
                print(createYaoJobControllers[1].text);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateYaoJob(
                      title: createYaoJobControllers[0].text,
                      description: createYaoJobControllers[1].text,
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

class YaoJobItem extends StatelessWidget {
  final YaoJob yaoJob;
  const YaoJobItem({super.key, required this.yaoJob});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        _confirmDialogBuilder(context);
      }),
      child: Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: const BoxDecoration(color: Colors.yellow),
          child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: const EdgeInsets.only(right: 12.0),
                decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1.0, color: Colors.white24))),
                child: const Icon(Icons.directions_car, color: Colors.black87),
              ),
              title: Text(
                yaoJob.title,
                style: const TextStyle(
                    color: Color.fromARGB(210, 0, 0, 0),
                    fontWeight: FontWeight.bold),
              ),
              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

              subtitle: Row(
                children: const <Widget>[
                  Icon(Icons.linear_scale, color: Colors.black87),
                  Text(" 等待摇人", style: TextStyle(color: Colors.black87))
                ],
              ),
              trailing: const Icon(Icons.hail_rounded,
                  color: Colors.black87, size: 30.0)),
        ),
      ),
    );
  }

  Future<void> _confirmDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认被摇'),
          content: const Text('你确认接受此摇人吗？'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('我再想想'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('摇我！'),
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MapSample(
                        destLatLng: LatLng(yaoJob.latitude, yaoJob.longitude)),
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
