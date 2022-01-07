import 'package:flutter/material.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'UserDta.dart';
import 'ResultDetailList.dart';
import 'ResultDetail.dart';

class Results extends StatefulWidget {
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  void initState() {
    super.initState();
    getStudentResults();
  }

  Future getStudentResults() async {
    ResultDetailList.rl = new List();
    var url =
        'https://crenelate-intervals.000webhostapp.com/StudentResults.php';
    print("the data is");

    var response = await http.post(url,
        body: {"studentid": UserDta.userid}); //must pass here doctor name

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'Failed to get student results') {
      print("Failed to get student results");
    } else {
      print("success to get student results");

      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> doclist = jsonObj[i];
        String fm = doclist['firstd'];
        String sm = doclist['second'];
        String fim = doclist['finald'];
        String coursename = doclist['coursename'];

        ResultDetail cd = new ResultDetail();
        cd.fm = fm;
        cd.sm = sm;
        cd.fim = fim;
        cd.coursename = coursename;

        ResultDetailList.rl.add(cd);
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
          "Results",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: ResultDetailList.rl.length,
          itemBuilder: (context, index) {
            return new Column(
              children: [
                ExpansionCard(
                  borderRadius: 30,
                  title: Card(
                      // margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      child: Container(
                        //  width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Image.asset(
                                "assets/28.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                new Text(ResultDetailList.rl[index].coursename,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ))
                          ],
                        ),
                      )),
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                            side: BorderSide(
                                color: Colors.indigo[800], width: 2)),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text("First mark:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black)),
                                      ),
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 7),
                                          child: Text(
                                            ResultDetailList.rl[index].fm,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Text("second mark:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.black)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 7),
                                          child: Text(
                                              ResultDetailList.rl[index].sm,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.black)),
                                        ),
                                      ]),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Text("Final mark:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.black)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 7),
                                          child: Text(
                                              ResultDetailList.rl[index].fim,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.black)),
                                        ),
                                      ]),
                                ],
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ],
            );
          }),
    );
  }
}
