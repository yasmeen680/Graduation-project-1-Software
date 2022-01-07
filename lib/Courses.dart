import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CoursesList.dart';
import 'CourseData.dart';
import 'UserDta.dart';

class Courses extends StatefulWidget {
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  Future getCourses() async {
    CourseList.cl = new List();
    var url =
        'https://crenelate-intervals.000webhostapp.com/getStudentCourses.php';
    print("the data is");

    var response = await http.post(url, body: {"StudentId": UserDta.userid});

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'Failed to Student get Courses') {
      print("Failed to Student get Courses");
    } else {
      print(" Student get Courses successfully");

      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> doclist = jsonObj[i];
        String drname = doclist['drname'];
        String course = doclist['course'];
        String day = doclist['day'];
        String coursetime = doclist['coursetime'];
        String officehrs = doclist['officehrs'];
        String drid = doclist['doctortable'];

        CourseData cd = new CourseData();
        cd.drname = drname;
        cd.coursename = course;
        cd.courseday = day;
        cd.coursetime = coursetime;
        cd.drofficehrs = officehrs;
        cd.drid = drid;

        CourseList.cl.add(cd);
        print("student course length is");
        print(CourseList.cl.length.toString());
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  final makeBody = Container(
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: CourseList.cl.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
              decoration: BoxDecoration(color: Colors.indigo[800]),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.white24))),
                  child: Icon(Icons.autorenew, color: Colors.white),
                ),
                title: Text(
                  CourseList.cl[index].coursename,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //  Icon(Icons.linear_scale, color: Colors.yellowAccent),
                    Text(CourseList.cl[index].drname,
                        style: TextStyle(color: Colors.white)),
                    Text(CourseList.cl[index].courseday,
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                trailing: new Text(CourseList.cl[index].coursetime),
              )),
        );
      },
    ),
  );
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: AppBar(
    //     centerTitle: true,
    //     leading: IconButton(
    //       icon: Icon(
    //         Icons.arrow_back_ios,
    //         color: Colors.white,
    //       ),
    //       iconSize: 20.0,
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //     ),
    //     backgroundColor: Theme.of(context).primaryColor,
    //     title: new Text(
    //       "Courses",
    //       style: TextStyle(color: Colors.white),
    //     ),
    //   ),
    //   body: CourseList.cl.length == 0
    //       ? Center(
    //           child: new Text("Loading data..."),
    //         )
    //       : makeBody,

    // );
    return Scaffold(
      backgroundColor: Colors.indigo[800],
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('My',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
                SizedBox(width: 10.0),
                Text('Courses',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 25.0))
              ],
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: MediaQuery.of(context).size.height - 185.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 45.0),
                    child: Container(
                        height: MediaQuery.of(context).size.height - 300.0,
                        child:

                            //  ListView(
                            ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: CourseList.cl.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildFoodItem(
                                      'assets/32.png',
                                      CourseList.cl[index].coursename,
                                      CourseList.cl[index].drname,
                                      CourseList.cl[index].courseday,
                                      CourseList.cl[index].coursetime);
                                  //   ]
                                }))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFoodItem(String imgPath, String coursename, String drname,
      String courseday, String coursetime) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 5.0, top: 10.0),
        child: InkWell(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => DetailsPage(heroTag: imgPath, foodName: foodName, foodPrice: price)
              // ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(children: [
                  Hero(
                      tag: imgPath,
                      child: Image(
                          image: AssetImage(imgPath),
                          fit: BoxFit.cover,
                          height: 75.0,
                          width: 75.0)),
                  SizedBox(width: 5.0),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Text(coursename,
                              style: TextStyle(
                                  //   fontFamily: 'Montserrat',
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Text(drname,
                            style: TextStyle(
                                //  fontFamily: 'Montserrat',
                                fontSize: 15.0,
                                color: Colors.grey)),
                        Text(courseday,
                            style: TextStyle(
                                //  fontFamily: 'Montserrat',
                                fontSize: 15.0,
                                color: Colors.grey))
                      ])
                ])),
                new Text(
                  coursetime,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            )));
  }
}
