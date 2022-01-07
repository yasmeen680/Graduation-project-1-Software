import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:io';
import 'UserDta.dart';
import 'DoctorChatPage.dart';
import 'DoctorNotifications.dart';
import 'WelcomePage.dart';
import 'HomePageDoctor.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'dart:convert';
import 'DoctorDocs.dart';
import 'DoctorDocsList.dart';
import 'DocsViewer.dart';
import 'DocsPath.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorSlides extends StatefulWidget {
  DoctorSlidesState createState() => DoctorSlidesState();
}

class DoctorSlidesState extends State<DoctorSlides> {
  File toupload;
  TextEditingController coursenameController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  PDFDocument document;

  Future getFile(String coursename) async {
    FilePickerResult _pickedfile = await FilePicker.platform.pickFiles();

    if (_pickedfile != null) {
      print("the picked file is");
      setState(() {
        toupload = File(_pickedfile.files.single.path);
      });
      print(toupload);
      print(_pickedfile.files.single.name);
      upload(toupload, coursename);
    }
  }

  void _showSnackBarMag(String msg) {
    _scaffoldstate.currentState
        .showSnackBar(new SnackBar(content: new Text(msg)));
  }

  Future getAllFiles() async {
    DoctorDocsList.dl = new List();
    var url = 'https://crenelate-intervals.000webhostapp.com/getDoctorDocs.php';
    print("the data is");

    var response = await http
        .post(url, body: {"name": UserDta.userid}); //must pass here doctor name

    print("status code is");
    print(response.statusCode);

    final res = json.decode(response.body);

    if (res == 'Failed to get DoctorsDocs') {
      print("Failed to get DoctorsDocs");
    } else {
      print("get DoctorsDocs successfully");

      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> doclist = jsonObj[i];

        String coursepath = doclist['path'];
        String coursename = doclist['coursename'];
        String uploaddate = doclist['uploaddate'];
        String des = doclist['des'];

        DoctorDocs dd = new DoctorDocs();
        dd.coursename = coursename;
        dd.coursepath = coursepath;
        dd.uploaddate = uploaddate;
        dd.des = des;

        DoctorDocsList.dl.add(dd);
      }
      setState(() {});
    }
  }

  void enterCourse(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: new Container(
              width: 260.0,
              height: 100.0,
              decoration: new BoxDecoration(
                color: const Color(0xFFFFFF),
                //   borderRadius: new BorderRadius.all(new Radius.circular(60.0)),
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // dialog top
                  //  new Expanded(
                  //    child: new
                  Row(
                    children: <Widget>[
                      new Container(
                        // padding: new EdgeInsets.all(10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                        ),
                        child: new Text(
                          'Enter course name:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            //  fontFamily: 'helvetica_neue_light',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  //    ),

                  // dialog centre
                  // new Expanded(
                  //  child: new
                  Container(
                      child: new TextField(
                    controller: coursenameController,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: new EdgeInsets.only(
                          left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                      hintText: 'course name',
                      hintStyle: new TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12.0,
                        //   fontFamily: 'helvetica_neue_light',
                      ),
                    ),
                  )),
                  //  flex: 2,
                  //  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: RaisedButton(
                      child: new Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.indigo[800],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        print("coursename is:$coursenameController.text");
                        getFile(coursenameController.text);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: RaisedButton(
                      child: new Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.indigo[800],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              )
            ],
          );
        });
  }

  void upload(filepath, String coursename) async {
    String fileName = basename(filepath.path);
    print("filename is:$fileName");

    print("data upload is:");
    print(fileName);
    print(filepath.path);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    print("formatteddate is:$formattedDate");

    try {
      FormData formdata = new FormData.fromMap(
        {
          "name": UserDta.userid,
          "des": "Doctor",
          "coursename": coursename,
          "uploaddate": formattedDate,
          "file":
              await MultipartFile.fromFile(filepath.path, filename: fileName),
        },
      );

      Response res = await Dio().post(
          "https://crenelate-intervals.000webhostapp.com/uploads.php",
          data: formdata);
      print("upload result is:$res");
      _showSnackBarMag(res.data['message']);

      setState(() {
        getAllFiles();
      });

      getStudentlist(coursename, "New file uploaded",
          "Your doctor upload new document for: " + coursename);
    } catch (e) {}
  }

  Future getStudentlist(String course, String content, String exp) async {
    var url =
        'https://crenelate-intervals.000webhostapp.com/getStudentlist.php';
    print("user id is:");
    print(UserDta.userid);

    var response = await http.post(url, body: {"course": course});

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'Failed to get student list') {
      print("Failed to get student list");
    } else {
      print("get student list successfully");

      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> doclist = jsonObj[i];
        String StudentId = doclist['StudentId'];
        String StudentName = doclist['StudentName'];

        sendNotiifcation(StudentId, exp, content);
      }
      setState(() {});
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

  @override
  void initState() {
    super.initState();
    getAllFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "Useful documents",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          )),
      backgroundColor: Colors.white,
      key: _scaffoldstate,
      body: DoctorDocsList.dl.length == 0
          ? Center(
              child: new Text("Loading your documents..."),
            )
          : Container(
              margin: EdgeInsets.all(5.0),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: DoctorDocsList.dl.length,
                //    itemExtent: 100.0,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: Colors.indigo[800], width: 1)),
                          child: ListTile(
                            trailing: Icon(Icons.arrow_forward),
                            title: Text(
                              DoctorDocsList.dl[index].coursename,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(DoctorDocsList.dl[index].uploaddate),
                            onTap: () {
                              DocsPath.DocsPathName =
                                  DoctorDocsList.dl[index].coursepath;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new DocsViewer()));
                            },
                          )),
                      SizedBox(
                        height: 15.0,
                      )
                    ],
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo[800],
        onPressed: () => setState(() {
          enterCourse(context);
          // getFile();
        }),
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
