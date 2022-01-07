import 'package:flutter/material.dart';
import 'NotificationPage.dart';
import 'SettingsPage.dart';
import 'WelcomePage.dart';
import 'UserDta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'MeetingData.dart';
import 'MeetingList.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';

class HomePageStudent extends StatefulWidget {
  _HomePageStudentState createState() => _HomePageStudentState();
}

class _HomePageStudentState extends State<HomePageStudent> {
  void initState() {
    super.initState();
    print("homepagestudents");
    getMeetings();
  }

  Future getMeetings() async {
    MeetingList.list = new List();
    var url =
        'https://crenelate-intervals.000webhostapp.com/getStudentMeetings.php';

    print("student id is:");
    print(UserDta.userid);
    var response = await http.post(url, body: {"studentid": UserDta.userid});

    final res = json.decode(response.body);

    if (res == 'Failed to get meetings') {
      print("Failed to get meetings");
    } else {
      print("get meetings successfully");

      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> meetlist = jsonObj[i];
        String drname = meetlist['doctorname'];
        String email = meetlist['email'];
        String drnumber = meetlist['doctornumber'];
        String meetingdate = meetlist['meetingdate'];

        print(drname);
        print(email);
        print(drnumber);
        print(meetingdate);

        MeetingData md = new MeetingData();
        md.email = email;
        md.drname = drname;
        md.drnumber = drnumber;
        md.meetingdate = meetingdate;

        MeetingList.list.add(md);
      }
      setState(() {});
    }
  }

  Widget _buildList() {
    var widthsize = MediaQuery.of(context).size.width;

    return MeetingList.list.length == 0
        ? Center(
            child: new Text("Wait to load data..."),
          )
        : ListView.builder(
            itemCount: MeetingList.list.length,
            itemBuilder: (context, index) {
              return Column(children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 0.0, top: 0, bottom: 0),
                      child: GestureDetector(
                        onTap: () async {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // image: DecorationImage(
                            //   image: NetworkImage(
                            //     "",
                            //   ),
                            //   fit: BoxFit.fill,
                            // ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .3,
                                        child: Text(
                                          "Doctor name: ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   width: 20,
                                      // ),
                                      Expanded(
                                          //flex: 2,
                                          child: new Text(
                                        MeetingList.list[index].drname,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ))
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .3,
                                          child: Text(
                                            "Email: ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      // SizedBox(
                                      //   width: 20,
                                      // ),
                                      Expanded(
                                          child: new Text(
                                        MeetingList.list[index].email,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ))
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .3,
                                          child: Text(
                                            "Contact no: ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      // SizedBox(
                                      //   width: 20,
                                      // ),
                                      Expanded(
                                          child: new Text(
                                        MeetingList.list[index].drnumber,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ))
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .3,
                                          child: Text(
                                            "Meeting date: ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      // SizedBox(
                                      //   width: 20,
                                      // ),
                                      Expanded(
                                          child: new Text(
                                        MeetingList.list[index].meetingdate,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    padding: const EdgeInsets.all(0),
                                    height: 50, //45,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                print(
                                                    "Join meeting feature inside student view");
                                                AppAvailability.launchApp(
                                                        //https://play.google.com/store/apps/details?id=us.zoom.videomeetings
                                                        'us.zoom.videomeetings')
                                                    .then((response) {
                                                  print(
                                                      "open app successfully");
                                                }).catchError((err) {
                                                  print(
                                                      "catch error when open app");
                                                  print(err);
                                                });
                                              },
                                              child: new Text(
                                                "Join the meeting",
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                      )),
                  margin: EdgeInsets.only(top: 8, left: 10, right: 10),
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.grey,
                  width: widthsize,
                  height: 1.0,
                  margin: EdgeInsets.only(left: 0.0),
                ),
              ]);
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          "My Meetings",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _buildList(),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.white,
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: Colors.blue[300],
      //   currentIndex: 0,
      //   onTap: (value) async {
      //     value == 1
      //         ? Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => new NotificationPage()))
      //         : value == 2
      //             ? Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => new SettingsPage()))
      //             : Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => new WelcomePage()));
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: new Icon(Icons.home),
      //       title: new Text('Home'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: new Icon(Icons.notifications),
      //       title: new Text('Notifications'),
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.settings), title: Text('Settings')),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.logout), title: Text('Logout'))
      //   ],
      // ),
    );
  }
}
