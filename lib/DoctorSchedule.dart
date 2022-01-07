import 'package:flutter/material.dart';
import 'doctorScheduleBody.dart';
import 'HomePageDoctor.dart';
import 'DoctorChatPage.dart';
import 'WelcomePage.dart';
import 'DoctorNotifications.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'DoctorsTabList.dart';
import 'UserDta.dart';
import 'DoctorTable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorSchedule extends StatefulWidget {
  _DoctorScheduleState createState() => _DoctorScheduleState();
}

class _DoctorScheduleState extends State<DoctorSchedule> {
  @override
  void initState() {
    super.initState();
    print("DoctorSchedule is called");
    getDoctorTable();
  }

  Future getDoctorTable() async {
    DoctorsTabList.dl = new List();
    var url =
        'https://crenelate-intervals.000webhostapp.com/getDoctorSchedule.php';
    print("user id is:");
    print(UserDta.userid);

    var response = await http.post(url,
        body: {"drname": UserDta.username}); //must pass here doctor name

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'failed to get doctor schedule') {
      print("failed to get doctor schedule");
    } else {
      print("get doctor schedule successfully");

      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> doclist = jsonObj[i];
        String officehrs = doclist['officehrs'];
        String course = doclist['course'];
        String day = doclist['day'];
        String coursetime = doclist['coursetime'];

        DoctorTable cd = new DoctorTable();
        cd.officehrs = officehrs;
        cd.coursename = course;
        cd.courseday = day;
        cd.courseTime = coursetime;

        DoctorsTabList.dl.add(cd);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Text(
                "My schedule",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          )),
      backgroundColor: Colors.white,
      body: DoctorsTabList.dl.length == 0
          ? Center(
              child: new Text("Waiting to load data..."),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: new Container(
                    color: Colors.white,
                    child: new CustomScrollView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        new SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          sliver: new SliverList(
                            delegate: new SliverChildBuilderDelegate(
                              (context, index) => new DoctorScheduleBody(
                                  DoctorsTabList.dl[index].coursename,
                                  DoctorsTabList.dl[index].courseTime,
                                  DoctorsTabList.dl[index].courseday,
                                  DoctorsTabList.dl[index].officehrs),
                              childCount: DoctorsTabList.dl.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (value) async {
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
