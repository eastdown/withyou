import 'package:flutter/material.dart';
import 'package:withyou/tool/drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:withyou/tool/todoAdd.dart';
import 'package:flutter/scheduler.dart' show timeDilation;



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
        centerTitle: true,
        title: Image.asset('asset/withyou_logo.png', fit: BoxFit.fitHeight, height: 55),
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
                Padding(
                    padding: EdgeInsets.only(top: 20),
                child: Text('충청북도 청주시', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                Text('토요일 9월 17일, 2022년', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 20, right:20),
                        child: Text('27°C', style: TextStyle(fontSize: 50,))),

                  ],
                ),

                Align(
                  child:Padding(
                      padding: EdgeInsets.only(top: 20, bottom:10),
                      child: Text('오늘 할 일', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                  alignment: Alignment.centerLeft,
                ),
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
                            return Card(
                              elevation: 10,
                                child:CheckboxListTile(
                                  controlAffinity: ListTileControlAffinity.leading,
                                  value: timeDilation != 1.0,
                              onChanged: (bool? value){
                                    setState(() {
                                      timeDilation = value! ? 10.0 :1.0;
                                    });
                              },
                              title: Text('${snapshot.data!.docs[index]['title']}'),
                              subtitle: Text('${snapshot.data!.docs[index]['displayDueDate']}'),
                            ));
                          });
                    }
                ),
                Padding(padding: EdgeInsets.only(bottom:30)),

                TableCalendar(
                  headerVisible: false,
                  headerStyle: HeaderStyle(
                    rightChevronVisible: false,
                    leftChevronVisible: false,
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  daysOfWeekHeight: 30,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                ),


                Padding(padding: EdgeInsets.only(bottom:100)),






              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            )
        ),),
      backgroundColor: Colors.white,

    floatingActionButton: FloatingActionButton.extended(
      label: Text('할 일 추가'),
        onPressed: (){
      Navigator.push(context,
      MaterialPageRoute(builder: (context) => ToDoAdd()));
      },
    icon: Icon(Icons.post_add_outlined, size: 25,),
    backgroundColor: Color.fromRGBO(63, 94, 255, 1.0)
    ));
  }
}
