import 'package:flutter/material.dart';

class DoctorScheduleBody extends StatefulWidget {
  var coursename, coursetime, coursedate, courseday;
  DoctorScheduleBody(
      this.coursename, this.coursetime, this.coursedate, this.courseday);
  DoctorScheduleBodyState createState() => DoctorScheduleBodyState(
      this.coursename, this.coursetime, this.coursedate, this.courseday);
}

class DoctorScheduleBodyState extends State<DoctorScheduleBody> {
  var coursename, coursetime, coursedate, courseday;
  DoctorScheduleBodyState(
      this.coursename, this.coursetime, this.coursedate, this.courseday);
  @override
  Widget build(BuildContext context) {
    final planetThumbnail = new Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(80)),
        //shape: BoxShape.circle
      ),
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
      child: new Image(
        image: new AssetImage(
          "assets/schedule1.jpg",
        ),
        fit: BoxFit.fill,
        //   height: 92.0,
        // width: 92.0,
      ),
    );

    final baseTextStyle = const TextStyle(fontFamily: 'Poppins');
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 15.0,
        fontWeight: FontWeight.w400);
    // final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 12.0);
    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600);

    Widget _planetValue({String value, String image}) {
      return new Row(children: <Widget>[
        new Image.asset(image, height: 12.0),
        new Container(width: 6.0),
        new Text(coursetime, style: regularTextStyle),
      ]);
    }

    final planetCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 2.0),
          new Text(coursename, style: headerTextStyle),
          new Container(height: 8.0),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 6.0),
              height: 2.0,
              width: 18.0,
              color: new Color(0xff00c6ff)),
          new Row(
            children: <Widget>[
              new Expanded(
                  child:
                      _planetValue(value: coursedate, image: 'assets/1.png')),
              SizedBox(
                width: 3.0,
              ),
              new Expanded(
                  child: new Text(
                coursedate,
                style: TextStyle(color: Colors.white),
              )),
            ],
          ),
          SizedBox(
            height: 7.0,
          ),
          new Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Office hrs.",
                style: TextStyle(color: Colors.white),
              ),
              new Text(
                courseday,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 5,
              )
            ],
          ))
        ],
      ),
    );

    final planetCard = new Container(
      child: planetCardContent,
      height: 150.0,
      margin: new EdgeInsets.only(left: 55.0),
      decoration: new BoxDecoration(
        color: Colors.indigo[800],
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return new Container(
        height: 150.0,
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 21.0,
        ),
        child: new Stack(
          children: <Widget>[
            planetCard,
            planetThumbnail,
          ],
        ));
  }
}
