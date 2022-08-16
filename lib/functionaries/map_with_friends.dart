import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const _pinkHue = 350.0;

class ShowFriends extends StatefulWidget {
  const ShowFriends({Key? key}) : super(key: key);

  @override
  State<ShowFriends> createState() => _ShowFriendsState();
}

class _ShowFriendsState extends State<ShowFriends> {
  late List keys = [];
  late List usernames = [];
  final Set<Marker> markers = {};
  var ref = FirebaseDatabase.instance.ref().child("friends/${FirebaseAuth.instance.currentUser?.uid}");
  final ref1 = FirebaseDatabase.instance.ref().child("users/");
  final Completer<GoogleMapController> _mapController = Completer();
  var friendsProfile;
  var usernameOutput;
  var latitudeOutput;
  var longitudeOutput;

  void getKeys() async {
    ref.onValue.listen((event) {
      final love = Map<String,dynamic>.from(event.snapshot.value as Map);
      keys = love.keys.toList();
      });
  }

  @override
  Widget build(BuildContext context) {
    getKeys();
    return Scaffold(
      appBar: AppBar(
          title: const Text(""),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: StreamBuilder(
          stream: ref1.orderByKey().onValue,
          builder: (context, snapshot) {
           if(snapshot.hasData) {
             final tilesList = <ListTile> [];
             final allUsers = Map<String,dynamic>.from(
                 (snapshot.data! as DatabaseEvent).snapshot.value as Map);
             for (int i = 0; i < keys.length; i++) {
               if (allUsers.keys.contains(keys[i])) {
                     final nextMarker = Marker(
                       markerId: MarkerId(allUsers[keys[i]]['uid'] as String),//document['placeID'] as String
                       icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
                       position: LatLng(
                         allUsers[keys[i]]['latitude'],
                         allUsers[keys[i]]['longitude'],
                       ),
                       infoWindow: InfoWindow(
                         title: allUsers[keys[i]]['username'] as String, //document['name'] as String
                         snippet: allUsers[keys[i]]['description'] as String, //document['address'] as String
                       ),
                     );
                 final nextTile = ListTile(
                   leading: const Icon(Icons.people),
                   title: Text("${allUsers[keys[i]]['username']}"),
                   subtitle: Text("${allUsers[keys[i]]['latitude']}, ${allUsers[keys[i]]['longitude']}"),
                 );
                 tilesList.add(nextTile);
                 markers.add(nextMarker);
               }
             }
             return Column(
               children:  [
                  Flexible(
                      flex: 3,
                     child: StoreMap(
                       markerSets: markers,
                       initialPosition: const LatLng(37.7786, -122.4375),
                       mapController: _mapController,
                     )
                 ),
                 Flexible(
                   flex: 2,
                   child: MediaQuery.removePadding(
                     context: context,
                     removeTop: true,
                     child: ListView(
                       children: tilesList,
                     ),
                   ),
                 ),
               ],
             );
           } else {
             return const Center(
               child: CircularProgressIndicator(),
             );
           }
          }
          ),
    );
  }
}

class StoreMap extends StatelessWidget {

  const StoreMap({
    Key? key,
    required this.markerSets,
    required this.initialPosition,
    required this.mapController,
  }) : super(key: key);

  final LatLng initialPosition;
  final Completer<GoogleMapController> mapController;
  final Set<Marker> markerSets;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 12,
        ),
        markers: markerSets,

        onMapCreated: (mapController) {
          this.mapController.complete(mapController);
        }
    );
  }
}


