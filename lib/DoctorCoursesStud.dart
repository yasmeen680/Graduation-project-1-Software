import 'package:flutter/material.dart';

class DoctorCoursesStud extends StatefulWidget {
  _DoctorCoursesStudState createState() => _DoctorCoursesStudState();
}

class _DoctorCoursesStudState extends State<DoctorCoursesStud> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        //this page for doctor courses and students+thier information for each course(hotel page)
        child: new Text("Doctor Courses and all related data"),
      ),
    );
  }
}
