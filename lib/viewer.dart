import 'package:flutter/material.dart';

class MyViewer extends StatelessWidget {
  const MyViewer({super.key, required this.viewUrl});

  final String viewUrl;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: viewUrl,
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(200.0),
                minScale: 0.1,
                maxScale: 2.5,
                child: Image.network(viewUrl),
                clipBehavior: Clip.none,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Close',
          child: const Icon(Icons.close),
        ),
      ),
    );
  }
}
