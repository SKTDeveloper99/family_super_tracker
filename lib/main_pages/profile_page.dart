import 'package:family_tracker/functionaries/add_friend.dart';
import 'package:family_tracker/functionaries/change_name.dart';
import 'package:family_tracker/functionaries/gps_functions.dart';
import 'package:family_tracker/functionaries/map_with_friends.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  var userProfile;
  final db = FirebaseDatabase.instance.ref();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  var profilePic = '';
  var username = '';
  var location = '';

  String description = "";

  @override
  Widget build(BuildContext context) {
    String love;
    return Scaffold(
        backgroundColor: const Color(0xffdee2fe),
      body: Stack(
        children: [
          StreamBuilder(stream: db
              .child("users/$uid")
              .orderByKey()
              .onValue,
            builder: (context, snapshot) {
              final tilesList = {};
              if (snapshot.hasData) {
                final cardsList = Map<String, dynamic>.from(
                    (snapshot.data! as DatabaseEvent).snapshot.value as Map);
                for (dynamic type in cardsList.keys) {
                  tilesList[type] = cardsList[type];
                }
                love = tilesList['profilePic'].toString();
                var kiss = tilesList['username'].toString();
                var hug = tilesList['location'].toString();
                description = tilesList['description'].toString();
                profilePic = love;
                username = kiss;
                location = hug;
              }
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 20,
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            width: 95,
                            margin: const EdgeInsets.only(
                              top: 100,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 10,
                                ),
                              ],
                              image:  DecorationImage(
                                image: NetworkImage(profilePic),
                              fit: BoxFit.fill,
                              ),
                            ),
                          ),
                           GestureDetector(
                             onTap: (){
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => const ChangeName()),
                               );
                             },
                             child:
                               Text(
                                username,
                                style:  const TextStyle(
                                  fontFamily: "Montserrat",
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                          ),
                           ),
                          Text(
                            description,
                            style: const TextStyle(
                              fontFamily: "Montserrat",
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 20,
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 24,
                          right: 24,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Stack(
                          children:[
                            Positioned(
                              bottom:50,
                                right: 0,
                                child: FloatingActionButton(onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const TestMapLocation()),
                                  );
                                },
                                heroTag: "btn1",
                                child: const Icon(Icons.map,size: 30,),
                                )
                            ),
                            Positioned(
                                bottom:120,
                                right: 0,
                                child: FloatingActionButton(
                                  onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AddFriendPage()),
                                  );
                                },
                                  heroTag: "btn2",
                                  backgroundColor: const Color.fromRGBO(149, 53, 83, 1),
                                  child: const Icon(Icons.people,size: 30,),
                                )
                            ),
                            Positioned(
                                bottom:190,
                                right: 0,
                                child: FloatingActionButton(onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ShowFriends()),
                                  );
                                },
                                  heroTag: "btn3",
                                  backgroundColor: const Color.fromRGBO(219, 165, 30, 1.0),
                                  child: const Icon(Icons.location_on,size: 30,),
                                )
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "PROFILE",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                listProfile(Icons.person, "Username", username),
                                listProfile(Icons.date_range, "Date of Birth", "Placeholder"),
                                listProfile(Icons.location_pin, "Location", location),
                                listProfile(Icons.male, "Gender", "Placeholder"),
                                listProfile(Icons.phone, "Phone Number", "Placeholder"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
              );
            },
          ),
        ],
      ),
    );
  }


  Widget listProfile(IconData icon, String text1, String text2) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: "Montserrat",
                  fontSize: 14,
                ),
              ),
              Text(
                text2,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



