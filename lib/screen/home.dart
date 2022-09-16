import 'package:flutter/material.dart';
import 'package:withyou/tool/drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:withyou/tool/todoAdd.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var uid = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      drawer: DrawerForAll(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30,),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 20)),
                TableCalendar(
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                ),
                Padding(padding: EdgeInsets.only(bottom:20)),
                Align(
                    child:Text('할 일'),
                  alignment: Alignment.centerLeft,
                ),
                Padding(padding: EdgeInsets.only(bottom:20)),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('ToDo').where('uid', isEqualTo: uid).snapshots(),
                  //orderBy("date", descending: true).
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                      return ListTile(
                        title: Text('One-line with trailing widget'),
                      );
                    });
                  }
                ),



              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            )
        ),),
      backgroundColor: Colors.white,

    floatingActionButton: FloatingActionButton(
    onPressed: (){
      Navigator.push(context,
      MaterialPageRoute(builder: (context) => ToDoAdd()));
      },
    child: Icon(Icons.post_add_outlined, size: 25,),
    backgroundColor: Color.fromRGBO(144, 210, 140, 1.0),
    ));
  }
}
