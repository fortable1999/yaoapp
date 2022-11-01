import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'yaoApi.dart';

class CreateYaoJob extends StatefulWidget {
  late String title;
  late String description;

  CreateYaoJob({super.key, required this.title, required this.description});

  @override
  _CreateYaoJobState createState() => _CreateYaoJobState();
}

class _CreateYaoJobState extends State<CreateYaoJob> {
  late LatLng currentLatLng;
  Set<Marker> _yaoJobMarkers = {};
  late GoogleMapController _controller;
  Location _location = Location();

  Future<LatLng> _getCurrentLocation() async {
    final currentLocationData = await _location.getLocation();
    currentLatLng = LatLng(
      currentLocationData.latitude ?? 0,
      currentLocationData.longitude ?? 0,
    );

    return currentLatLng;
  }

  void _onMapCreated(GoogleMapController _cntlr) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("募集一个摇人"),
      ),
      body: FutureBuilder<void>(
          future: _getCurrentLocation(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Listener(
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: currentLatLng,
                          zoom: 14.0,
                        ),
                        onTap: (LatLng tapLatLng) {
                          // _yaoJobMarkers.clear();
                          _yaoJobMarkers.add(Marker(
                            markerId: MarkerId('new marker'),
                            position: tapLatLng,
                          ));
                          setState(() {});
                        },
                        mapType: MapType.normal,
                        onMapCreated: _onMapCreated,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        markers: _yaoJobMarkers,
                      ),
                      onPointerMove: ((event) {}),
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return Text('正在获取您的位置...');
            }
          })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (() async {
          final newYaoJob = YaoJob(
              widget.title,
              widget.description,
              _yaoJobMarkers.last.position.latitude,
              _yaoJobMarkers.last.position.longitude);
          await createYaoJobs(newYaoJob);
          Navigator.pop(context);
          Navigator.pop(context);
        }),
        label: Text('我要摇人'),
        icon: Icon(Icons.handshake),
      ),
    );
  }
}
