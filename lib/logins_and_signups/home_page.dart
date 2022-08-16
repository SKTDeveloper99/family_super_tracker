import 'package:family_tracker/logins_and_signups/signup_page.dart';
import 'package:family_tracker/main_pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'forgotPassword.dart';
// import 'signUp.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //crafting login page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView (
            child: Column(
              children: <Widget> [
                Image.asset('assets/family.jpg',scale: 2),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin:
                  const EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
                  child: TextField(
                    controller: emailController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      border:  OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  margin:
                  const EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                // Container(
                //   margin: const EdgeInsets.only(top: 5),
                //   child: GestureDetector(
                //     onTap: () {
                //       // Navigator.push(
                //       //   context,
                //       //   MaterialPageRoute(
                //       //       builder: (context) => const ForgotPassWordPage()),
                //       // );
                //     },
                //     child: const Text(
                //       "Forgot Password?",
                //       style: TextStyle(
                //           color: Colors.green, fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 20),
                  width: 200,
                  child: ElevatedButton(
                      child: const Text('Log In'),
                      onPressed: () {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text)
                            .then((value) {
                          print("Successfully Logged in!");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileScreen()),
                          );
                        }).catchError((error) {
                          print("Failed to log in!");
                          print(error.toString());
                        });
                      }
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: const Text(
                    "Create new Account",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}




