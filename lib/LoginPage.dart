import 'package:elearning_project/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HomePageDoctor.dart';
import 'MainHomePage.dart';
import 'UserDta.dart';

class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String logintype;

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confpasswordController = new TextEditingController();
  TextEditingController _emailCont = new TextEditingController();
  TextEditingController _phoneNoDoctor = new TextEditingController();
  TextEditingController _userid = new TextEditingController();

  Widget _input(
      Icon icon, String hint, TextEditingController controller, bool obsecure) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        controller: controller,
        obscureText: obsecure,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
        ),
        decoration: InputDecoration(
            hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blue[300]),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.blue[300],
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.blue[300],
                width: 3,
              ),
            ),
            prefixIcon: Padding(
              child: IconTheme(
                data: IconThemeData(
                  color: Colors.blue[300],
                ),
                child: icon,
              ),
              padding: EdgeInsets.only(left: 10, right: 30),
            )),
      ),
    );
  }

  //button widget
  Widget _button(String text, Color splashColor, Color highlightColor,
      Color fillColor, Color textColor, void function()) {
    return RaisedButton(
      highlightElevation: 0.0,
      splashColor: splashColor,
      highlightColor: highlightColor,
      elevation: 0.0,
      color: fillColor,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
      ),
      onPressed: () {
        function();
      },
    );
  }

  Future getData(String username, String password, String logintype,
      String email, String userid, String phoneno) async {
    // _usernameController.text.trim(), _passwordController.text.trim(),
    //         logintype,_emailCont.text,_userid.text.trim(),_phoneNoDoctor.text.trim()

    var url = 'https://crenelate-intervals.000webhostapp.com/signup.php';
    print("the data is");

    print(username);
    print(password);
    print(logintype);

    var response = await http.post(url, body: {
      "userid": userid,
      "username": username,
      "password": password,
      "logintype": logintype,
      "email": email,
      "phoneno": phoneno == '' ? '000' : phoneno
    });

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);
    if (res == 'Registered successfully') {
      //  print("login failed");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new WelcomePage()));
    } else {
      showAlertDialog(context);
      print("from static dta");
      print(res[0]['username']);
      UserDta.username = res[0]['username'];
      if (logintype == 'Student') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new MainHomePage()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new HomePageDoctor()));
      }
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
        "Registration failed!!",
        // textAlign: TextAlign.justify,
        // textDirection: TextDirection.rtl,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content:
          Text("Kindly verify the information that you entered and try again."),
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

  showAlertDialog1(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "Ok",
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
        "Missing information!!",
        //  textAlign: TextAlign.justify,
        //textDirection: TextDirection.rtl,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text("Kindly check that you fill all the required information."),
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

  showAlertDialog2(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "Ok",
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
        "Verify passwords!!",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
          "Kindly check that your password equal your confirmed password."),
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

  void _loginUser() {
    if (_usernameController.text == '' ||
        _passwordController.text == '' ||
        _userid.text == '' ||
        _emailCont.text == '' ||
        logintype == '') {
      if (logintype == 'Teacher' && _phoneNoDoctor.text == '') {
        showAlertDialog1(context);
      }
    } else {
      if (_passwordController.text != _confpasswordController.text) {
        showAlertDialog2(context);
      } else {
        getData(
            _usernameController.text.trim(),
            _passwordController.text.trim(),
            logintype,
            _emailCont.text,
            _userid.text.trim(),
            _phoneNoDoctor.text.trim());
      }
    }

// _usernameController.text.trim(), _passwordController.text.trim(),
    //         logintype,_emailCont.text,_userid.text.trim(),_phoneNoDoctor.text.trim()
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'l',
          style: GoogleFonts.pacifico(
            fontSize: 100,
            color: Theme.of(context).primaryColor,
            shadows: [
              Shadow(
                blurRadius: 150.0,
                color: Theme.of(context).primaryColor,
                // offset: Offset(5.0, 5.0),
              ),
            ],
          ),
          children: [
            TextSpan(
              text: 'ea',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'rno',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Colors.blue[300];
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          height: height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _title(),
                Container(
                    height: 40,
                    margin: EdgeInsets.fromLTRB(13, 5, 15, 5),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Center(
                      child: new Text(
                        "Create new account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Theme.of(context).primaryColor),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  //     width: MediaQuery.of(context).size.width * 0.7,
                  child: new TextFormField(
                    controller: _userid,
                    decoration: InputDecoration(
                        hintText: "User_id",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                        // hintText: hint,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        prefixIcon: Padding(
                          child: IconTheme(
                            data: IconThemeData(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Icon(Icons.confirmation_number),
                          ),
                          padding: EdgeInsets.only(left: 10, right: 30),
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  //     width: MediaQuery.of(context).size.width * 0.7,
                  child: new TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                        hintText: "Username",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                        // hintText: hint,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        prefixIcon: Padding(
                          child: IconTheme(
                            data: IconThemeData(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Icon(Icons.person),
                          ),
                          padding: EdgeInsets.only(left: 10, right: 30),
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  //     width: MediaQuery.of(context).size.width * 0.7,
                  child: new TextFormField(
                    controller: _emailCont,
                    decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                        // hintText: hint,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        prefixIcon: Padding(
                          child: IconTheme(
                            data: IconThemeData(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Icon(Icons.email),
                          ),
                          padding: EdgeInsets.only(left: 10, right: 30),
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  //  width: MediaQuery.of(context).size.width * 0.7,
                  child: new TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                        // hintText: hint,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        prefixIcon: Padding(
                          child: IconTheme(
                            data: IconThemeData(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Icon(Icons.lock),
                          ),
                          padding: EdgeInsets.only(left: 10, right: 30),
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  //  width: MediaQuery.of(context).size.width * 0.7,
                  child: new TextFormField(
                    obscureText: true,
                    controller: _confpasswordController,
                    decoration: InputDecoration(
                        hintText: "Confirm your password",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                        // hintText: hint,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        prefixIcon: Padding(
                          child: IconTheme(
                            data: IconThemeData(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Icon(Icons.lock),
                          ),
                          padding: EdgeInsets.only(left: 10, right: 30),
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  //  width: MediaQuery.of(context).size.width * 0.7,
                  child: DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      value: logintype,
                      dropdownColor: Colors.white,
                      hint: new Text(
                        "Select your role",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      //         isExpanded: true,
                      items: <String>['Student', 'Teacher'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(
                            value,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 20.0),
                          ),
                        );
                      }).toList(),
                      onChanged: (valueType) {
                        setState(() {
                          logintype = valueType;
                        });
                        print("drop down list changed");
                        print(valueType);
                      },
                    ),
                  ),
                ),
                logintype == "Teacher"
                    ? Container(
                        margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        //     width: MediaQuery.of(context).size.width * 0.7,
                        child: new TextFormField(
                          controller: _phoneNoDoctor,
                          decoration: InputDecoration(
                              hintText: "Contact number ",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              // hintText: hint,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                              prefixIcon: Padding(
                                child: IconTheme(
                                  data: IconThemeData(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Icon(Icons.phone_rounded),
                                ),
                                padding: EdgeInsets.only(left: 10, right: 30),
                              )),
                        ),
                      )
                    : Container(),
                // SizedBox(height: 10),
                _submitButton1(),
              ],
            ),
          ),
        ));
  }

  Widget _submitButton1() {
    return InkWell(
      onTap: () {
        _loginUser();
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
        //  width: MediaQuery.of(context).size.width * 0.7,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Theme.of(context).primaryColor,
                  offset: Offset(2, 4),
                  blurRadius: 6,
                  spreadRadius: 1)
            ],
            color: Theme.of(context).primaryColor),
        child: Text(
          'Register',
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
