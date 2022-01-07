import 'package:elearning_project/LoginData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'WelcomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'testCC.dart';
import 'testSta.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting().then((_) => runApp(new MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          hintColor: Colors.cyan[200], //
          primaryColor: Colors.indigo[800],
          canvasColor: Colors.transparent),
      home: SplashScreen(), //SplashScreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  SharedPreferences sh;
  String username;
  String pass;
  bool checked = false;
  @override
  void initState() {
    super.initState();
    loadSettings();
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                //Growth   Results
                builder: (context) => new WelcomePage())); //WelcomePage
      });
    });
  }

  void loadSettings() async {
    sh = await SharedPreferences.getInstance();
    username = sh.getString("username") ?? "";
    pass = sh.getString("pass") ?? "";
    checked = sh.getBool("checked") ?? false;
    print("load settings data");
    print(username);
    print(pass);
    print(checked);
    LoginData.username = username;
    LoginData.pass = pass;
    LoginData.checked = checked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        //backgroundColor: Colors.transparent,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 180,
              child: Image.asset(
                "assets/3.png",
                //  fit: Box,
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              child: new Text("Learno",
                  style: GoogleFonts.pacifico(
                    fontSize: 50,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 150.0,
                        color: Colors.white,
                        // offset: Offset(5.0, 5.0),
                      ),
                    ],
                  )),
            )
          ],
        )),
      ),
    );
  }
}
