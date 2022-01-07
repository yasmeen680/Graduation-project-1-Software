import 'package:elearning_project/DoctorMeetingsWithStu.dart';
import 'package:elearning_project/DoctorSchedule.dart';
import 'package:elearning_project/DoctorSlides.dart';
import 'package:flutter/material.dart';
import 'WelcomePage.dart';
import 'UserDta.dart';
import 'WelcomePage.dart';
import 'DoctorChatPage.dart';
import 'DoctorNotifications.dart';
import 'ContactadmDoctor.dart';
import 'DoctorLeavesVaca.dart';
import 'CoursesRegDoc.dart';
import 'DoctorResults.dart';
import 'DoctorProfile.dart';
import 'DoctorExams.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageDoctor extends StatefulWidget {
  _HomePageDoctorState createState() => _HomePageDoctorState();
}

class _HomePageDoctorState extends State<HomePageDoctor> {
  SharedPreferences sh;
  List<String> images = [
    'schedule.png',
    'meetings.jpg',
    'registration.png',
    '24.png',
    'doctorresults.png',
    '27.jpg',
    '31.png',
    //'16.jpg',
    '20.png',
    '23.jpg'
  ];

  List<String> names = [
    'Schedule',
    'Student mettings',
    'Courses registration',
    'Courses documents',
    'Student results',
    'Exams',
    'Vacations',
    // 'Courses',
    'Profile',
    'Contact admin'
  ];

  @override
  void initState() {
    super.initState();
    print("Main doctorhomepage");
    signInWithEmailAndPassword();
  }

  User uu;
  Future signInWithEmailAndPassword() async {
    try {
      //"hanal@gmail.com"
      sh = await SharedPreferences.getInstance();
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: UserDta.email, password: UserDta.pass); //"98765432"
      print("the user credential is :");
      print(result.user);
      uu = result.user;
      print("email credential is");
      print(uu.uid);
      print(uu.email);
      sh.setString("uid", uu.uid.toString());
      UserDta.uid = uu.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //  resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Text(
                "Home Page",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              new Text(
                UserDta.username.toString(),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          )),
      body: Container(
          padding: EdgeInsets.only(top: 10),
          color: Colors.white,
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(names.length, (index) {
              return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new DoctorSchedule()));
                    } else if (index == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  new DoctorMeetingWithStu()));
                    } else if (index == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  new DocCoursesRegistration()));
                    } else if (index == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new DoctorSlides()));
                    } else if (index == 4) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new DoctorResults()));
                    } else if (index == 5) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              //DoctorLeavesVaca
                              builder: (context) => new DoctorExams()));
                    } else if (index == 6) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              //Vacations
                              builder: (context) => new DoctorLeavesVaca()));
                    }
                    // else if (index == 7) {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           //DoctorCoursesStud
                    //           builder: (context) => new HotelHomeScreen()));
                    // }
                    else if (index == 7) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new DoctorProfile()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new ContactAdminDoctor()));
                    }
                  },
                  child: Column(
                    children: [
                      new Container(
                          width: 140.0,
                          height: 140.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new AssetImage(
                                      'assets/' + images[index])))),
                      Container(
                        child: new Text(
                          names[index],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      )
                    ],
                  ));
            }),
          )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (value) async {
          if (value == 1) {
            //await FirebaseAuth.instance.signOut();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new DoctorNotificationPage()));
          } else if (value == 0) {
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
      // )
    );
  }
}
