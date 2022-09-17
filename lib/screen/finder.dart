import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:withyou/tool/drawer.dart';

class Finder extends StatefulWidget {
  const Finder({Key? key}) : super(key: key);

  @override
  State<Finder> createState() => _FinderState();
}

class _FinderState extends State<Finder> {
  late GoogleMapController mapController;

  static const LatLng _center = const LatLng(35.521563, -109.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        ),
      drawer: DrawerForAll(),
      body: SizedBox(
        width: 200,
        height: 400,
        child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 13.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId("source"),
            position: _center,
          ),
        },
      ),)
      );
  }
}
