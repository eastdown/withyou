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
            onDetailsPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('This is a meaningless button'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Congratulations'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('You found it'),
                    ),
                  ],
                ),
              );
            },
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 143, 158, 1),
                    Color.fromRGBO(189, 100, 205, 1),
                  ],),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                )),
          ),
          ListTile(
              leading: Icon(Icons.home_outlined, color: Colors.black54),
              title: Text('Home', style: TextStyle(color: Colors.black87)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()));
              }
          ),
          ListTile(
              leading: Icon(Icons.volume_up_outlined, color: Colors.black54),
              title: Text('Finder', style: TextStyle(color: Colors.black87)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FinderHome()));
              }
            //onTap
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
