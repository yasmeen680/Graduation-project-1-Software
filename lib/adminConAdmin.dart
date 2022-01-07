import 'package:flutter/material.dart';
import 'background.dart';
import 'rounded_button.dart';
import 'rounded_input_field.dart';
import 'rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'DoctorChatPage.dart';
import 'DoctorNotifications.dart';
import 'WelcomePage.dart';
import 'HomePageDoctor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'UserDta.dart';
import 'adminchat.dart';
import 'adminHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'adminchat.dart';

class ContactAdminAdmin extends StatefulWidget {
  ContactAdminAdminState createState() => ContactAdminAdminState();
}

class ContactAdminAdminState extends State<ContactAdminAdmin> {
  TextEditingController relatedTo = TextEditingController();
  TextEditingController exp = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("ContactAdminDoctor is called");
  }

  Future<void> contactAdmin(String realtedto, String explan) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/contactAdmin.php';
    print("the data is");

    final dateTime = DateTime.now();

    var response = await http.post(url, body: {
      "studentid": UserDta.userid, //student id means doctor is
      "studentname": UserDta.username, //student name means doctor name
      "dt": dateTime.toString(),
      "relatedto": realtedto,
      "explanation": explan
    });

    print("status code is");
    print(response.statusCode);

    final res = json.decode(response.body);
    if (res == 'Sent admin successfully') {
      print("Sent admin successfully");
      showAlertDialog(context);
    } else {
      print("from static dta");
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
        "Sent successfully",
        // textAlign: TextAlign.justify,
        // textDirection: TextDirection.rtl,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
          "Your message sent successfully to admin, you will recieve the response soon."),
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
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Contact admin",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Colors.indigo[800]),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/signup.svg",
                height: size.height * 0.35,
              ),
              RoundedInputField(
                hintText: "Related to",
                tt: relatedTo,
                onChanged: (value) {},
              ),
              RoundedInputField(
                hintText: "Explanation",
                tt: exp,
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "Send",
                press: () {
                  contactAdmin(relatedTo.text, exp.text);
                },
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (value) async {
          //            await FirebaseAuth.instance.signOut();

          if (value == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new adminHome()));
          } else if (value == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new adminchat()));
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
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('Chat')),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout), title: Text('Logout'))
        ],
      ),
    );
  }
}
