import 'package:family_tracker/main_pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({Key? key}) : super(key: key);

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final ref = FirebaseDatabase.instance.ref().child("friends/");
  final ref1 = FirebaseDatabase.instance.ref().child("users/");

  @override
  Widget build(BuildContext context) {
    var friendsUID1;
    var friendsProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Friend test !"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: nameController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:'Name',
                )
            ),
            TextField(
                controller: emailController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:'Email',
                )
            ),
            ElevatedButton(
                child: const Text("Add Friend"),
                onPressed: () {
                  ref1.orderByChild("email").equalTo(emailController.text).onValue.listen((event) {
                    friendsProfile = event.snapshot.value;
                    final cardList = Map<String,dynamic>.from(friendsProfile);
                    cardList.forEach((key, value) {
                      final nextCard = Map<String,dynamic>.from(value);
                      var friendsUID = nextCard['uid'];
                      //print(friendsUID);
                      friendsUID1 = friendsUID ;
                    });
                    DatabaseReference listPush= FirebaseDatabase.instance.ref().child("friends/$uid");
                    listPush.update({
                      friendsUID1.toString(): "true",
                    });
                  });
                  const snackBar = SnackBar(
                    content: Text('You have successfully add this person!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const ProfileScreen()),
                  // );
                }),
          ],
        ),
      ),
    );
  }
}

