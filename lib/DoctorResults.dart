import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'DoctorChatPage.dart';
import 'DoctorNotifications.dart';
import 'WelcomePage.dart';
import 'HomePageDoctor.dart';
import 'DoctorResultsStudentmark.dart';
import 'UserDta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'DoctorTable.dart';
import 'DoctorsTabList.dart';
import 'ExamsData.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorResults extends StatefulWidget {
  DoctorResultsState createState() => DoctorResultsState();
}

class DoctorResultsState extends State<DoctorResults> {
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<DoctorTable>> key = new GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  void _showSnackBarMag(String msg) {
    _scaffoldstate.currentState
        .showSnackBar(new SnackBar(content: new Text(msg)));
  }

  @override
  void initState() {
    super.initState();
    print("DoctorResults is called");
    getDoctorTable();

    searchTextField = AutoCompleteTextField<DoctorTable>(
        style: new TextStyle(color: Colors.black, fontSize: 16.0),
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
            filled: true,
            hintText: 'Search for course..',
            hintStyle: TextStyle(color: Colors.black)),
        itemSubmitted: (item) {
          setState(() {
            print("item submitted");
            searchTextField.textField.controller.text = item.coursename;
          });
        },
        clearOnSubmit: true,
        key: key,
        suggestions: DoctorsTabList.dl,
        itemBuilder: (context, item) {
          return
              // AnimationConfiguration.staggeredGrid(
              //                     columnCount: 2,
              //                     position: index,
              //                     duration: const Duration(milliseconds: 375),
              //                     child:
              //   ScaleAnimation(
              // scale: 0.5,
              // child: FadeInAnimation(
              //     child:
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                GestureDetector(
                  onTap: () {
                    CourseName.coursename = item.coursename;
                    print("before go to DoctorResultStudentMarks");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                new DoctorResultsStudentmark()));
                  },
                  child:
                      //  Column(
                      //   mainAxisAlignment:
                      //       MainAxisAlignment.start,
                      //   crossAxisAlignment:
                      //       CrossAxisAlignment.start,
                      //   children: [
                      Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 120,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/docres.png"),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: new Text(" "),
                  ),
                  //   ],
                  //   )
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  // mainAxisAlignment:
                  //     MainAxisAlignment.start,
                  // crossAxisAlignment:
                  //     CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.coursename,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      // style: kTitleTextStyle,
                    ),
                  ],
                ),
              ]);
          // ),
          // );
          // )
          //;
        },
        itemSorter: (a, b) {
          return a.coursename.compareTo(b.coursename);
        },
        itemFilter: (item, query) {
          return item.coursename.toLowerCase().startsWith(query.toLowerCase());
        });
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
            SizedBox(
              height: 10,
            ),
            Text(
              "Fill student marks for each course ",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                // margin: EdgeInsets.symmetric(vertical: 30),
                // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                // height: 60,
                // width: double.infinity,
                // decoration: BoxDecoration(
                //   color: Color(0xFFF5F5F7),
                //   borderRadius: BorderRadius.circular(40),
                // ),
                child: searchTextField
                //  Row(
                //   children: <Widget>[
                //     IconButton(
                //       icon: Icon(FontAwesomeIcons.search),
                //       onPressed: () {},
                //     ),
                //     //  SvgPicture.asset("assets/icons/search.svg"),
                //     SizedBox(width: 16),
                //     Text(
                //       "Search for course",
                //       style: TextStyle(
                //         fontSize: 18,
                //         color: Color(0xFFA0A5BD),
                //       ),
                //     )
                //   ],
                // ),
                ),
            SizedBox(height: 30),
            DoctorsTabList.dl.length == 0
                ? Center(
                    child: new Text(
                      "Waiting to load data..",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                : Expanded(
                    child: AnimationLimiter(
                      child: GridView.count(
                        childAspectRatio: 1.0,
                        crossAxisCount: 2,
                        children: List.generate(
                          DoctorsTabList.dl.length,
                          (int index) {
                            return AnimationConfiguration.staggeredGrid(
                              columnCount: 2,
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: ScaleAnimation(
                                scale: 0.5,
                                child: FadeInAnimation(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                      GestureDetector(
                                        onTap: () {
                                          CourseName.coursename = DoctorsTabList
                                              .dl[index].coursename;
                                          print(
                                              "before go to DoctorResultStudentMarks");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      new DoctorResultsStudentmark()));
                                        },
                                        child:
                                            //  Column(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.start,
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.start,
                                            //   children: [
                                            Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          height: 120,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/docres.png"),
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight:
                                                      Radius.circular(30))),
                                          child: new Text(" "),
                                        ),
                                        //   ],
                                        //   )
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.start,
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            DoctorsTabList.dl[index].coursename,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            // style: kTitleTextStyle,
                                          ),
                                        ],
                                      ),
                                    ])),
                              ),
                            );
                          },
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
