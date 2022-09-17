import 'package:flutter/material.dart';
import 'package:withyou/screen/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:withyou/screen/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'App for the society';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot){
            if (snapshot.hasError){
              return Center(
                child: Text('error'),
              );}
            if(snapshot.connectionState == ConnectionState.done){
              _initFirebaseMessaging(context);
              _getToken();
              return LoginPage();
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
    );
  }
}
_getToken() async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  print("messaging.getToken(), ${await messaging.getToken()}");
}

_initFirebaseMessaging(BuildContext context){
  FirebaseMessaging.onMessage.listen((RemoteMessage event){
    print(event.notification!.title);
    print(event.notification!.body);
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(title:Text("알람"),
              content: Text(event.notification!.body!),
              actions:[
                TextButton(
                  child: Text("Ok"),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
}