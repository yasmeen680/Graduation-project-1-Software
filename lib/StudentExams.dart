import 'package:flutter/material.dart';
import 'ExamDetails.dart';
import 'package:http/http.dart' as http;
import 'UserDta.dart';
import 'dart:convert';
import 'ExamDetailList.dart';
import 'ExamDetail.dart';
import 'ExamDelPass.dart';

class Exams extends StatefulWidget {
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {
  @override
  void initState() {
    super.initState();
    getExamDetails();
  }

  Future getExamDetails() async {
    ExamDetailList.el = new List();
    var url =
        'https://crenelate-intervals.000webhostapp.com/getStudentExams.php';
    print("the data is");

    var response = await http.post(url,
        body: {"StudentId": UserDta.userid}); //must pass here doctor name

    print("status code is");
    print(response.statusCode);

    final res = json.decode(response.body);

    if (res == 'Failed to get student exams') {
      print("Failed to get student exams");
    } else {
      print("get student exams successfully");

      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> doclist = jsonObj[i];
        String drname = doclist['drname'];
        String firstdate = doclist['firstdate'];
        String firsttime = doclist['firsttime'];
        String seconddate = doclist['seconddate'];
        String secondtime = doclist['secondtime'];
        String finaldate = doclist['finaldate'];
        String finaltime = doclist['finaltime'];
        String otherinfo = doclist['otherinfo'];
        String course = doclist['course'];
        ExamDetail ed = new ExamDetail();

        ed.drname = drname;
        ed.first = firstdate + '  ' + firsttime;
        ed.second = seconddate + '  ' + secondtime;
        ed.finald = finaldate + '  ' + finaltime;
        ed.otherinfo = otherinfo;
        ed.course = course;

        ExamDetailList.el.add(ed);
      }
      setState(() {});
    }
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
          "Exams",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(top: 10),
          color: Colors.white,
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(ExamDetailList.el.length, (index) {
              return GestureDetector(
                  child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                margin: EdgeInsets.fromLTRB(10, 2, 10, 5),
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0, 5, 0),
                      child: SizedBox(
                        height: 120,
                        child: GestureDetector(
                          onTap: () async {},
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: new ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  child: Image.asset(
                                    "assets/29.png",
                                    fit: BoxFit.cover,
                                  ))),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10.0, top: 8),
                          child: Text(
                            ExamDetailList.el[index].course,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              //  fontFamily: "palfont",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                icon: new Icon(Icons.arrow_forward),
                                color: Colors.white,
                                onPressed: () async {
                                  ExamDetlPass.drname =
                                      ExamDetailList.el[index].drname;
                                  ExamDetlPass.first =
                                      ExamDetailList.el[index].first;
                                  ExamDetlPass.second =
                                      ExamDetailList.el[index].second;
                                  ExamDetlPass.finald =
                                      ExamDetailList.el[index].finald;
                                  ExamDetlPass.otherinfo =
                                      ExamDetailList.el[index].otherinfo;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              new ExamDetails()));
                                },
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ));
            }),
          )),
    );
  }
}
