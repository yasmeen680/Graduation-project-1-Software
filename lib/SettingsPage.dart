import 'package:flutter/material.dart';
import 'HomePageStudent.dart';
import 'NotificationPage.dart';
import 'WelcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: new Text(
          "Settings Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          margin: EdgeInsets.all(4.0),
          padding: EdgeInsets.all(4.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                // trailing: ,
                leading: Icon(Icons.add),
                title: Text(
                  'Schedule a new meeting',
                  style: TextStyle(fontSize: 18),
                  //   textAlign: TextAlign.justify,
                  //   textDirection: TextDirection.rtl,
                ),
              ),
              ListTile(
                leading: Icon(Icons.update),
                title: Text(
                  'Update my information',
                  style: TextStyle(fontSize: 18),
                  // textAlign: TextAlign.justify,
                  //   textDirection: TextDirection.rtl,
                ),
              ),
              ListTile(
                leading: Icon(Icons.contact_support),
                title: Text(
                  'Contact with admin',
                  style: TextStyle(fontSize: 18),
                  //  textAlign: TextAlign.justify,
                  //textDirection: TextDirection.rtl,
                ),
              ),
              ListTile(
                leading: Icon(Icons.rate_review),
                title: Text(
                  'Check my courses',
                  style: TextStyle(fontSize: 18),
                  //  textAlign: TextAlign.justify,
                  //textDirection: TextDirection.rtl,
                ),
              ),
              ListTile(
                leading: Icon(Icons.mark_chat_read),
                title: Text(
                  'Review my marks',
                  style: TextStyle(fontSize: 18),
                  //  textAlign: TextAlign.justify,
                  //textDirection: TextDirection.rtl,
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 18),
                  // textAlign: TextAlign.justify,
                  // textDirection: TextDirection.rtl,
                ),
              ),
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[300],
        currentIndex: 2,
        onTap: (value) async {
          if (value == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new HomePageStudent()));
          } else if (value == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new NotificationPage()));
          } else if (value == 3) {
            await FirebaseAuth.instance.signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new WelcomePage()));
          } else {
            print("nothing");
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.notifications),
            title: new Text('Notifications'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings')),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout), title: Text('Logout'))
        ],
      ),
    );
  }
}
