import 'dart:ui';
import 'calendar_popup_view.dart';
import 'register_list_view.dart';
import 'RegisterListData.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'hotel_app_theme.dart';
import 'HomePageDoctor.dart';
import 'DoctorChatPage.dart';
import 'DoctorNotifications.dart';
import 'WelcomePage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'CoursesList.dart';
import 'CourseData.dart';
import 'UserDta.dart';
import 'hotel_app_theme.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class DocCoursesRegistration extends StatefulWidget {
  @override
  _DocCoursesRegistrationState createState() => _DocCoursesRegistrationState();
}

class _DocCoursesRegistrationState extends State<DocCoursesRegistration>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<RegisterListData> hotelList = RegisterListData.hotelList;
  final ScrollController _scrollController = ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<CourseData>> key = new GlobalKey();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    getCourses();

    searchTextField = AutoCompleteTextField<CourseData>(
        style: new TextStyle(color: Colors.black, fontSize: 16.0),
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
            filled: true,
            hintText: 'Search for any course to register Name',
            hintStyle: TextStyle(color: Colors.black)),
        itemSubmitted: (item) {
          setState(() {
            print("item submitted");
            searchTextField.textField.controller.text = item.coursename;
          });
        },
        clearOnSubmit: true,
        key: key,
        suggestions: CourseList.cl,
        itemBuilder: (context, item) {
          int count = 1; //CourseList.cl.length;
          //   CourseList.cl = new List();
          Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * 1, 1.0,
                      curve: Curves.fastOutSlowIn)));
          animationController.forward();
          return AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 50 * (1.0 - animation.value), 0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 8, bottom: 16),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        //  callback();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              HotelAppTheme.buildLightTheme().backgroundColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(38.0),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: const Offset(0, 2),
                                blurRadius: 8.0),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16.0)),
                          child: Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  AspectRatio(
                                    aspectRatio: 2,
                                    child: Image.asset(
                                      'assets/logo1.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    color: HotelAppTheme.buildLightTheme()
                                        .backgroundColor,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16,
                                                  top: 20,
                                                  bottom: 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    item.coursename,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 22,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        item.coursetime,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4, right: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        Text(
                                                          item.courseday,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(32.0),
                                    ),
                                    onTap: () {
                                      enabled == true
                                          ? registerCourse(
                                              item.coursename,
                                              item.courseday,
                                              item.coursetime,
                                              item.drofficehrs)
                                          : _showSnackBarMag(
                                              "You are unable to register course now...wait until registration time.");
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.add,
                                        size: 40,
                                        color: HotelAppTheme.buildLightTheme()
                                            .primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        itemSorter: (a, b) {
          return a.coursename.compareTo(b.coursename);
        },
        itemFilter: (item, query) {
          return item.coursename.toLowerCase().startsWith(query.toLowerCase());
        });

    super.initState();
  }

  bool enabled = false;
  Future getEnabled() async {
    var url = 'https://crenelate-intervals.000webhostapp.com/getEnabled.php';
    print("the data is");

    var response = await http.post(url);

    print("status code is");
    print(response.statusCode);
    // print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'Failed to get enabled value') {
      print("Failed to get enabled value");
    } else {
      print("get enabled value successfully");
      if (res == 'notChanged') {
        enabled = false;
      } else {
        enabled = true;
      }
      setState(() {});
    }
  }

  Future getCourses() async {
    CourseList.cl = new List();
    var url = 'https://crenelate-intervals.000webhostapp.com/getAllCourses.php';
    print("the data is");

    var response = await http.get(url);

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'Failed to get courses') {
      print("Failed to get courses");
    } else {
      print("get all Courses successfully");
      //coursename,day,courseTime,officehrs
      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> doclist = jsonObj[i];
        // String drname = doclist['drname'];
        String course = doclist['coursename'];
        String day = doclist['day'];
        String coursetime = doclist['courseTime'];
        String officehrs = doclist['officehrs'];

        CourseData cd = new CourseData();
        cd.coursename = course;
        cd.courseday = day;
        cd.coursetime = coursetime;
        cd.drofficehrs = officehrs;

        CourseList.cl.add(cd);
      }
      setState(() {
        getEnabled();
      });
    }
  }

  Future<void> registerCourse(
      String course, String day, String coursetime, String officeHrs) async {
    var url =
        'https://crenelate-intervals.000webhostapp.com/registerCourse.php';
    print("the data is");

    final dateTime = DateTime.now();

    var response = await http.post(url, body: {
      "drid": UserDta.userid,
      "drname": UserDta.username,
      "course": course,
      "day": day,
      "coursetime": coursetime,
      "officehrs": officeHrs
    });

    print("status code is");
    print(response.statusCode);

    final res = json.decode(response.body);
    if (res == 'Course registered successfully') {
      print("Course registered successfully");
      showAlertDialog1(context);
    } else {
      print("failed to register course");
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  void _showSnackBarMag(String msg) {
    _scaffoldstate.currentState
        .showSnackBar(new SnackBar(content: new Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          key: _scaffoldstate,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
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
                    "Registration Page",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    getSearchBarUI(),
                                  ],
                                );
                              }, childCount: 1),
                            ),
                          ];
                        },
                        body: CourseList.cl.length == 0
                            ? Center(
                                child: new Text("Waiting to load data.."),
                              )
                            : Container(
                                color: HotelAppTheme.buildLightTheme()
                                    .backgroundColor,
                                child: ListView.builder(
                                  itemCount: CourseList.cl.length,
                                  padding: const EdgeInsets.only(top: 8),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int count = CourseList.cl.length;
                                    //    > 10 ? 10 : hotelList.length;
                                    final Animation<double> animation =
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(CurvedAnimation(
                                                parent: animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn)));
                                    animationController.forward();
                                    return AnimatedBuilder(
                                      animation: animationController,
                                      builder:
                                          (BuildContext context, Widget child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: Transform(
                                            transform:
                                                Matrix4.translationValues(
                                                    0.0,
                                                    50 *
                                                        (1.0 - animation.value),
                                                    0.0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 24,
                                                  right: 24,
                                                  top: 8,
                                                  bottom: 16),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                onTap: () {
                                                  //  callback();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                16.0)),
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.6),
                                                        offset:
                                                            const Offset(4, 4),
                                                        blurRadius: 16,
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                16.0)),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Column(
                                                          children: <Widget>[
                                                            AspectRatio(
                                                              aspectRatio: 2,
                                                              child:
                                                                  Image.asset(
                                                                'assets/logo1.jpg',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            Container(
                                                              color: HotelAppTheme
                                                                      .buildLightTheme()
                                                                  .backgroundColor,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            top:
                                                                                20,
                                                                            bottom:
                                                                                20),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Text(
                                                                              CourseList.cl[index].coursename,
                                                                              textAlign: TextAlign.left,
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 22,
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  CourseList.cl[index].coursetime,
                                                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 4,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 4, right: 15),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    CourseList.cl[index].courseday,
                                                                                    style: TextStyle(fontSize: 14, color: Colors.black),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Positioned(
                                                          top: 8,
                                                          right: 8,
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: InkWell(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    32.0),
                                                              ),
                                                              onTap: () {
                                                                enabled == true
                                                                    ? registerCourse(
                                                                        CourseList
                                                                            .cl[
                                                                                index]
                                                                            .coursename,
                                                                        CourseList
                                                                            .cl[
                                                                                index]
                                                                            .courseday,
                                                                        CourseList
                                                                            .cl[
                                                                                index]
                                                                            .coursetime,
                                                                        CourseList
                                                                            .cl[
                                                                                index]
                                                                            .drofficehrs)
                                                                    : _showSnackBarMag(
                                                                        "You are unable to register course now...wait until registration time.");
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Icon(
                                                                  Icons.add,
                                                                  size: 40,
                                                                  color: HotelAppTheme
                                                                          .buildLightTheme()
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    //  RegisterListView(
                                    //   callback: () {},
                                    //   hotelData:CourseList.cl[index];// hotelList[index],
                                    //   animation: animation,
                                    //   animationController: animationController,
                                    // );
                                  },
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            onTap: (value) async {
              value == 0
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new HomePageDoctor()))
                  : value == 1
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  new DoctorNotificationPage()))
                      : value == 2
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new DoctorChatPage()))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new WelcomePage()));
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat), title: Text('Chat')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.logout), title: Text('Logout'))
            ],
          ),
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                child: searchTextField),
          ),
          Container(
              decoration: BoxDecoration(
                color: HotelAppTheme.buildLightTheme().primaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(38.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      offset: const Offset(0, 2),
                      blurRadius: 8.0),
                ],
              ),
              child: Container()
              //  Material(
              //   color: Colors.transparent,
              //   child: InkWell(
              //     borderRadius: const BorderRadius.all(
              //       Radius.circular(32.0),
              //     ),
              //     onTap: () {
              //       FocusScope.of(context).requestFocus(FocusNode());
              //     },
              //     child: Padding(
              //         padding: const EdgeInsets.all(16.0), child: Container()
              //         // Icon(FontAwesomeIcons.search,
              //         //     size: 20,
              //         //     color: HotelAppTheme.buildLightTheme().backgroundColor),
              //         ),
              //   ),
              // ),
              ),
        ],
      ),
    );
  }

  showAlertDialog1(BuildContext context) {
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
        "Registered successfully",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text("New course added to your schedule successfully"),
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
        "Warning message",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
          "You are unable to register course now...wait until registration time."),
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

  void showDemoDialog({BuildContext context}) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            if (startData != null && endData != null) {
              startDate = startData;
              endDate = endData;
            }
          });
        },
        onCancelClick: () {},
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
