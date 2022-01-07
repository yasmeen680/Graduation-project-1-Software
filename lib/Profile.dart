import 'package:flutter/material.dart';
import 'UserDta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController pass = TextEditingController(text: UserDta.pass);
  TextEditingController phoneCont = TextEditingController(text: UserDta.email);
  TextEditingController otherCont =
      TextEditingController(text: UserDta.otherinfo);

  @override
  void initState() {
    super.initState();
    print("the dateTime is");
    print(DateTime.now());
  }

  Future<void> updateProfile(String email, String pass, String others) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/updateProfile.php';
    print("the data is");

    var response = await http.post(url, body: {
      "userid": UserDta.userid,
      "password": pass,
      "logintype": UserDta.logintype,
      "email": email,
      "username": UserDta.username,
      "phoneno": UserDta.phoneno,
      "otherinfo": others
    });

    UserDta.email = email;
    UserDta.pass = pass;
    UserDta.otherinfo = others;

    print("status code is");
    print(response.statusCode);

    final res = json.decode(response.body);
    if (res == 'Profile updated successfully') {
      print("Profile updated successfully");
      showAlertDialog(context);
    } else {
      print("failed to profile updated");
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Updated successfully",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text("Your profile updated successfully, enjoy your learning."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget profileView() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 70,
                child: ClipOval(
                  child: Image.asset(
                    'assets/33.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ))
            ],
          ),
        ),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor
                  ])),
          child: Column(
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: phoneCont,
                        decoration: InputDecoration(
                            hintText: 'Email.',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white)),
                        //  hintText:
                        textAlign: TextAlign.justify,
                        //  textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.0, color: Colors.white)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: pass,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white)),
                        //  hintText:
                        textAlign: TextAlign.justify,
                        //textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.0, color: Colors.white)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: otherCont,
                        decoration: InputDecoration(
                            hintText: 'Other detail',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white)),
                        //  hintText:
                        textAlign: TextAlign.justify,
                        //textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.0, color: Colors.white)),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () {
                      updateProfile(phoneCont.text, pass.text, otherCont.text);
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      child: Align(
                        child: Text(
                          'Update',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          )),
                    ),
                  ),
                ),
              )
            ],
          ),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
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
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          width: double.infinity,
          height: size.height,
          child: Stack(alignment: Alignment.center, children: <Widget>[
            // Positioned(
            //   top: 0,
            //   right: 0,
            //   child: Image.asset("assets/top1.png", width: size.width),
            // ),
            // Positioned(
            //   top: 0,
            //   right: 0,
            //   child: Image.asset("assets/top2.png", width: size.width),
            // ),
            Positioned(
              top: 10,
              right: 10,
              child: Image.asset("assets/13.jpg", width: size.width * 0.4),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Your profile",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[800],
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: phoneCont,
                    decoration: InputDecoration(
                        hintText: 'Email.',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white)),
                    //  hintText:
                    textAlign: TextAlign.justify,
                    //  textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: pass,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white)),
                    //  hintText:
                    textAlign: TextAlign.justify,
                    //textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: otherCont,
                    decoration: InputDecoration(
                        hintText: 'Other detail',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white)),
                    //  hintText:
                    textAlign: TextAlign.justify,
                    //textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: RaisedButton(
                    onPressed: () {
                      updateProfile(phoneCont.text, pass.text, otherCont.text);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: size.width * 0.5,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: new LinearGradient(colors: [
                            Colors.indigo[800],
                            Colors.indigo[800]
                          ])),
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "Update",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // ListView(children: [
            //GestureDetector(

            //child:
            //profileView()
            //)
            //])
          ])),
    );
  }
}
