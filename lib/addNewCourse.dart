import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'WelcomePage.dart';
import 'adminHome.dart';
import 'adminchat.dart';

class addNewCourse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _addNewCourseState();
  }
}

class _addNewCourseState extends State<addNewCourse> {
  TextEditingController coursename = new TextEditingController();
  TextEditingController coursetime = new TextEditingController();
  TextEditingController day = new TextEditingController();
  TextEditingController officehrs = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "Ok",
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
        "Added successfully",
        textAlign: TextAlign.justify,
        // textDirection: TextDirection.rtl,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text("Added new course to course list successfully."),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void addnewcourse(String coursename, String courseTime, String officehrs,
      String day) async {
    print("addnewcourse api");
    var url = 'https://crenelate-intervals.000webhostapp.com/addNewCourse.php';

    var response = await http.post(url, body: {
      "coursename": coursename,
      "courseTime": courseTime,
      "officehrs": officehrs,
      "day": day
    });

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'Added new course successfully') {
      print("Added new course successfully");
      showAlertDialog(context);
    } else {
      print("failed to add course");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(199, 246, 245, 1.0),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.indigo[800],
        title: new Text(
          "Add new course",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height * .9,
        padding: EdgeInsets.fromLTRB(30, 80, 30, 50),
        child: Stack(
          children: <Widget>[
            ClipPath(
              clipper: RoundedDiagonalPathClipper(),
              child: Container(
                height: 550,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //SizedBox(height: 90.0,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: coursename,
                        textAlign: TextAlign.left,
                        cursorColor: Color.fromRGBO(10, 145, 171, 1.0),
                        style:
                            TextStyle(color: Color.fromRGBO(10, 145, 171, 1.0)),
                        decoration: InputDecoration(
                          hintText: "Course_name",
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(10, 145, 171, 1.0)),
                          border: InputBorder.none,
                          // icon: Icon(Icons.email, color: Color.fromRGBO(10,145,171,1.0),)
                        ),
                      ),
                    ),
                    Container(
                      child: Divider(
                        color: Color.fromRGBO(10, 145, 171, 1.0),
                      ),
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          controller: coursetime,
                          textAlign: TextAlign.left,
                          cursorColor: Color.fromRGBO(10, 145, 171, 1.0),
                          style: TextStyle(
                              color: Color.fromRGBO(10, 145, 171, 1.0)),
                          decoration: InputDecoration(
                            hintText: "Course_time",
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(10, 145, 171, 1.0)),
                            border: InputBorder.none,
                            //  icon: Icon(Icons.lock, color: Color.fromRGBO(10,145,171,1.0),)
                          ),
                        )),
                    Container(
                      child: Divider(
                        color: Color.fromRGBO(10, 145, 171, 1.0),
                      ),
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          controller: officehrs,
                          textAlign: TextAlign.left,
                          cursorColor: Color.fromRGBO(10, 145, 171, 1.0),
                          style: TextStyle(
                              color: Color.fromRGBO(10, 145, 171, 1.0)),
                          decoration: InputDecoration(
                            hintText: "Office_hrs",
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(10, 145, 171, 1.0)),
                            border: InputBorder.none,
                          ),
                        )),
                    Container(
                      child: Divider(
                        color: Color.fromRGBO(10, 145, 171, 1.0),
                      ),
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                    ),

                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          controller: day,
                          textAlign: TextAlign.left,
                          cursorColor: Color.fromRGBO(10, 145, 171, 1.0),
                          style: TextStyle(
                              color: Color.fromRGBO(10, 145, 171, 1.0)),
                          decoration: InputDecoration(
                            hintText: "Day",
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(10, 145, 171, 1.0)),
                            border: InputBorder.none,
                            // icon: Icon(Icons., color: Color.fromRGBO(10,145,171,1.0),)
                          ),
                        )),
                    Container(
                      child: Divider(
                        color: Color.fromRGBO(10, 145, 171, 1.0),
                      ),
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                    )
                  ],
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     CircleAvatar(
            //       radius: 40.0,
            //       backgroundColor: Color.fromRGBO(10, 145, 171, 1.0),
            //       child: IconButton(
            //         icon: Icon(
            //           Icons.add,
            //           color: Colors.white,
            //           size: 50,
            //         ),
            //         onPressed: () {
            //           // _showPicker(context);
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            Container(
              height: 570,
              //width: 800,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  onPressed: () {
                    addnewcourse(coursename.text, coursetime.text,
                        officehrs.text, day.text);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  child: Text("Add", style: TextStyle(color: Colors.white)),
                  color: Colors.indigo[800],
                ),
              ),
            )
          ],
        ),
      )),
      bottomNavigationBar:
          //  ClipRRect(
          //   borderRadius: BorderRadius.only(
          //     topRight: Radius.circular(40),
          //     topLeft: Radius.circular(40),
          //   ),
          //   child:
          BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (value) async {
          if (value == 0) {
            //await FirebaseAuth.instance.signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new adminHome()));
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
          BottomNavigationBarItem(
            icon: new Icon(Icons.notifications),
            title: new Text('Chat'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout), title: Text('Logout'))
        ],
      ),
      // )
      // ),
    );
  }
}
