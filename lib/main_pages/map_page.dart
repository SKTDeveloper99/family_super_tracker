import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tracker/main_pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const _pinkHue = 350.0;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MapPageState createState() => MapPageState ();
}

class MapPageState extends State<MapPage> {
  late Stream<QuerySnapshot> _iceCreamStores;
  final Completer<GoogleMapController> _mapController = Completer();
  final uid = FirebaseAuth.instance.currentUser!.uid;


  @override
  void initState() {
    super.initState();
    _iceCreamStores = FirebaseFirestore.instance.collection('ice_cream_stores').orderBy('name').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              }),
          title: const Text('Friends Map'),
          backgroundColor: Colors.green[700],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _iceCreamStores,
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasError) {
              return Center(child: Text('Error : ${snapshot.error}'),);
            }
            if(!snapshot.hasData) {
              return const Center(child: Text('loading....'));
            }
            return Column(
              children: [
                Flexible(
                    flex: 2,
                    child: StoreMap(
                      documents: snapshot.data!.docs,
                      initialPosition: const LatLng(37.7786, -122.4375),
                      mapController: _mapController,
                    )
                ),
                Flexible(
                  flex: 2,
                  child: StoreList(
                    documents: snapshot.data!.docs,
                    mapController: _mapController,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
class StoreList extends StatelessWidget {
  const StoreList({
    super.key,
    required this.documents, required Completer<GoogleMapController> mapController,
  });

  final List<DocumentSnapshot> documents;
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: documents
            .map((DocumentSnapshot document) {
          Map<String, dynamic> data =
          document.data()! as Map<String, dynamic>;
          return ListTile(
            title: Text(data['name']),
            subtitle: Text(
              "${data['location'].latitude} , ${data['location'].longitude}",
            ),
          );
        })
            .toList()
            .cast()
    );

  }
}

class StoreMap extends StatelessWidget {
  const StoreMap({
    Key? key,
    required this.documents,
    required this.initialPosition,
    required this.mapController,
  }) : super(key: key);

  final List<DocumentSnapshot> documents;
  final LatLng initialPosition;
  final Completer<GoogleMapController> mapController;


  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 12,
        ),
        markers: documents
            .map((document) => Marker(
          markerId: MarkerId(document['placeID'] as String),//document['placeID'] as String
          icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
          position: LatLng(
            document['location'].latitude as double,
            document['location'].longitude as double,
            //document['location'].longitude as double,
          ),
          infoWindow: InfoWindow(
            title: document['name'] as String, //document['name'] as String
            snippet: document['address'] as String, //document['address'] as String
          ),
        )).toSet(),
        onMapCreated: (mapController) {
          this.mapController.complete(mapController);
        }
    );

  }

}