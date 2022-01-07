import 'package:flutter/material.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'DoctorChatPage.dart';
import 'DoctorNotifications.dart';
import 'WelcomePage.dart';
import 'HomePageDoctor.dart';
import 'ExamsData.dart';
import 'StudentResDetails.dart';
import 'dart:convert';
import 'UserDta.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class DoctorResultsStudentmark extends StatefulWidget {
  DoctorResultsStudentmarkState createState() =>
      DoctorResultsStudentmarkState();
}

class DoctorResultsStudentmarkState extends State<DoctorResultsStudentmark> {
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<StudentResDetails>> key =
      new GlobalKey();
  @override
  void initState() {
    super.initState();
    getStudentList();

    searchTextField = AutoCompleteTextField<StudentResDetails>(
        style: new TextStyle(color: Colors.black, fontSize: 16.0),
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
            filled: true,
            hintText: 'Search for student..',
            hintStyle: TextStyle(color: Colors.black)),
        itemSubmitted: (item) {
          setState(() {
            print("item submitted");
            searchTextField.textField.controller.text = item.studentname;
          });
        },
        clearOnSubmit: true,
        key: key,
        suggestions: StuResDetList.li,
        itemBuilder: (context, item) {
          return new ExpansionTile(
              trailing: Icon(
                Icons.arrow_drop_down,
                size: 32,
                color: Colors.indigo[800],
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "First",
                      style: TextStyle(fontSize: 18),
                    ),
                    item.firstd == 'NY'
                        ? GestureDetector(
                            onTap: () {
                              enterMark(
                                  context, item.studentid, 'First', 'first');
                            },
                            child: Text(
                              "Tap to enter first mark",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : Text(
                            item.firstd,
                            style: TextStyle(fontSize: 18),
                          ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Second",
                        style: TextStyle(fontSize: 18),
                      ),
                      item.second == 'NY'
                          ? GestureDetector(
                              onTap: () {
                                enterMark(context, item.studentid, 'Second',
                                    'second');
                              },
                              child: Text(
                                "Enter second mark",
                                style: TextStyle(fontSize: 18),
                              ))
                          : Text(
                              item.second,
                              style: TextStyle(fontSize: 18),
                            ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Final",
                        style: TextStyle(fontSize: 18),
                      ),
                      item.finald == 'NY'
                          ? GestureDetector(
                              onTap: () {
                                enterMark(
                                    context, item.studentid, 'Final', 'final');
                              },
                              child: Text(
                                "Enter final mark",
                                style: TextStyle(fontSize: 18),
                              ))
                          : Text(
                              item.finald,
                              style: TextStyle(fontSize: 18),
                            ),
                    ])
              ],
              onExpansionChanged: (value) {},
              title: Container(
                margin: EdgeInsets.all(6.0),
                padding: EdgeInsets.all(16.0),

                //  color: Colors.red,
                width: double.infinity,
                decoration: BoxDecoration(
                    // color: Colors.red,
                    borderRadius: new BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.indigo[800])),
                child: Text(
                  item.studentname,
                  style: TextStyle(fontSize: 18),
                ),
              ));
        },
        itemSorter: (a, b) {
          return a.studentname.compareTo(b.studentname);
        },
        itemFilter: (item, query) {
          return item.studentname.toLowerCase().startsWith(query.toLowerCase());
        });
  }

  TextEditingController markcont = new TextEditingController();

  Future getStudentList() async {
    StuResDetList.li = new List();
    var url =
        'https://crenelate-intervals.000webhostapp.com/getDoctorStudentResults.php';
    print("user id is:");
    print(UserDta.userid);

    var response = await http.post(url, body: {
      "doctorid": UserDta.userid,
      "coursename": CourseName.coursename
    }); //must pass here doctor name

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'failed to get doctor student list') {
      print("failed to get doctor student list");
    } else {
      print("get doctor student list successfully");

      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> doclist = jsonObj[i];
        String studentid = doclist['studentid'];
        String studentname = doclist['studentname'];
        String firstd = doclist['firstd'];
        String second = doclist['second'];
        String finald = doclist['finald'];
        //
        //String coursename = doclist['coursename'];
        StudentResDetails cd = new StudentResDetails();

        cd.studentid = studentid;
        cd.studentname = studentname;
        cd.firstd = firstd;
        cd.second = second;
        cd.finald = finald;

        StuResDetList.li.add(cd);

        markcont.text = "";
      }
      setState(() {});
    }
  }

  List<String> students = [
    'Amani Ali',
    'Raghad Abd',
    'Sara Ahmad',
    'Kareem Mahdi',
    'Kareem Fahmi',
    'Fares Akram',
    'Ansam Fathi',
    'Aya Saeed',
    'Reem Saleh',
    'Hadeel Ashraf',
    'Leena Khaled',
    'Noor Nadi',
    'Cerine Hadi',
    'Omar Rami',
    'Loai Mohammad'
  ];

  Future<void> updatefirst(String firstm, String studentid) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/updateFstRes.php';
    print("the data is");

    var response = await http.post(url, body: {
      "studentid": studentid, //student id means doctor is
      "coursename": CourseName.coursename, //student name means doctor name
      "firstd": firstm
    });

    print("status code is");
    print(response.statusCode);

    final res = json.decode(response.body);
    if (res == 'first mark updated successfully') {
      print("first mark updated successfully");
      sendNotiifcation(
          studentid,
          "Your first mark is now on your result page so kindly check it. ",
          "First mark uploaded");
      showAlertDialog(context);
    } else {
      print("failed to update first mark");
    }
  }

  Future<void> updatesecond(String second, String studentid) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/updateSecRes.php';
    print("the data is");

    var response = await http.post(url, body: {
      "studentid": studentid, //student id means doctor is
      "coursename": CourseName.coursename, //student name means doctor name
      "second": second
    });

    print("status code is");
    print(response.statusCode);

    final res = json.decode(response.body);
    if (res == 'second mark updated successfully') {
      print("second mark updated successfully");
      sendNotiifcation(
          studentid,
          "Your second mark is now on your result page so kindly check it. ",
          "Second mark uploaded");
      showAlertDialog(context);
    } else {
      print("failed to update second mark");
    }
  }

  Future<void> updatefinal(String finalm, String studentid) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/updateFinRes.php';
    print("the data is");

    var response = await http.post(url, body: {
      "studentid": studentid,
      "coursename": CourseName.coursename,
      "finald": finalm
    });

    print("status code is");
    print(response.statusCode);

    final res = json.decode(response.body);
    if (res == 'final mark updated successfully') {
      print("final mark updated successfully");
      sendNotiifcation(
          studentid,
          "Your final mark is now on your result page so kindly check it. ",
          "Final mark uploaded");
      showAlertDialog(context);
    } else {
      print("failed to update final mark");
    }
  }

  Future sendNotiifcation(String userid, String exp, String content) async {
    print("sendNotiifcation api");
    var url =
        'https://crenelate-intervals.000webhostapp.com/sendNotification.php';

    var response = await http.post(url, body: {
      "userid": userid,
    });

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'Failed to send notification') {
      print("Failed to send notification");
    } else {
      print("send notification successfully");
      addNotification(userid, exp, content);
      // addNotification(userid, "استلام طلب بنجاح",
      //   "تم استلام هذا الطلب بنجاح للتاكد يرجى الذهاب الى الصفحة المخصصة");
      setState(() {});
    }
  }

  Future addNotification(String recid, String exp, String content) async {
    print("add new item api");
    var url =
        'https://crenelate-intervals.000webhostapp.com/addNotificationContent.php';

    DateTime now = new DateTime.now();
    // DateTime date = new DateTime(now.year, now.month, now.day);

    var response = await http.post(url, body: {
      "senderid": UserDta.userid,
      "recid": recid,
      "content": content,
      "exp": exp,
      "datess": now.toString()
    });

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'New notificationcontent added Successfully') {
      print("New notificationcontent added Successfully");
      // getDoctorTable();
      //getOrdersTrack();
      setState(() {});
      //  showAlertDialog(context, sellername);
    } else {
      print("Failed to add notification content");
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
        getStudentList();
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
      content: Text("The student fmark uploaded successfully."),
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

  void enterMark(BuildContext context, String studentid, String whichmark,
      String title) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: new Container(
              width: 260.0,
              height: 100.0,
              decoration: new BoxDecoration(
                color: const Color(0xFFFFFF),
                //   borderRadius: new BorderRadius.all(new Radius.circular(60.0)),
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // dialog top
                  //  new Expanded(
                  //    child: new
                  Row(
                    children: <Widget>[
                      new Container(
                        // padding: new EdgeInsets.all(10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                        ),
                        child: new Text(
                          'Enter $title mark:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            //  fontFamily: 'helvetica_neue_light',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Container(
                      child: new TextField(
                    controller: markcont,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: new EdgeInsets.only(
                          left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                      hintText: 'mark',
                      hintStyle: new TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12.0,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: RaisedButton(
                      child: new Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.indigo[800],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        print("coursename is:");
                        if (whichmark == 'First') {
                          updatefirst(markcont.text.trim(), studentid);
                        } else if (whichmark == 'Second') {
                          updatesecond(markcont.text.trim(), studentid);
                        } else {
                          updatefinal(markcont.text.trim(), studentid);
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: RaisedButton(
                      child: new Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.indigo[800],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          //  centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text(
                "Doctor results",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          )),
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 30, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Search for student and assign its marks",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: searchTextField,
              // margin: EdgeInsets.symmetric(vertical: 30),
              // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              // height: 60,
              // width: double.infinity,
              // decoration: BoxDecoration(
              //   color: Color(0xFFF5F5F7),
              //   borderRadius: BorderRadius.circular(40),
              // ),
              // child:
              //  Row(
              //   children: <Widget>[
              //     IconButton(
              //       icon: Icon(FontAwesomeIcons.search),
              //       onPressed: () {},
              //     ),
              //     SizedBox(width: 16),
              //     Text(
              //       "Search for student",
              //       style: TextStyle(
              //         fontSize: 18,
              //         color: Color(0xFFA0A5BD),
              //       ),
              //     )
              //   ],
              // ),
            ),
            SizedBox(height: 15),
            StuResDetList.li.length == 0
                ? Center(
                    child: new Text("Waiting to load data..."),
                  )
                : Expanded(
                    child: new ListView.builder(
                        itemCount: StuResDetList.li.length,
                        itemBuilder: (BuildContext ctxt, int Index) {
                          return new ExpansionTile(
                              trailing: Icon(
                                Icons.arrow_drop_down,
                                size: 32,
                                color: Colors.indigo[800],
                              ),
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "First",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    StuResDetList.li[Index].firstd == 'NY'
                                        ? GestureDetector(
                                            onTap: () {
                                              enterMark(
                                                  context,
                                                  StuResDetList
                                                      .li[Index].studentid,
                                                  'First',
                                                  'first');
                                            },
                                            child: Text(
                                              "Tap to enter first mark",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          )
                                        : Text(
                                            StuResDetList.li[Index].firstd,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Second",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      StuResDetList.li[Index].second == 'NY'
                                          ? GestureDetector(
                                              onTap: () {
                                                enterMark(
                                                    context,
                                                    StuResDetList
                                                        .li[Index].studentid,
                                                    'Second',
                                                    'second');
                                              },
                                              child: Text(
                                                "Enter second mark",
                                                style: TextStyle(fontSize: 18),
                                              ))
                                          : Text(
                                              StuResDetList.li[Index].second,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Final",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      StuResDetList.li[Index].finald == 'NY'
                                          ? GestureDetector(
                                              onTap: () {
                                                enterMark(
                                                    context,
                                                    StuResDetList
                                                        .li[Index].studentid,
                                                    'Final',
                                                    'final');
                                              },
                                              child: Text(
                                                "Enter final mark",
                                                style: TextStyle(fontSize: 18),
                                              ))
                                          : Text(
                                              StuResDetList.li[Index].finald,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                    ])
                              ],
                              onExpansionChanged: (value) {},
                              title: Container(
                                margin: EdgeInsets.all(6.0),
                                padding: EdgeInsets.all(16.0),

                                //  color: Colors.red,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    // color: Colors.red,
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                    border:
                                        Border.all(color: Colors.indigo[800])),
                                child: Text(
                                  StuResDetList.li[Index].studentname,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ));
                        })),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (value) async {
          //
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
