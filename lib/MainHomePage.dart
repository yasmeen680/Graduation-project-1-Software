import 'package:elearning_project/Growth.dart';
import 'package:elearning_project/HomePageStudent.dart';
import 'package:elearning_project/UsefulDocs.dart';
import 'package:flutter/material.dart';
import 'NotificationPage.dart';
import 'WelcomePage.dart';
import 'ChatPage.dart';
import 'UserDta.dart';
import 'ContactAdmin.dart';
import 'Courses.dart';
import 'Doctors.dart';
import 'Courses.dart';
import 'Profile.dart';
import 'StudentExams.dart';
import 'StudentResults.dart';
import 'Vacations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainHomePage extends StatefulWidget {
  @override
  MainHomePageState createState() => MainHomePageState();
}

class MainHomePageState extends State<MainHomePage> {
  SharedPreferences sh;
  List<String> paths = [
    'HomePageStudent',
    'Courses',
    'Results',
    'UsefulDocs',
    'Growth',
    'Profile',
    'ContactAdmin'
        'Exams',
    'Vacations',
    'Doctors'
  ];

  List<String> images = [
    '13.jpg',
    '16.jpg',
    '28.png',
    '24.png',
    '18.jpg',
    '20.png',
    '23.jpg',
    '29.png',
    '31.png',
    '32.png'
  ];

  List<String> names = [
    'Meetings',
    'Courses',
    'Results',
    'Useful documents',
    'Growth',
    'Profile',
    'Contact admin',
    'Exams',
    'Vacations',
    'Doctors'
  ];

  @override
  void initState() {
    super.initState();
    print("Main homepage");
    signInWithEmailAndPassword();
  }

  Future signInWithEmailAndPassword() async {
    try {
      //"hanal@gmail.com"
      sh = await SharedPreferences.getInstance();
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: UserDta.email, password: UserDta.pass); //"98765432"
      print("the user credential is :");
      print(result.user);
      User uu = result.user;
      print("email credential is");
      print(uu.uid);
      print(uu.email);
      sh.setString("uid", uu.uid);
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
      //  resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          //  centerTitle: true,
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
            children: List.generate(10, (index) {
              return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new HomePageStudent()));
                    } else if (index == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Courses()));
                    } else if (index == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Results()));
                    } else if (index == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new UsefulDocs()));
                    } else if (index == 4) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Growth()));
                    } else if (index == 5) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Profile()));
                    } else if (index == 6) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new ContactAdmin()));
                    } else if (index == 7) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => new Exams()));
                    } else if (index == 8) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Vacations()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Doctors()));
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 160,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                          //borderRadius: BorderRadius.all(Radius.circular(50))
                        ),
                        margin: EdgeInsets.fromLTRB(10, 2, 10, 5),
                        //  padding: EdgeInsets.all(2),
                        child: Image(
                          image: AssetImage('assets/' + images[index]),
                          fit: BoxFit.fill,
                        ),
                      ),
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
      bottomNavigationBar:
          //  ClipRRect(
          //   borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(30.0),
          //     topRight: Radius.circular(30.0),
          //   ),
          //   child:
          BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (value) async {
          if (value == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new NotificationPage()));
          } else if (value == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new ChatPage()));
          } else if (value == 0) {
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
