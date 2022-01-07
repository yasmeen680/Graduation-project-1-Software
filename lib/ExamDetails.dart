import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'UserDta.dart';
import 'dart:convert';
import 'ExamDetailList.dart';
import 'ExamDelPass.dart';

class ExamDetails extends StatefulWidget {
  ExamDetails({Key key}) : super(key: key);

  @override
  _ExamDetailsState createState() => _ExamDetailsState();
}

class _ExamDetailsState extends State<ExamDetails> {
  var mainColor = Colors.indigo[800];

  @override
  Widget build(BuildContext context) {
    var halfSide = MediaQuery.of(context).size.width / 1.5;
    var side = halfSide * sqrt(2);

    var _borders = OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(32));

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          "Exam Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              color: Colors.grey[200],
            ),
          ),
          Image.asset(
            'assets/13.jpg',
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitHeight,
          ),
          Align(
            alignment: Alignment(0, 0.35),
            child: Transform.rotate(
              angle: pi / 4,
              child: Material(
                elevation: 5,
                shadowColor: Colors.black,
                color: mainColor,
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  height: side,
                  width: side,
                  child: Transform.rotate(
                    angle: -pi / 4,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text("First:",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  new Text(
                                    ExamDetlPass.first,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              )),
                          SizedBox(height: 10),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text("Second:",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  new Text(
                                    ExamDetlPass.second,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              )),
                          SizedBox(height: 10),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text("Final:",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  new Text(
                                    ExamDetlPass.finald,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              )),
                          SizedBox(height: 10),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text("Dr. name:",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  new Text(
                                    ExamDetlPass.drname,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              )),
                          SizedBox(height: 10),
                          // Container(
                          //     width: MediaQuery.of(context).size.width * 0.8,
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         new Text("Other info:",
                          //             style: TextStyle(
                          //                 fontSize: 17,
                          //                 fontWeight: FontWeight.bold,
                          //                 color: Colors.white)),
                          //         SizedBox(
                          //           width: 10,
                          //         ),
                          //         new Text(
                          //           ExamDetlPass.otherinfo,
                          //           style: TextStyle(
                          //               fontSize: 17,
                          //               fontWeight: FontWeight.bold,
                          //               color: Colors.white),
                          //         ),
                          //       ],
                          //     )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
