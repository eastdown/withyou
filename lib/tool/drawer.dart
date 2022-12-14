import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:withyou/screen/home.dart';
import 'package:withyou/screen/finder_home.dart';



class DrawerForAll extends StatefulWidget {
  const DrawerForAll({Key? key}) : super(key: key);

  @override
  _DrawerForAllState createState() => _DrawerForAllState();
}

class _DrawerForAllState extends State<DrawerForAll> {
  signOut (){
    FirebaseAuth.instance.signOut();
    Navigator.pop(context, 'Cancel');
  }

  Widget getDrawer (BuildContext context){
    var drawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('${FirebaseAuth.instance.currentUser?.photoURL}'),
            ),

            accountEmail: Text("${FirebaseAuth.instance.currentUser?.email}"),
            accountName: Text("${FirebaseAuth.instance.currentUser?.displayName}"),

            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(84, 196, 255, 1.0),
                    Color.fromRGBO(229, 116, 255, 1.0),
                  ],),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                )),
          ),
          ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.black54),
              title: Text('플래너', style: TextStyle(color: Colors.black87)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()));
              }
          ),
          ListTile(
              leading: Icon(Icons.volunteer_activism_outlined, color: Colors.black54),
              title: Text('파인더', style: TextStyle(color: Colors.black87)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FinderHome()));
              }
            //onTap
          ),
          Divider(
              color: Colors.black54
          ),

          ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.black54),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Log Out?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {signOut();},
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
              title: Text('Sign Out')
          ),
        ],
      ),
    );
    return drawer;
  }
  @override
  Widget build(BuildContext context) {



    return getDrawer(context);
  }
}
