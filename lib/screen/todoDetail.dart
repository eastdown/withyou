import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:withyou/screen/home.dart';

int postIndex = 0;

class ToDoDetail extends StatelessWidget {
  ToDoDetail({Key? key}) : super(key: key);

  var uid = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('ToDo').where('uid', isEqualTo: uid).snapshots(),
          //orderBy("date", descending: true).
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Text('${snapshot.data!.docs[0]['title']}'),
                  Text('${snapshot.data!.docs[0]['content']}'),
                ],
              ),
            )
          );
        },
      );
  }
}

