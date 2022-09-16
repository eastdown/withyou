import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:withyou/screen/home.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser
        ?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Align(
                      alignment: Alignment.center,

                      child: Column(mainAxisAlignment: MainAxisAlignment.center,

                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3)
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *0.8,
                            child: Image.asset('asset/image/CSIS_logo.png'),),
                          Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.085,
                            child: ElevatedButton(
                                onPressed: signInWithGoogle,
                                child: Text("LOGIN", style: TextStyle( fontSize: 18)),
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(
                                    131, 90, 229, 1.0)),)
                            ),
                          ),
                        ],),)
                ));
          } else {
            return Home();
          }

        });
  }
}