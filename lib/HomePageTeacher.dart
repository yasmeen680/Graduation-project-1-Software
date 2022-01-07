import 'package:flutter/material.dart';

class HomePageTeacher extends StatefulWidget {
  _HomePageTeacherState createState() => _HomePageTeacherState();
}

class _HomePageTeacherState extends State<HomePageTeacher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Colors.blue[300]
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        title: new Text(
          "Home Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[300],
        currentIndex: 0,
        onTap: (value) async {
          // value == 1
          //     ? Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => new NotificationPage()))
          //     : value == 2
          //         ? Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => new SettingsPage()))
          //         : Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => new LoginORSignup()));
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
