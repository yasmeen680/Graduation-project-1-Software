import 'package:flutter/material.dart';
import 'UserDta.dart';
import 'DoctorsTabList.dart';
import 'package:http/http.dart' as http;
import 'DoctorTable.dart';
import 'dart:convert';
import 'DoctorIndo.dart';
import 'dart:math' as math;

class DoctorTableView extends StatefulWidget {
  DoctorTableViewState createState() => DoctorTableViewState();
}

class DoctorTableViewState extends State<DoctorTableView> {
  @override
  void initState() {
    super.initState();
    getDoctorTable();
  }

  // List<String> ss = ['sss', 'ddd', 'ccc', 'bbb', 'xxx'];

  Future getDoctorTable() async {
    DoctorsTabList.dl = new List();
    var url =
        'https://crenelate-intervals.000webhostapp.com/getDoctorSchedule.php';
    print("the data is");

    var response = await http.post(url,
        body: {"drname": DoctorInfo.drname}); //must pass here doctor name

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
          "View table",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: DoctorsTabList.dl.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: 20, bottom: 90, left: 20, right: 10),
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.8,
              child: SlidingCard(
                name: DoctorsTabList.dl[index].coursename,
                date: DoctorsTabList.dl[index].courseday, //officehrs courseTime
                officehrs: DoctorsTabList.dl[index].officehrs,
                courseTime: DoctorsTabList.dl[index].courseTime,
                assetName: '1111.jpg',
                offset: 0,
              ),
            );
          }),
    );
  }
}

class SlidingCard extends StatelessWidget {
  final String name;
  final String date;
  final String assetName;
  final String officehrs;
  final String courseTime;
  final double offset;

  const SlidingCard({
    Key key,
    @required this.name,
    @required this.date,
    @required this.assetName,
    @required this.officehrs,
    @required this.courseTime,
    @required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Card(
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              child: Image.asset(
                'assets/$assetName',
                height: MediaQuery.of(context).size.height * 0.3,
                alignment: Alignment(-offset.abs(), 0),
                fit: BoxFit.none,
              ),
            ),
            SizedBox(height: 18),
            Expanded(
              child: CardContent(
                name: name,
                date: date,
                courseTime: courseTime,
                officehrs: officehrs,
                offset: gauss,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final String name;
  final String date;
  final String courseTime;
  final String officehrs;
  final double offset;

  const CardContent(
      {Key key,
      @required this.name,
      @required this.date,
      @required this.courseTime,
      @required this.officehrs,
      @required this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                "Course name:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Transform.translate(
                  offset: Offset(8 * offset, 0),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 120,
                    ),
                    child: Text(name,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  )),
            ],
          ),
          SizedBox(height: 18),
          Row(children: [
            Text(
              "Course days:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Transform.translate(
              offset: Offset(32 * offset, 0),
              child: Text(
                date,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            )
          ]),
          SizedBox(height: 18),
          Row(children: [
            Text(
              "Course time:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Transform.translate(
              offset: Offset(32 * offset, 0),
              child: Text(
                courseTime,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ]),

          SizedBox(height: 18),
          Row(children: [
            Text(
              "Office hrs:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Transform.translate(
              offset: Offset(32 * offset, 0),
              child: Text(
                officehrs,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ]),

          Spacer(),
          // Row(
          //   children: <Widget>[
          //     Transform.translate(
          //       offset: Offset(48 * offset, 0),
          //       child: RaisedButton(
          //         color: Color(0xFF162A49),
          //         child: Transform.translate(
          //           offset: Offset(24 * offset, 0),
          //           child: Text('Reserve'),
          //         ),
          //         textColor: Colors.white,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(32),
          //         ),
          //         onPressed: () {},
          //       ),
          //     ),
          //     Spacer(),
          //     Transform.translate(
          //       offset: Offset(32 * offset, 0),
          //       child: Text(
          //         '0.00 \$',
          //         style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           fontSize: 20,
          //         ),
          //       ),
          //     ),
          //     SizedBox(width: 16),
          //   ],
          // )
        ],
      ),
    );
  }
}
