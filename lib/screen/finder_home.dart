import 'package:flutter/material.dart';
import 'package:withyou/tool/drawer.dart';

class FinderHome extends StatefulWidget {
  const FinderHome({Key? key}) : super(key: key);

  @override
  State<FinderHome> createState() => _FinderHomeState();
}

class _FinderHomeState extends State<FinderHome> {
  TextEditingController serialController = TextEditingController();
  String serialNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                         title: const Text('AlertDialog Title'),
                         content: Column(
                             children: [
                               Text('AlertDialog description'),
                               TextField(
                                 controller: serialController,
                                 decoration: InputDecoration(
                                   labelText: '파인더의 시리얼번호를 적어주세요',
                                 ),
                               ),

                             ])
                         ,
                         actions: <Widget>[
                           TextButton(
                             onPressed: () => Navigator.pop(context, 'Cancel'),
                             child: const Text('Cancel'),
                           ),
                           TextButton(
                             onPressed: () => Navigator.pop(context, 'OK'),
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
            ))


          ]
        )
      )
    );
  }
}
