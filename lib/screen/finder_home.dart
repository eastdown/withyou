import 'package:flutter/material.dart';
import 'package:withyou/tool/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:withyou/screen/finder.dart';

int finderIndex = 0;
String finderSerial = '';

class FinderHome extends StatefulWidget {
  const FinderHome({Key? key}) : super(key: key);

  @override
  State<FinderHome> createState() => _FinderHomeState();
}

class _FinderHomeState extends State<FinderHome> {
  TextEditingController serialController = TextEditingController();
  String serialNumber = '';
  String email = "${FirebaseAuth.instance.currentUser?.email}";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(top:20)),
              Align(
                alignment: Alignment.center,
                 child: GestureDetector(
                     onTap:() => showDialog<String>(
                       context: context,
                       builder: (BuildContext context) => AlertDialog(
                         title: Text('파인더 추가'),
                         content:
                                 SizedBox(
                                   height: 80,
                                   child:TextField(
                                     controller: serialController,
                                     decoration: InputDecoration(
                                       labelText: '파인더의 시리얼번호를 적어주세요',
                                     ),
                                   ), )
                         ,
                         actions: <Widget>[
                           TextButton(
                             onPressed: () => Navigator.pop(context, 'Cancel'),
                             child: const Text('Cancel'),
                           ),
                           TextButton(
                             onPressed: () {
                                 Navigator.pop(context, 'OK');
                                 FirebaseFirestore.instance.collection('HomeAutomatic').doc("${serialController.text}").set({
                                   'email': "${FirebaseAuth.instance.currentUser?.email}",
                                   'serialNumber': "${serialController.text}",
                                   'finderName': "무제"
                                 });
                             },
                             child: const Text('OK'),

                           ),
                         ],
                       ),
                     ),


                   child:Container(
                       height:  MediaQuery.of(context).size.height * 0.125,
                       width: MediaQuery.of(context).size.width * 0.9,
                       decoration: BoxDecoration(
                           color: Color.fromRGBO(230, 230, 230, 1.0),
                           borderRadius: BorderRadius.all(Radius.circular(20))
                       ),
                       child: Row(
                           children: [
                             Padding(padding: EdgeInsets.only(left:30),),
                             Icon(Icons.add_box_outlined),
                             Padding(padding: EdgeInsets.only(left:30),),
                             Text('파인더 추가')
                           ]
                       ),

                 )
            )),
              Padding(padding: EdgeInsets.only(top:40)),


              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('HomeAutomatic').where('email', isEqualTo: email).snapshots(),
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
                          return  Padding(
                            padding: EdgeInsets.only(bottom:20),
                              child:Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Finder()),);
                                    finderIndex = index;
                                    finderSerial = '${snapshot.data?.docs[index]['serialNumber']}';
                                  },
                                  child:Container(

                                    height:  MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color.fromRGBO(26, 82, 255, 1.0),
                                            Color.fromRGBO(130, 255, 173, 1.0),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 0),
                                          blurRadius: 2,
                                          spreadRadius: 2,
                                          color: Colors.black26,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                  child: Text("${snapshot.data?.docs[index]['finderName']}",
                                                    style:TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                                                  padding: EdgeInsets.only(left: 30, top:15))),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                              child: Padding(
                                                child: Text("${snapshot.data?.docs[index]['serialNumber']}",
                                                  style:TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),),
                                            padding: EdgeInsets.only(left: 30))),
                                              Padding(
                                                padding: EdgeInsets.only(top:30),
                                              ),
                                              Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Padding(
                                                      child: Text("클릭하여 더보기 >>   ",
                                                        style:TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),),
                                                      padding: EdgeInsets.only(left: 30))


                                          )]
                                    ),
                                  )
                              )));
                        });
                  }
              ),

          ]
        )
      )
    );
  }
}
