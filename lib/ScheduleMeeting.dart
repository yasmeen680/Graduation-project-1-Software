import 'package:flutter/material.dart';
import 'FormBox.dart';
import 'UserDta.dart';
import 'MeetingData.dart';
import 'MeetingDetail.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScheduleMeeting extends StatefulWidget {
  @override
  _ScheduleMeetingState createState() => _ScheduleMeetingState();
}

class _ScheduleMeetingState extends State<ScheduleMeeting>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation1, animation2, animation3;
  String datemeet = "";
  TextEditingController drname =
      TextEditingController(text: MeetingDetail.drname.toString());
  TextEditingController number =
      TextEditingController(text: MeetingDetail.phoneno.toString());
  TextEditingController email =
      TextEditingController(text: MeetingDetail.email.toString());

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    animation1 = Tween(begin: -1.0, end: 0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.bounceInOut));

    animation2 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(.50, 1.0, curve: Curves.fastOutSlowIn)));

    animation3 = Tween(begin: 1.0, end: 0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(.8, 1.0, curve: Curves.fastOutSlowIn)));
    super.initState();
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
        "Added successfully!!",
        // textAlign: TextAlign.justify,
        // textDirection: TextDirection.rtl,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text("You added new meeting to your list successfully"),
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

  void scheduleMeeting(String meetingdate) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/addNewMeeting.php';
    print("the data is");

    var response = await http.post(url, body: {
      "studentid": UserDta.userid,
      "doctorname": MeetingDetail.drname,
      "email": MeetingDetail.email,
      "doctornumber": MeetingDetail.phoneno,
      "meetingdate": meetingdate,
    });

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);
    if (res == 'Added new meeting successfully') {
      print("Added new meeting successfully");
      sendNotiifcation(
          MeetingDetail.doctorid,
          "You have a new meeting, check your meeting page",
          "New meeting added");
      showAlertDialog(context);
    } else {
      print("from static dta");
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

  Widget buildStack(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(color: Theme.of(context).primaryColor, height: 5),
        Column(
          children: <Widget>[
            SizedBox(height: 35),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Schedule here',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: drname,
                readOnly: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle, color: Colors.black),
                    labelText: 'Teacher name',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 14),
                    fillColor: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: email,
                readOnly: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle, color: Colors.black),
                    labelText: 'Teacher Email',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 14),
                    fillColor: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: number,
                readOnly: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle, color: Colors.black),
                    labelText: 'Teacher PhoneNo.',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 14),
                    fillColor: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: FlatButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        //   minTime: DateTime(2020, 5, 5, 20, 50),
                        //  maxTime: DateTime(2020, 6, 7, 05, 09),
                        onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      print('confirm $date');
                      datemeet = date.toString();
                      print(datemeet);
                    }, locale: LocaleType.en);
                  },
                  child: Text(
                    'show date time picker',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                  )),
              // TextField(
              //   //   controller: drname,
              //   // readOnly: true, schedule
              //   decoration: InputDecoration(
              //       prefixIcon: Icon(Icons.security, color: Colors.black),
              //       labelText: 'Select appropriate time',
              //       labelStyle: TextStyle(color: Colors.black, fontSize: 14),
              //       fillColor: Colors.black),
              // ),
            ),
            // FlatButton(
            //     onPressed: () {
            //       DatePicker.showDateTimePicker(context,
            //           showTitleActions: true,
            //           minTime: DateTime(2020, 5, 5, 20, 50),
            //           maxTime: DateTime(2020, 6, 7, 05, 09), onChanged: (date) {
            //         print('change $date in time zone ' +
            //             date.timeZoneOffset.inHours.toString());
            //       }, onConfirm: (date) {
            //         print('confirm $date');
            //       }, locale: LocaleType.ar);
            //     },
            //     child: Text(
            //       'show date time picker',
            //       style: TextStyle(color: Colors.blue),
            //     )),
          ],
        ),
        Positioned(
          // top: 280,
          // left: 190,
          top: 370,
          left: MediaQuery.of(context).size.width * .3,
          child: FloatingActionButton(
            onPressed: () {
              print('login complete');
              scheduleMeeting(datemeet);
            },
            heroTag: 'logintag',
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                iconSize: 20.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Theme.of(context).primaryColor,
              title: new Text(
                "Schedule a meeting",
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.white,
            body: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: _height * 0.1),
                Transform(
                  transform: Matrix4.translationValues(
                      0, animation2.value * _height, 0),
                  child: Text(
                    'Schedule a new meeting',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      // fontFamily: 'Quicksand',
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Transform(
                  transform: Matrix4.translationValues(
                      animation1.value * _width, 0, 0),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: _width * 0.15, right: _width * 0.15),
                    height: 400,
                    child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: buildStack(context),
                    ),
                    // FormBox(),
                  ),
                ),
                SizedBox(
                  height: 35,
                  width: 2,
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        });
  }

  Widget buildText() {
    return GestureDetector(
      onTap: () {
        print('go to signup form');
        Navigator.pushNamed(context, '/signup');
      },
      child: Text.rich(
        TextSpan(
          text: 'Do not have an account? ',
          style: TextStyle(fontFamily: 'Quicksand'),
          children: <TextSpan>[
            TextSpan(
                text: 'Signup',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                )),
            // can add more TextSpans here...
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
