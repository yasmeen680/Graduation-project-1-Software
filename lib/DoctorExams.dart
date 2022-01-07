import 'package:flutter/material.dart';
import 'DoctorChatPage.dart';
import 'DoctorNotifications.dart';
import 'WelcomePage.dart';
import 'HomePageDoctor.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ExamsData.dart';
import 'UserDta.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

const CURVE_HEIGHT = 170.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.0;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}

class DoctorExams extends StatefulWidget {
  DoctorExamsState createState() => DoctorExamsState();
}

class DoctorExamsState extends State<DoctorExams> {
  @override
  void initState() {
    super.initState();
    print("DoctorExams is called");
    getDoctorTable();
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
      setState(() {});
    } else {
      print("Failed to add notification content");
    }
  }

  Future<void> updatefirst(String fdate, String ftime, String course) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/updateExams.php';
    print("the data is");

    var response = await http.post(url, body: {
      "doctorid": UserDta.userid,
      "firstdate": fdate,
      "firsttime": ftime,
      "course": course
    });

    print("status code is");
    print(response.statusCode);

    final res = json.decode(response.body);
    if (res == 'exams updated successfully') {
      print("exams updated successfully");
      getStudentlist(course, "First exam assigned",
          "Your doctor set first exam date for :" + course);

      showAlertDialog(context);
    } else {
      print("failed to set exam date");
    }
  }

  Future getStudentlist(String course, String content, String exp) async {
    var url =
        'https://crenelate-intervals.000webhostapp.com/getStudentlist.php';
    print("user id is:");
    print(UserDta.userid);

    var response = await http.post(url, body: {"course": course});

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'Failed to get student list') {
      print("Failed to get student list");
    } else {
      print("get student list successfully");

      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> doclist = jsonObj[i];
        String StudentId = doclist['StudentId'];
        String StudentName = doclist['StudentName'];

        sendNotiifcation(StudentId, exp, content);
      }
      setState(() {});
    }
  }

  Future<void> updatesecond(String fdate, String ftime, String course) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/updateExams1.php';
    print("the data is");

    var response = await http.post(url, body: {
      "doctorid": UserDta.userid,
      "seconddate": fdate,
      "secondtime": ftime,
      "course": course
    });

    print("status code is");
    print(response.statusCode);
    // print(json.decode(response.body));

    final res = json.decode(response.body);
    if (res == 'exams updated successfully') {
      print("exams updated successfully");
      getStudentlist(course, "Second exam assigned",
          "Your doctor set second exam date for :" + course);

      showAlertDialog(context);
    } else {
      print("failed to set exam date");
    }
  }

  Future<void> updatefinal(String fdate, String ftime, String course) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/updateExams2.php';
    print("the data is");

    var response = await http.post(url, body: {
      "doctorid": UserDta.userid,
      "finaldate": fdate,
      "finaltime": ftime,
      "course": course
    });

    print("status code is");
    print(response.statusCode);
    // print(json.decode(response.body));

    final res = json.decode(response.body);
    if (res == 'exams updated successfully') {
      print("exams updated successfully");

      getStudentlist(course, "Final exam assigned",
          "Your doctor set final exam date for :" + course);
      showAlertDialog(context);
    } else {
      print("failed to set exam date");
    }
  }

  Future getDoctorTable() async {
    ExamsDataList.li = new List();
    var url =
        'https://crenelate-intervals.000webhostapp.com/getDoctorExams.php';
    print("user id is:");
    print(UserDta.userid);

    var response = await http.post(url,
        body: {"doctorid": UserDta.userid, "drname": UserDta.username});

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'Failed to get doctors exams') {
      print("Failed to get doctors exams");
    } else {
      print("get doctor exams successfully");

      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> doclist = jsonObj[i];
        String otherinfo = doclist['otherinfo'];
        String finaltime = doclist['finaltime'];
        String finaldate = doclist['finaldate'];
        String secondtime = doclist['secondtime'];
        String seconddate = doclist['seconddate'];
        String firsttime = doclist['firsttime'];
        String firstdate = doclist['firstdate'];
        String course = doclist['course'];

        ExamsData ed = new ExamsData();
        ed.otherinfo = otherinfo;
        ed.finaltime = finaltime;
        ed.finaldate = finaldate;
        ed.secondtime = secondtime;
        ed.seconddate = seconddate;
        ed.finaltime = firsttime;
        ed.firstdate = firstdate;
        ed.course = course;

        ExamsDataList.li.add(ed);
      }
      setState(() {});
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
        getDoctorTable();
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
      content: Text("Your exam date set successfully."),
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

  void setExamDate(BuildContext context) async {
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
                          'Enter course name:',
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
                    //  controller: coursenameController,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: new EdgeInsets.only(
                          left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                      hintText: 'course name',
                      hintStyle: new TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12.0,
                        //   fontFamily: 'helvetica_neue_light',
                      ),
                    ),
                  )),
                  //  flex: 2,
                  //  ),
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

  // Future getDoctorTable() async {
  //   ExamsDataList.li = new List();
  //   var url =
  //       'https://crenelate-intervals.000webhostapp.com/getDoctorExams.php';
  //   print("user id is:");
  //   print(UserDta.userid);

  //   var response = await http.post(url,
  //       body: {"doctorid": UserDta.userid, "drname": UserDta.username});

  //   print("status code is");
  //   print(response.statusCode);
  //   print(json.decode(response.body));

  //   final res = json.decode(response.body);

  //   if (res == 'Failed to get doctors exams') {
  //     print("Failed to get doctors exams");
  //   } else {
  //     print("get doctor exams successfully");

  //     List<dynamic> jsonObj = res;
  //     for (int i = 0; i < jsonObj.length; i++) {
  //       Map<String, dynamic> doclist = jsonObj[i];
  //       String otherinfo = doclist['otherinfo'];
  //       String finaltime = doclist['finaltime'];
  //       String finaldate = doclist['finaldate'];
  //       String secondtime = doclist['secondtime'];
  //       String seconddate = doclist['seconddate'];
  //       String firsttime = doclist['firsttime'];
  //       String firstdate = doclist['firstdate'];
  //       String course = doclist['course'];

  //       ExamsData ed = new ExamsData();
  //       ed.otherinfo = otherinfo;
  //       ed.finaltime = finaltime;
  //       ed.finaldate = finaldate;
  //       ed.secondtime = secondtime;
  //       ed.seconddate = seconddate;
  //       ed.finaltime = firsttime;
  //       ed.firstdate = firstdate;
  //       ed.course = course;

  //       ExamsDataList.li.add(ed);
  //     }
  //     setState(() {});
  //   }
  // }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _registerSheet(String firste, String seconde, String finale) {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return DecoratedBox(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
          child: Container(
            child: ListView(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 10,
                        top: 10,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            size: 30.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  height: 50,
                  width: 50,
                ),
                SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 40),
                          height: 140,
                          child: Container(
                            child: new Text("Learno",
                                style: GoogleFonts.pacifico(
                                  fontSize: 50,
                                  color: Colors.indigo[800],
                                  shadows: [
                                    Shadow(
                                      blurRadius: 150.0,
                                      color: Colors.white,
                                      // offset: Offset(5.0, 5.0),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 20, top: 60, left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              new Text("First exam : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                              firste.length > 17
                                  ? new Text(firste.substring(0, 17),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold))
                                  : new Text(firste,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 20, top: 20, left: 30, right: 30),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Text("Second exam :",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 200),
                                  child: new Text(seconde,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
                                )
                              ]),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: 20, top: 20, left: 30, right: 30),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new Text("Final exam : ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
                                  new Container(
                                    constraints: BoxConstraints(maxWidth: 200),
                                    child: Text(finale,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ])),
                        SizedBox(
                          height: 20,
                        ),
                      ]),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height / 1.1,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
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
                "Doctor exams",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          )),
      body: new ListView.builder(
          itemCount: ExamsDataList.li.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new GestureDetector(
                onTap: () {
                  _registerSheet(
                      ExamsDataList.li[index].firstdate +
                          ExamsDataList.li[index].firsttime,
                      ExamsDataList.li[index].seconddate +
                          ExamsDataList.li[index].secondtime,
                      ExamsDataList.li[index].finaldate +
                          ExamsDataList.li[index].finaltime);
                },
                child: Container(
                    color: Colors.indigo[800],
                    child: GestureDetector(
                      onTap: () {
                        _registerSheet(
                            ExamsDataList.li[index].firstdate +
                                ExamsDataList.li[index].firsttime,
                            ExamsDataList.li[index].seconddate +
                                ExamsDataList.li[index].secondtime,
                            ExamsDataList.li[index].finaldate +
                                ExamsDataList.li[index].finaltime);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(80.0),
                            bottomRight: Radius.circular(80.0),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          //  left: 32,
                          top: 40.0,
                          bottom: 35,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ExamsDataList.li[index].course,
                                    style: TextStyle(
                                        color: Colors.indigo[800],
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      DatePicker.showDateTimePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(2020, 5, 5, 20, 50),
                                          maxTime:
                                              DateTime(2021, 12, 30, 05, 09),
                                          onChanged: (date) {
                                        print('change $date in time zone ' +
                                            date.timeZoneOffset.inHours
                                                .toString());
                                      }, onConfirm: (date) {
                                        print('confirm $date');
                                        int idx = date.toString().indexOf(' ');
                                        print("idx is:$idx");
                                        updatefirst(
                                            date.toString().substring(0, idx),
                                            date.toString().substring(idx + 1),
                                            ExamsDataList.li[index].course);
                                      }, locale: LocaleType.en);
                                    },
                                    child: new Text("First",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        DatePicker.showDateTimePicker(context,
                                            showTitleActions: true,
                                            minTime:
                                                DateTime(2020, 5, 5, 20, 50),
                                            maxTime:
                                                DateTime(2021, 12, 30, 05, 09),
                                            onChanged: (date) {
                                          print('change $date in time zone ' +
                                              date.timeZoneOffset.inHours
                                                  .toString());
                                        }, onConfirm: (date) {
                                          print('confirm $date');
                                          int idx =
                                              date.toString().indexOf(' ');
                                          print("idx is:$idx");
                                          updatesecond(
                                              date.toString().substring(0, idx),
                                              date
                                                  .toString()
                                                  .substring(idx + 1),
                                              ExamsDataList.li[index].course);
                                        }, locale: LocaleType.en);
                                      },
                                      child: new Text("Second",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  GestureDetector(
                                      onTap: () {
                                        DatePicker.showDateTimePicker(context,
                                            showTitleActions: true,
                                            minTime:
                                                DateTime(2020, 5, 5, 20, 50),
                                            maxTime:
                                                DateTime(2021, 12, 30, 05, 09),
                                            onChanged: (date) {
                                          print('change $date in time zone ' +
                                              date.timeZoneOffset.inHours
                                                  .toString());
                                        }, onConfirm: (date) {
                                          print('confirm $date');
                                          int idx =
                                              date.toString().indexOf(' ');
                                          print("idx is:$idx");
                                          updatefinal(
                                              date.toString().substring(0, idx),
                                              date
                                                  .toString()
                                                  .substring(idx + 1),
                                              ExamsDataList.li[index].course);
                                        }, locale: LocaleType.en);
                                      },
                                      child: new Text("Final",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ],
                              )
                            ]),
                      ),
                    )));
          }),
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

class CurvedShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: CURVE_HEIGHT,
      child: CustomPaint(
        painter: _MyPainter(),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = Colors.indigo[800];

    Offset circleCenter = Offset(size.width / 2, size.height - AVATAR_RADIUS);

    Offset topLeft = Offset(0, 0);
    Offset bottomLeft = Offset(0, size.height * 0.25);
    Offset topRight = Offset(size.width, 0);
    Offset bottomRight = Offset(size.width, size.height * 0.5);

    Offset leftCurveControlPoint =
        Offset(circleCenter.dx * 0.5, size.height - AVATAR_RADIUS * 1.5);
    Offset rightCurveControlPoint =
        Offset(circleCenter.dx * 1.6, size.height - AVATAR_RADIUS);

    final arcStartAngle = 200 / 180 * pi;
    final avatarLeftPointX =
        circleCenter.dx + AVATAR_RADIUS * cos(arcStartAngle);
    final avatarLeftPointY =
        circleCenter.dy + AVATAR_RADIUS * sin(arcStartAngle);
    Offset avatarLeftPoint =
        Offset(avatarLeftPointX, avatarLeftPointY); // the left point of the arc

    final arcEndAngle = -5 / 180 * pi;
    final avatarRightPointX =
        circleCenter.dx + AVATAR_RADIUS * cos(arcEndAngle);
    final avatarRightPointY =
        circleCenter.dy + AVATAR_RADIUS * sin(arcEndAngle);
    Offset avatarRightPoint = Offset(
        avatarRightPointX, avatarRightPointY); // the right point of the arc

    Path path = Path()
      ..moveTo(topLeft.dx,
          topLeft.dy) // this move isn't required since the start point is (0,0)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..quadraticBezierTo(leftCurveControlPoint.dx, leftCurveControlPoint.dy,
          avatarLeftPoint.dx, avatarLeftPoint.dy)
      ..arcToPoint(avatarRightPoint, radius: Radius.circular(AVATAR_RADIUS))
      ..quadraticBezierTo(rightCurveControlPoint.dx, rightCurveControlPoint.dy,
          bottomRight.dx, bottomRight.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
