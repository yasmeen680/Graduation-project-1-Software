import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

List<Appointment> appointmentFromJson(String str) => List<Appointment>.from(
    json.decode(str).map((x) => Appointment.fromJson(x)));

String appointmentToJson(List<Appointment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Appointment {
  Appointment({
    this.date,
    this.dateChange,
    this.dateCreate,
    this.detail,
    this.duration,
    this.id,
    this.note,
    this.status,
    this.title,
    this.uid,
  });

  DateTime date;
  DateTime dateChange;
  DateTime dateCreate;
  String detail;
  int duration;
  String id;
  String note;
  String status;
  String title;
  String uid;

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        date: DateTime.parse(json["date"]),
        dateChange: DateTime.parse(json["date_change"]),
        dateCreate: DateTime.parse(json["date_create"]),
        detail: json["detail"],
        duration: json["duration"],
        id: json["id"],
        note: json["note"],
        status: json["status"],
        title: json["title"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "date_change": dateChange.toIso8601String(),
        "date_create": dateCreate.toIso8601String(),
        "detail": detail,
        "duration": duration,
        "id": id,
        "note": note,
        "status": status,
        "title": title,
        "uid": uid,
      };
}

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments>
    with TickerProviderStateMixin {
  var _calendarController;
  Map<DateTime, List> _events;
  List<Appointment> _samemonthevents = List<Appointment>();
  AnimationController _animationController;
  DateTime current = DateTime.now();

  @override
  void initState() {
    super.initState();
    _events = Map<DateTime, List>();
    _calendarController = CalendarController();

    getSameMonthAppointments();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  getSameMonthAppointments() async {
    String jsonString = '''
    [
  {
    "date": "2021-09-01T11:15:00Z",
    "date_change": "2021-05-14T10:17:40Z",
    "date_create": "2021-05-11T10:17:40Z",
    "detail": "Inflisaport Insertion",
    "duration": 15,
    "id": "2",
    "note": "Looking forward to see you! Take care",
    "status": "CONFIRMED",
    "title": "independence Day",
    "uid": "1"
  },
  {
    "date": "2021-09-22T01:15:00Z",
    "date_change": "2021-04-14T10:17:40Z",
    "date_create": "2021-04-14T10:17:40Z",
    "detail": "Inflisaport Insertion",
    "duration": 15,
    "id": "2",
    "note": "Looking forward to see you! Take care",
    "status": "CONFIRMED",
    "title": "Earth Day",
    "uid": "1"
  },
  {
    "date": "2021-10-01T07:15:00Z",
    "date_change": "2021-04-10T10:17:40Z",
    "date_create": "2021-04-10T10:17:40Z",
    "detail": "Inflisaport Insertion",
    "duration": 15,
    "id": "2",
    "note": "Looking forward to see you! Take care",
    "status": "CONFIRMED",
    "title": "Eid Vacation",
    "uid": "1"
  },
  {
    "date": "2020-10-22T09:15:00Z",
    "date_change": "2018-05-14T10:17:40Z",
    "date_create": "2018-05-14T10:17:40Z",
    "detail": "Inflisaport Insertion",
    "duration": 15,
    "id": "2",
    "note": "Looking forward to see you! Take care",
    "status": "CONFIRMED",
    "title": "Employee Day",
    "uid": "1"
  },
  {
    "date": "2021-03-30T10:15:00Z",
    "date_change": "2021-06-14T10:17:40Z",
    "date_create": "2021-06-14T10:17:40Z",
    "detail": "Inflisaport Insertion",
    "duration": 15,
    "id": "2",
    "note": "Looking forward to see you! Take care",
    "status": "CONFIRMED",
    "title": "Woman International Day",
    "uid": "1"
  }
]
    ''';

    http.Response response = http.Response(jsonString, 200);
    if (response.statusCode == 200) {
      print("the response is:");
      print(response.body);
      _samemonthevents = appointmentFromJson(response.body);
    }
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      current = first;
    });
    print('CALLBACK: _onVisibleDaysChanged first ${first.toIso8601String()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Text(
                "My vacations",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          )),
        body: Builder(builder: (BuildContext context) {
          return Column(children: <Widget>[
            _buildTableCalendarWithBuilders(),
            const SizedBox(height: 8.0),
            const SizedBox(height: 8.0),
            //_buildEventList()
            //_buildsameMonthEventList()
            Expanded(child: _buildsameMonthEventList()),
          ]);
        }));
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      //holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {CalendarFormat.month: ''},
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(36.0),
                  border: Border.all(width: 2, color: Colors.blue[300])),
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),

            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36.0),
                border: Border.all(width: 2, color: Colors.white)),
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(4.0),
    
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36.0),
          border: Border.all(width: 2, color: Colors.blue[300])),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildsameMonthEventList() {
    var _samemontheventsFilter = _samemonthevents.where((element) =>
        element.date.year == current.year &&
        element.date.month == current.month);

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(27.0),
          child: AppBar(
            centerTitle: true,
            title: Text("Vacations of Current Month",
                style: TextStyle(color: Colors.indigo[800], fontSize: 18)),
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            automaticallyImplyLeading: false,
//          backgroundColor: Color(0x44000000),
            elevation: 0.5,
          ),
        ),
        body: (_samemontheventsFilter.length == 0)
            ? Center(
              child:Text("No vacations record in current month!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 18))
            )
            : ListView(
                children: _samemontheventsFilter
                    .map((event) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 2.0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                              padding:const EdgeInsets.all(7.0),
                        child: (event is Appointment)
                            ? ListTile(
                                leading: SizedBox(
                                  width: 90,
                                  child: Column(children: <Widget>[
                                    Text(
                                        DateFormat('EE').format(event.date) +
                                            '  ' +
                                            DateFormat.MMMd()
                                                .format(event.date),
                                        style: TextStyle(
                                          color: Colors.indigo[800].withOpacity(1.0),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text(DateFormat.jm().format(event.date),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          height: 1.5,
                                        )),
                                  ]),
                                ), 
                                title: Text(event.title),
                                onTap: () {
                                  setState(() {});
                                },
                              )
                            : null))
                    .toList()));
  }
}
