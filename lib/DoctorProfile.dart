import 'package:flutter/material.dart';
import 'background11.dart';
import 'HomePageDoctor.dart';
import 'WelcomePage.dart';
import 'DoctorNotifications.dart';
import 'DoctorChatPage.dart';
import 'UserDta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class DoctorProfile extends StatefulWidget {
  DoctorProfileState createState() => DoctorProfileState();
}

class DoctorProfileState extends State<DoctorProfile> {
  TextEditingController otherinfo =
      TextEditingController(text: UserDta.otherinfo);
  TextEditingController phoneno = TextEditingController(text: UserDta.phoneno);
  TextEditingController password = TextEditingController(text: UserDta.pass);

  @override
  void initState() {
    super.initState();
    print("DoctorProfile is called");
  }

  Future<void> updateProfile(String phoneno, String pass, String others) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/updateProfile.php';
    print("the data is");

    var response = await http.post(url, body: {
      "userid": UserDta.userid,
      "password": pass,
      "logintype": UserDta.logintype,
      "email": UserDta.email,
      "username": UserDta.username,
      "phoneno": phoneno,
      "otherinfo": others
    });

    print("status code is");
    print(response.statusCode);

    final res = json.decode(response.body);
    if (res == 'Profile updated successfully') {
      print("Profile updated successfully");
      showAlertDialog(context);
    } else {
      print("failed to profile updated");
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Updated successfully",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text("Your profile updated successfully, enjoy your career."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Colors.white,
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Your profile",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                    fontSize: 36),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: phoneno,
                decoration: InputDecoration(labelText: "Phone no."),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: password,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: otherinfo,
                decoration: InputDecoration(labelText: "Other information"),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: RaisedButton(
                onPressed: () {
                  updateProfile(phoneno.text, password.text, otherinfo.text);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                textColor: Colors.white,
                padding: const EdgeInsets.all(0),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width * 0.5,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: new LinearGradient(
                          colors: [Colors.indigo[800], Colors.indigo[800]])),
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "Update",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new HomePageDoctor()));
          } else if (value == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new DoctorNotificationPage()));
          } else if (value == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new DoctorChatPage()));
          } else {
            await FirebaseAuth.instance.signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new WelcomePage()));
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
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('Chat')),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout), title: Text('Logout'))
        ],
      ),
    );
  }
}
