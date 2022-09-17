import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ToDoAdd extends StatefulWidget {
  const ToDoAdd({Key? key}) : super(key: key);

  @override
  State<ToDoAdd> createState() => _ToDoAddState();
}

class _ToDoAddState extends State<ToDoAdd> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String postTitle = '';
  String content = '';

  String downloadUrl ='';

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('할 일 목록에 올릴 수 없습니다'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('제목과 내용을 적어주세요'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showNameDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('할 일 목록에 올릴 수 없습니다'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('제목을 작성해주세요'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        elevation: 0
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          child: Container(
              height: 76.5,
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05, ),
                      child: GestureDetector(
                          onTap: (){
                            if (FirebaseAuth.instance.currentUser == null){
                              _showNameDialog();
                            }
                            else if (titleController.text == ''){
                              _showMyDialog();
                            }
                            else {
                              FirebaseFirestore.instance.collection('ToDo').doc().set({
                                'title': postTitle,
                                'content': content,
                                'uid': "${FirebaseAuth.instance.currentUser?.email}",
                                'createdDate': DateTime.now().toUtc(),
                                'displayDueDate' : DateFormat.yMMMd('en_US').format(selectedDate),
                                'dueDate' : Timestamp.fromDate(selectedDate),
                              });
                              Navigator.pop(context);

                            }

                          },

                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 53.5,
                            child: Center(child: Text('등록', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),),),

                            decoration: BoxDecoration(
                                color: Color.fromRGBO(34, 45, 255, 1.0),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          )
                      )
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              )
          )
      ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                (FirebaseAuth.instance.currentUser == null) ? Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02, left: MediaQuery.of(context).size.width *0.03, right:MediaQuery.of(context).size.width *0.4 ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Write your name here',
                    ),
                  ),
                ): Padding(padding:EdgeInsets.zero),
                Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.05, left: MediaQuery.of(context).size.width *0.03),
                    child: Text('제목', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),)
                ),
                Padding(
                  padding: EdgeInsets.only( left: MediaQuery.of(context).size.width *0.03, right:MediaQuery.of(context).size.width *0.03 ),
                  child: TextField(
                    controller: titleController,
                    maxLength: 50,
                    decoration: InputDecoration(
                        labelText: '제목을 이곳에 적으세요'
                    ),
                    onChanged: (value){
                      setState(() {
                        postTitle = value;
                      });
                    },
                  ),
                ),

                Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.05, left: MediaQuery.of(context).size.width *0.03),
                    child: Text('내용', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),)
                ),
                Padding(
                  padding: EdgeInsets.only( left: MediaQuery.of(context).size.width *0.03, right:MediaQuery.of(context).size.width *0.03 ),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    controller: contentController,
                    decoration: InputDecoration(
                      labelText: '내용을 적으세요',
                    ),
                    maxLines: null,
                    onChanged: (value){
                      setState(() {
                        content = value;
                      });
                    },
                  ),
                ),

                Padding(
                  padding:EdgeInsets.only(top:30),
                  child: TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text("마감일"),
                  ),
                ),




              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            )
        ));
  }
}

