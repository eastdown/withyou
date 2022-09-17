import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:withyou/tool/drawer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:withyou/screen/finder_home.dart';

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
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('HomeAutomatic').where('index', isEqualTo: "3").snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Image.asset('asset/withyou_logo.png', fit: BoxFit.fitHeight, height: 55),
              iconTheme: const IconThemeData(color: Colors.grey),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            drawer: DrawerForAll(),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Align(
                    child:Padding(
                        padding: EdgeInsets.only(top:20, left: 20),
                        child: Text("위치 보기", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
                    ),
                    alignment: Alignment.centerLeft,
                  ),


                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
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
                    ),),

                  Align(
                    child:Padding(
                        padding: EdgeInsets.only(top:20, left: 20),
                        child: Text("위도 경도 상세정보", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                    ),
                    alignment: Alignment.centerLeft,
                  ),

                  Align(
                    child:Padding(
                        padding: EdgeInsets.only(top:20, left: 20),
                        child: Text("파인더 근처 와이파이", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
                    ),
                    alignment: Alignment.centerLeft,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.green,
                      ),
                    ),
                    child: Text(
                      '${snapshot.data!.docs[0]['Wi5']}',
                      style: TextStyle(fontSize: 10.0),
                    ),
                  ),

                ],
              )
            )
        );
      },
    );

  }
}
