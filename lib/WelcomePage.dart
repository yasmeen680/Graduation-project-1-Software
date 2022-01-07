import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'LoginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'MainHomePage.dart';
import 'UserDta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginData.dart';
import 'HomePageDoctor.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'UserDta.dart';
import 'adminHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String username = "";
  String pass = "";

  TextEditingController useridContr =
      TextEditingController(text: LoginData.username);
  TextEditingController passController =
      TextEditingController(text: LoginData.pass);
  SharedPreferences sh;
  @override
  void initState() {
    super.initState();
    print("welcome page");
    loadData();
    //signInWithEmailAndPassword();
  }

  Future signInWithEmailAndPassword() async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: "hanal@gmail.com", password: "98765432");
      print("the user credential is :");
      print(result.user);
      User uu = result.user;
      print("email credential is");
      print(uu.uid);
      print(uu.email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool seen = false;
  void loadData() async {
    sh = await SharedPreferences.getInstance();
    seen = sh.getBool("seen") ?? false;

    if (seen) {
      print("do nothing initPlatformStateOneSignal called already");
    } else {
      initPlatformStateOneSignal();
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
        "Wrong information!!",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text("Kindly verify the information that you entered."),
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

  String onesignalUserId = null;

  Future<void> initPlatformStateOneSignal() async {
    sh = await SharedPreferences.getInstance();
    print("initPlatformState");
    if (!mounted) return;

    print("initPlatformState . . .");
    String _debugLabelString = "";

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(true);

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) async {
      this.setState(() {
        _debugLabelString =
            "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    var settings = {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.promptBeforeOpeningPushUrl: true,
    };

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
      setState(() {
        print("setSubscriptionObserver");
        onesignalUserId = changes.to.userId;
        UserDta.checkpushidAppearance = onesignalUserId;
        print("before calling push");
      });
      String token = changes.to.pushToken;
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print(
          "Opened notification main setNotificationOpenedHandler: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
      print("result.notification.payload.title :" +
          result.notification.payload.title);
      print(result.notification.payload.body);
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared.init("867747a1-cf63-4ffb-8f7e-cab860a22e6d",
        iOSSettings: settings); //onesignal_id must be changed

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);

    print("after setInFocusDisplayType");
    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();
    print("requiresConsent :" + requiresConsent.toString());
    if (requiresConsent) {
      OneSignal.shared.consentGranted(true);
    }

    var status = await OneSignal.shared.getPermissionSubscriptionState();
    String token1 = null;
    //String onesignalUserId=null;
    print('status.permissionStatus.hasPrompted :' +
        status.permissionStatus.hasPrompted.toString());
    print(
        'status.permissionStatus.status == OSNotificationPermission.notDetermined :' +
            (status.permissionStatus.status ==
                    OSNotificationPermission.notDetermined)
                .toString());
    print('status.subscriptionStatus.subscribed :' +
        status.subscriptionStatus.subscribed.toString());

    if (status.permissionStatus.hasPrompted) {
      print("permissionStatus.hasPrompted");
    }
    // we know that the user was prompted for push permission

    if (status.permissionStatus.status ==
        OSNotificationPermission.notDetermined) {
      print("permissionStatus.notDetermined");
    }
    if (status.subscriptionStatus.subscribed) {
      // boolean telling you if the user is subscribed with OneSignal's backend
      // the user's ID with OneSignal
      onesignalUserId = status.subscriptionStatus.userId;

      // the user's APNS or FCM/GCM push token
      token1 = status.subscriptionStatus.pushToken;
      print("token : " + token1);
      print("onesignalUserId1 : " + onesignalUserId);
    }

    if (onesignalUserId == null) {
      print("Setting consent to true");
      OneSignal.shared.consentGranted(true);
      token1 = status.subscriptionStatus.pushToken;
      onesignalUserId = status.subscriptionStatus.userId;
    }
    print("the onesignalUserId id at the end of the fcn is");
    print(onesignalUserId);

    UserDta.checkpushidAppearance = onesignalUserId;
    print("UserData.checkpushidAppearance is :");
    print(UserDta.checkpushidAppearance);
  }

  Future insertPush(String userid, String logintype) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/insertPush.php';
    print("the data is");
    print(onesignalUserId);
    print(logintype);
    print(userid);

    var response = await http.post(url, body: {
      "pushId": onesignalUserId,
      "logintype": logintype,
      "userid": userid
    });

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);
    print(res);

    if (res == 'Failed to add pushid') {
      print("Failed to add pushid");
    } else {
      print("New pushid added Successfully");
    }
  }

  Future getData(String username, String password) async {
    var url = 'https://crenelate-intervals.000webhostapp.com/login.php';
    print("the data is");

    print(username);
    print(password);

    var response = await http.post(url, body: {
      "userid": username,
      "password": password,
      // "logintype": logintype,
    });

    print("status code is");
    print(response.statusCode);
    // print(json.decode(response.body));

    final res = json.decode(response.body);
    if (res == 'Try Again' || res == []) {
      print("login failed");
      showAlertDialog(context);
    } else {
      print("from static dta");
      print(res['username']);
      print(res['logintype']);
      print(res['phoneno']);

      UserDta.username = res['username'];
      UserDta.logintype = res['logintype'];
      UserDta.userid = username;
      UserDta.phoneno = res['phoneno'];
      UserDta.pass = password;
      UserDta.email = res['email'];
      UserDta.otherinfo = res['otherinfo'];

      if (seen) {
        print("do nothing the push id inserted already");
      } else {
        insertPush(UserDta.userid, UserDta.logintype);
        sh.setBool("seen", true);
      }

      if (UserDta.logintype == 'Student') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new MainHomePage()));
      } else if (UserDta.logintype == 'Teacher') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new HomePageDoctor()));
      } else {
        if (UserDta.username == 'Changed') {
          UserDta.checked = true;
        } else {
          UserDta.checked = false;
        }
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => new adminHome()));
      }
    }
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        getData(useridContr.text.trim(), passController.text.trim());
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
        //   width: MediaQuery.of(context).size.width * 0.7,
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
          'Login',
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _submitButton1() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
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
            color: Colors.white),
        child: Text(
          'Register',
          style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
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

  void rememberMe() async {}

  int state = 1;
  bool remember = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                _title(),
                Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(13, 5, 15, 5),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: new Text(
                      "Welcome again!!",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Theme.of(context).primaryColor),
                    )),
                SizedBox(height: 5),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: new Text(
                    "Your user_id",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  //     width: MediaQuery.of(context).size.width * 0.7,
                  child: new TextFormField(
                    controller: useridContr,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue[300]),
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
                  margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: new Text(
                    "Your password",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  //  width: MediaQuery.of(context).size.width * 0.7,
                  child: new TextFormField(
                    obscureText: true,
                    controller: passController,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue[300]),
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
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: Row(
                    children: [
                      Checkbox(
                          value: LoginData.checked,
                          onChanged: (value) {
                            setState(() {
                              LoginData.checked = !LoginData.checked;
                              if (LoginData.checked) {
                                sh.setString("username", useridContr.text);
                                sh.setString("pass", passController.text);
                                sh.setBool("checked", LoginData.checked);
                                LoginData.username = useridContr.text;
                                LoginData.pass = passController.text;
                                LoginData.checked = LoginData.checked;
                              } else {
                                sh.remove("username");
                                sh.remove("pass");
                                sh.remove("checked");
                                LoginData.username = "";
                                LoginData.pass = "";
                                LoginData.checked = false;
                              }
                            });
                          }),
                      SizedBox(
                        width: 10,
                      ),
                      new Text(
                        "Remember me",
                        style: new TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                _submitButton(),
                _submitButton1(),
              ],
            ),
          ),
        ));
  }
}
