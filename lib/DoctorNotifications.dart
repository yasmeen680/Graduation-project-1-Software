import 'package:elearning_project/ChatPage.dart';
import 'package:elearning_project/MainHomePage.dart';
import 'package:elearning_project/UserDta.dart';
import 'package:flutter/material.dart';
import 'WelcomePage.dart';
import 'DoctorChatPage.dart';
import 'HomePageDoctor.dart';
import 'NotificationContent.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class DoctorNotificationPage extends StatefulWidget {
  DoctorNotificationPageState createState() => DoctorNotificationPageState();
}

class DoctorNotificationPageState extends State<DoctorNotificationPage> {
  @override
  void initState() {
    super.initState();
    print("ResponsibleNotificationState is called");
    getNotificationContent();
  }

  Future getNotificationContent() async {
    NotificationContentlist.li = new List();
    var url1 =
        'https://crenelate-intervals.000webhostapp.com/getNoticContent.php';
    print("getNotificationContent api:");

    var response = await http.post(url1, body: {"recid": UserDta.userid});

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);
    print("notification res is:$res");

    if (res == 'Failed to get notification content') {
      print("Failed to get notification content");
    } else {
      print("get notification content successfully");

      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> doclist = jsonObj[i];

        //senderid,content,exp,datess
        String senderid = doclist['senderid'];
        String content = doclist['content'];
        String exp = doclist['exp'];
        String datess = doclist['datess'];

        NotificationContent gd = new NotificationContent();

        gd.senderid = senderid;
        gd.content = content;
        gd.exp = exp;
        gd.datee = datess;

        NotificationContentlist.li.add(gd);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: new Text(
          "Notification Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: NotificationContentlist.li.length == 0
          ? Center(
              child: new Text("You haven't notification yet"),
            )
          : ListView.builder(
              itemCount: NotificationContentlist.li.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(NotificationContentlist.li[index].content)
                      ]),
                  subtitle: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 2, top: 4, left: 6, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Text("Notification content:",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 5.0, right: 5.0, bottom: 5.0),
                              constraints: const BoxConstraints(maxWidth: 154),
                              child: new Text(
                                  NotificationContentlist.li[index].exp,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 2, top: 4, left: 6, right: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Text("Notification date:     ",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                            Container(
                              constraints: BoxConstraints(maxWidth: 150),
                              child: new Text(
                                  NotificationContentlist.li[index].datee,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              //  separatorBuilder: (context, index) {},
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[300],
        currentIndex: 1,
        onTap: (value) async {
          if (value == 0) {
            // await FirebaseAuth.instance.signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new HomePageDoctor()));
          } else if (value == 1) {
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
          BottomNavigationBarItem(
              icon: Icon(Icons.message), title: Text('Chat')),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout), title: Text('Logout'))
        ],
      ),
    );
  }
}
