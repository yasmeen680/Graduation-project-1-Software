import 'package:flutter/material.dart';
import 'DoctorNotifications.dart';
import 'DoctorChatPage.dart';
import 'WelcomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'HomePageDoctor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'UserDta.dart';
import 'DoctorStuMeeting.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DoctorMeetingWithStu extends StatefulWidget {
  _DoctorMeetingWithStuState createState() => _DoctorMeetingWithStuState();
}

class _DoctorMeetingWithStuState extends State<DoctorMeetingWithStu> {
  @override
  void initState() {
    super.initState();
    print("DoctorMeetingWithStu is called");
    getDoctorTable();
  }

  Future getDoctorTable() async {
    DoctorStuMeetinglist.li = new List();
    var url =
        'https://crenelate-intervals.000webhostapp.com/getDoctorStuMeetings.php';
    print("user id is:");
    print(UserDta.userid);

    var response = await http.post(url,
        body: {"doctorid": UserDta.userid}); //must pass here doctor name

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'Failed to get doctor meetings') {
      print("Failed to get doctor meetings");
    } else {
      print("get doctor meetings successfully");

      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> doclist = jsonObj[i];
        String studentname = doclist['studentname'];
        String coursename = doclist['coursename'];
        String about = doclist['about'];
        String meetingdate = doclist['meetingdate'];
        String studentid = doclist['studentid'];

        DoctorStuMeeting cd = new DoctorStuMeeting();

        cd.studentname = studentname;
        cd.coursename = coursename;
        cd.about = about;
        cd.meetingdate = meetingdate;
        cd.studentid = studentid;

        DoctorStuMeetinglist.li.add(cd);
      }
      setState(() {});
    }
  }

  Future delayMeeting(
      String studentid, String meetingdat, String coursename) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/delayMeeting.php';
    print("delayMeeting is called");

    var response = await http.post(url, body: {
      "studentid": studentid,
      "doctorid": UserDta.userid,
      "meetingdate": meetingdat,
      "coursename": coursename,
    });

    print("status code is");
    print(response.statusCode);

    final res = json.decode(response.body);
    if (res == 'delay meeting with student') {
      print("delay meeting with student");
      sendNotiifcation(
          studentid,
          "You have a meeting delayed from a doctor for this course : " +
              coursename,
          "Some meeting delayed");
      showAlertDialog(context);
    } else {
      print("failed to delay meeting");
    }
  }

  Future cancelMeeting(String studentid, String coursename) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/deleteMeeting.php';
    print("cancelMeeting is called");

    var response = await http.post(url, body: {
      "studentid": studentid,
      "doctorid": UserDta.userid,
      "coursename": coursename,
    });

    print("status code is");
    print(response.statusCode);

    final res = json.decode(response.body);
    if (res == 'the meeting deleted successfully') {
      print("the meeting deleted successfully");
      sendNotiifcation(
          studentid,
          "You have a meeting cancelled from a doctor for this course : " +
              coursename,
          "Some meeting cancelled");
      //  Fluttertoa
      showAlertDialog(context);
    } else {
      print("failed to delete meeting");
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
        Navigator.pop(context);
        setState(() {});
        getDoctorTable();
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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _registerSheet(
      String course, String day, String relatedto, String datess) {
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
                              new Text("Course name : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                              course.length > 17
                                  ? new Text(course.substring(0, 17),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold))
                                  : new Text(course,
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
                                new Text("Meeting dt :",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                                new Text(datess,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: 20, top: 20, left: 30, right: 30),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new Text("Student id : ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
                                  new Text(day,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold))
                                ])),
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: 20, top: 20, left: 30, right: 30),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new Text("Related to : ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
                                  new Text(relatedto,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold))
                                ])),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 20, top: 20, left: 20, right: 20),
                          child: RaisedButton(
                            highlightElevation: 0.0,
                            splashColor: Colors.white,
                            highlightColor: Colors.black,
                            elevation: 0.0,
                            color: Colors.indigo[800],
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Text(
                              "Join meeting",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            onPressed: () {
                              print("join the meeting in the future");
                              AppAvailability.launchApp(
                                  //https://play.google.com/store/apps/details?id=us.zoom.videomeetings
                                  'us.zoom.videomeetings').then((response) {
                                print("open app successfully");
                              }).catchError((err) {
                                print("catch error when open app");
                                print(err);
                              });
                              // function();
                            },
                          ),
                        ),
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
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
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
                "Meetings with my students",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          )),
      backgroundColor: Colors.white,
      body: DoctorStuMeetinglist.li.length == 0
          ? Center(
              child: new Text("Waiting to load data..."),
            )
          : ListView.builder(
              itemCount: DoctorStuMeetinglist.li.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(12),
                  width: 200,
                  height: 140,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.indigo[800],
                    elevation: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new ListTile(
                          contentPadding: EdgeInsets.all(18),
                          leading: Icon(
                            Icons.video_call,
                            size: 60,
                            color: Colors.white,
                          ),
                          // trailing: GestureDetector(
                          //   onTap: () {
                          //     _registerSheet(
                          //         DoctorStuMeetinglist.li[index].coursename,
                          //         DoctorStuMeetinglist.li[index].studentid,
                          //         DoctorStuMeetinglist.li[index].about,
                          //         DoctorStuMeetinglist.li[index].meetingdate);
                          //   },
                          //   child: Icon(
                          //     Icons.arrow_forward,
                          //     size: 25,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          title: Center(
                            child: Text(
                                DoctorStuMeetinglist.li[index].studentname,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    cancelMeeting(
                                        DoctorStuMeetinglist
                                            .li[index].studentid,
                                        DoctorStuMeetinglist
                                            .li[index].coursename);
                                  }),
                              IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    DatePicker.showDateTimePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(2020, 5, 5, 20, 50),
                                        maxTime: DateTime(2021, 12, 30, 05, 09),
                                        onChanged: (date) {
                                      print('change $date in time zone ' +
                                          date.timeZoneOffset.inHours
                                              .toString());
                                    }, onConfirm: (date) {
                                      print('confirm $date');
                                      int idx = date.toString().indexOf(' ');
                                      print("idx is:$idx");
                                      delayMeeting(
                                          DoctorStuMeetinglist
                                              .li[index].studentid,
                                          date.toString(),
                                          DoctorStuMeetinglist
                                              .li[index].coursename);
                                    }, locale: LocaleType.en);
                                  }),
                              IconButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _registerSheet(
                                        DoctorStuMeetinglist
                                            .li[index].coursename,
                                        DoctorStuMeetinglist
                                            .li[index].studentid,
                                        DoctorStuMeetinglist.li[index].about,
                                        DoctorStuMeetinglist
                                            .li[index].meetingdate);
                                  })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (value) async {
          value == 0
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new HomePageDoctor()))
              : value == 1
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new DoctorNotificationPage()))
                  : value == 2
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new DoctorChatPage()))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new WelcomePage()));
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
