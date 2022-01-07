import 'package:flutter/material.dart';
import 'WelcomePage.dart';
import 'UserDta.dart';
import 'WelcomePage.dart';
import 'DoctorChatPage.dart';
import 'DoctorNotifications.dart';
import 'adminchat.dart';
import 'adminConAdmin.dart';
import 'adminProfile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'addNewCourse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class adminHome extends StatefulWidget {
  _adminHomeState createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
  SharedPreferences sh;

  @override
  void initState() {
    super.initState();
    print("Main admin");
    signInWithEmailAndPassword();
  }

  Future enableRegistration() async {
    var url =
        'https://crenelate-intervals.000webhostapp.com/enableRegistration.php';
    print("the data is");

    var response = await http.post(url, body: {
      "userid": UserDta.userid,
      "password": UserDta.pass,
      "enabled": UserDta.checked == true ? 'Changed' : 'notChanged'
    });

    print("status code is");
    print(response.statusCode);

    final res = json.decode(response.body);
    if (res == 'enable registration successfully') {
      print("enable registration successfully");
    } else {
      print("failed to enable registration");
    }
  }

  Future signInWithEmailAndPassword() async {
    try {
      //"hanal@gmail.com"
      sh = await SharedPreferences.getInstance();
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: UserDta.email, password: UserDta.pass); //"98765432"
      print("the user credential is :");
      print(result.user);
      User uu = result.user;
      print("email credential is");
      print(uu.uid);
      print(uu.email);
      sh.setString("uid", uu.uid.toString());
      UserDta.uid = uu.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //  resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Text(
                "Home Page",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              new Text(
                "admin", //UserDta.username.toString()
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          )),
      body: Container(
        margin: EdgeInsets.only(top: 25.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new addNewCourse()));
                      },
                      child: Container(
                        width: 160,
                        height: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new AssetImage('assets/course1.png'))),
                        margin: EdgeInsets.fromLTRB(10, 2, 10, 5),
                      ),
                    ),
                    Container(
                      child: new Text(
                        'Add new course',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new adminProfile()));
                        },
                        child: Container(
                          width: 160,
                          height: 150,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new AssetImage('assets/20.png'))),
                          margin: EdgeInsets.fromLTRB(10, 2, 10, 5),
                          // child: Image(
                          //   image: AssetImage('assets/20.png'),
                          //   fit: BoxFit.fill,
                          // ),
                        )),
                    Container(
                      child: new Text(
                        'Update profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new ContactAdminAdmin()));
                      },
                      child: Container(
                        width: 160,
                        height: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new AssetImage('assets/23.jpg'))),
                        margin: EdgeInsets.fromLTRB(10, 2, 10, 5),
                        // child: Image(
                        //   image: AssetImage('assets/23.jpg'),
                        //   fit: BoxFit.fill,
                        // ),
                      ),
                    ),
                    Container(
                      child: new Text(
                        'Contact admin',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  margin: EdgeInsets.only(left: 15),
                  child: new Text(
                    "Enable registration: ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 90,
                ),
                new Switch(
                    value: UserDta.checked,
                    onChanged: (bool value) {
                      setState(() {
                        UserDta.checked = value;
                        enableRegistration();
                      });
                    }),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (value) async {
          //await FirebaseAuth.instance.signOut();
          if (value == 0) {
          } else if (value == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new adminchat()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new WelcomePage()));
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          // BottomNavigationBarItem(
          //   icon: new Icon(Icons.notifications),
          //   title: new Text('Notifications'),
          // ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('Chat')),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout), title: Text('Logout'))
        ],
      ),
      // )
    );
  }
}
