// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/geolocation.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapSample extends StatefulWidget {
//   const MapSample({super.key});

//   @override
//   State<MapSample> createState() => MapSampleState();
// }

// class MapSampleState extends State<MapSample> {
//   // ignore: prefer_final_fields
//   Completer<GoogleMapController> _controller = Completer();

//   late Future<Position> myLatLng;

//   // Set<Circle> circles = Set.from([
//   //   Circle(
//   //     circleId: CircleId("aaa"),
//   //     fillColor: Color.fromARGB(76, 248, 11, 11),
//   //     center: LatLng(37.43296265331129, -122.08832357078792),
//   //     radius: 4000,
//   //     strokeColor: Colors.red,
//   //   )
//   // ]);

//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );

//   static final CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);

//   @override
//   void initState() {
//     super.initState();
//     myLatLng = determinePosition();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           tooltip: 'Navigation menu',
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text("GoogleMap"),
//       ),
//       body: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//         // circles: circles,
//         myLocationButtonEnabled: false,
//         myLocationEnabled: false,
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: Text('To the lake!'),
//         icon: Icon(Icons.directions_boat),
//       ),
//     );
//   }

//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:google_map_polyline_new/google_map_polyline_new.dart';

class MapSample extends StatefulWidget {
  final LatLng destLatLng;

  const MapSample({super.key, required this.destLatLng});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MapSample> {
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController _controller;
  bool isTracking = true;
  Location _location = Location();
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyB_hYyBb6cUlLyxi384Iv_clz_AA2iiuoQ");

  final Set<Polyline> _polyline = {};
  final Set<Marker> _markers = {};
  late final Future<List<LatLng>?> _futureRoute;
  final List<LatLng> routeCoords = [];

  Future<void> _calculateRoute() async {
    final origin = await _location.getLocation();
    for (var pos in ((await googleMapPolyline.getCoordinatesWithLocation(
            origin: LatLng(origin.latitude ?? 0, origin.longitude ?? 0),
            destination: widget.destLatLng,
            mode: RouteMode.driving)) ??
        [])) {
      routeCoords.add(pos);
    }
    ;

    _polyline.add(Polyline(
        polylineId: PolylineId('iter'),
        visible: true,
        points: routeCoords,
        width: 4,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const LatLng target = LatLng(36.6843892, -121.5018477);

    _markers.add(
        // added markers
        Marker(
      markerId: MarkerId('target'),
      position: target,
      infoWindow: InfoWindow(
        title: 'HOTEL',
        snippet: '5 Star Hotel',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    _polyline.add(Polyline(
      polylineId: PolylineId('1'),
      points: [target],
      color: Colors.green,
    ));
  }

  void _tracking() {
    _location.onLocationChanged.listen((LocationData l) {
      if (!isTracking) {
        return;
      }
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(l.latitude ?? 0.0, l.longitude ?? 0.0),
            zoom: 15,
          ),
        ),
      );
    });
  }

  void _initRouting() {
    var _futureMyLocation = _location.getLocation();
    _futureRoute = googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(40.677939, -73.941755),
        destination: LatLng(40.698432, -73.924038),
        mode: RouteMode.driving);
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _initRouting();
    _tracking();
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
        title: Text("map sample"),
      ),
      body: FutureBuilder<void>(
          future: _calculateRoute(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Listener(
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _initialcameraposition,
                          zoom: 14.0,
                        ),
                        mapType: MapType.normal,
                        onMapCreated: _onMapCreated,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        markers: _markers,
                        polylines: _polyline,
                      ),
                      onPointerMove: ((event) {
                        isTracking = false;
                      }),
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
        onPressed: (() {
          isTracking = true;
        }),
        label: Text('Re-Center'),
        icon: Icon(Icons.directions_car),
      ),
    );
  }
}
