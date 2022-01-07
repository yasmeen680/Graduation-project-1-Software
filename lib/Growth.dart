import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ResultDetailList.dart';
import 'ResultDetail.dart';
import 'UserDta.dart';
import 'dart:core';

class Growth extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<Growth> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    getStudentResults();
  }

  Future getStudentResults() async {
    ResultDetailList.rl = new List();
    var url =
        'https://crenelate-intervals.000webhostapp.com/StudentResults.php';
    print("the data is");

    var response = await http.post(url,
        body: {"studentid": UserDta.userid}); //must pass here doctor name

    print("status code is");
    print(response.statusCode);
    print(json.decode(response.body));

    final res = json.decode(response.body);

    if (res == 'Failed to get student results') {
      print("Failed to get student results");
    } else {
      print("success to get student results");

      List<dynamic> jsonObj = res;
      for (int i = 0; i < jsonObj.length; i++) {
        Map<String, dynamic> doclist = jsonObj[i];
        String fm = doclist['firstd'];
        String sm = doclist['second'];
        String fim = doclist['finald'];
        String coursename = doclist['coursename'];

        ResultDetail cd = new ResultDetail();
        cd.fm = fm == 'NY' ? '0' : fm;
        cd.sm = sm == 'NY' ? '0' : sm;
        cd.fim = fim == 'NY' ? '0' : fim;
        cd.coursename = coursename;

        ResultDetailList.rl.add(cd);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
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
            "Growth Results",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
              itemCount: ResultDetailList.rl.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 10),
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      color: const Color(0xff81e5cd),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  ResultDetailList.rl[index].coursename,
                                  style: TextStyle(
                                      color: const Color(0xff0f4a3c),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: BarChart(
                                      mainBarData(
                                          int.parse(
                                              ResultDetailList.rl[index].fm),
                                          int.parse(
                                              ResultDetailList.rl[index].sm),
                                          int.parse(
                                              ResultDetailList.rl[index].fim)),
                                      swapAnimationDuration: animDuration,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          color: Colors.indigo[800],
          // colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 26,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(x, y, z) => List.generate(3, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, x, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, y, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, z, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 9, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
          default:
            return null;
        }
      });

  BarChartData mainBarData(int x, int y, int z) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'First';
                  break;
                case 1:
                  weekDay = 'Second';
                  break;
                case 2:
                  weekDay = 'Final';
                  break;
              }
              return BarTooltipItem(weekDay + '\n' + (rod.y - 1).toString(),
                  TextStyle(color: Colors.indigo[800]));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerExitEvent) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'First';
              case 1:
                return 'Second';
              case 2:
                return 'Final';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(x.toDouble(), y.toDouble(), z.toDouble()),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
// import 'package:flutter/foundation.dart';

// class Growth extends StatefulWidget {
//   @override
//   GrowthState createState() {
//     return new GrowthState();
//   }
// }

// class GrowthState extends State<Growth> with SingleTickerProviderStateMixin {
//   final List<Tab> tabs = <Tab>[
//     new Tab(text: "Featured"),
//     new Tab(text: "Popular"),
//     new Tab(text: "Latest"),
//     new Tab(text: "C++"),
//     new Tab(text: "Java"),
//   ];

//   final List<String> courses = [
//     "Algorithms",
//     "DS OS",
//     "Image processing",
//     "C++",
//     "Java",
//   ];

//   TabController _tabController;
//   bool isShowingMainData = true;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = new TabController(vsync: this, length: tabs.length);
//     // isShowingMainData = true;
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   LineChartData sampleData1() {
//     return LineChartData(
//       lineTouchData: LineTouchData(
//         touchTooltipData: LineTouchTooltipData(
//           tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
//         ),
//         touchCallback: (LineTouchResponse touchResponse) {},
//         handleBuiltInTouches: true,
//       ),
//       gridData: FlGridData(
//         show: false,
//       ),
//       titlesData: FlTitlesData(
//         bottomTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 22,
//           textStyle: TextStyle(
//             color: Color(0xff72719b),
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//           margin: 10,
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 2:
//                 return 'FIRST';
//               case 7:
//                 return 'SECOND';
//               case 12:
//                 return 'FINAL';
//             }
//             return '';
//           },
//         ),
//         leftTitles: SideTitles(
//           showTitles: true,
//           textStyle: TextStyle(
//             color: Color(0xff75729e),
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//           ),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 1:
//                 return '5';
//               case 2:
//                 return '10';
//               case 3:
//                 return '15';
//               case 4:
//                 return '20';
//               case 5:
//                 return '25';
//             }
//             return '';
//           },
//           margin: 8,
//           reservedSize: 30,
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: const Border(
//           bottom: BorderSide(
//             color: Color(0xff4e4965),
//             width: 4,
//           ),
//           left: BorderSide(
//             color: Colors.transparent,
//           ),
//           right: BorderSide(
//             color: Colors.transparent,
//           ),
//           top: BorderSide(
//             color: Colors.transparent,
//           ),
//         ),
//       ),
//       minX: 0,
//       maxX: 14,
//       maxY: 4,
//       minY: 0,
//       lineBarsData: linesBarData1(),
//     );
//   }

//   List<LineChartBarData> linesBarData1() {
//     final LineChartBarData lineChartBarData1 = LineChartBarData(
//       spots: [
//         FlSpot(1, 1),
//         FlSpot(3, 1.5),
//         FlSpot(5, 1.4),
//         FlSpot(7, 3.4),
//         FlSpot(10, 2),
//         FlSpot(12, 2.2),
//         FlSpot(13, 1.8),
//       ],
//       isCurved: true,
//       colors: [
//         const Color(0xff4af699),
//       ],
//       barWidth: 8,
//       isStrokeCapRound: true,
//       dotData: FlDotData(
//         show: false,
//       ),
//       belowBarData: BarAreaData(
//         show: false,
//       ),
//     );
//     final LineChartBarData lineChartBarData2 = LineChartBarData(
//       spots: [
//         FlSpot(1, 1),
//         FlSpot(3, 2.8),
//         FlSpot(7, 1.2),
//         FlSpot(10, 2.8),
//         FlSpot(12, 2.6),
//         FlSpot(13, 3.9),
//       ],
//       isCurved: true,
//       colors: [
//         const Color(0xffaa4cfc),
//       ],
//       barWidth: 8,
//       isStrokeCapRound: true,
//       dotData: FlDotData(
//         show: false,
//       ),
//       belowBarData: BarAreaData(show: false, colors: [
//         const Color(0x00aa4cfc),
//       ]),
//     );
//     final LineChartBarData lineChartBarData3 = LineChartBarData(
//       spots: [
//         FlSpot(1, 2.8),
//         FlSpot(3, 1.9),
//         FlSpot(6, 3),
//         FlSpot(10, 1.3),
//         FlSpot(13, 2.5),
//       ],
//       isCurved: true,
//       colors: const [
//         Color(0xff27b6fc),
//       ],
//       barWidth: 8,
//       isStrokeCapRound: true,
//       dotData: FlDotData(
//         show: false,
//       ),
//       belowBarData: BarAreaData(
//         show: false,
//       ),
//     );
//     return [
//       lineChartBarData1,
//       //  lineChartBarData2,
//       // lineChartBarData3,
//     ];
//   }

//   LineChartData sampleData2() {
//     return LineChartData(
//       lineTouchData: LineTouchData(
//         enabled: false,
//       ),
//       gridData: FlGridData(
//         show: false,
//       ),
//       titlesData: FlTitlesData(
//         bottomTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 22,
//           textStyle: TextStyle(
//             color: Color(0xff72719b),
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//           margin: 10,
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 2:
//                 return 'SEPT';
//               case 7:
//                 return 'OCT';
//               case 12:
//                 return 'DEC';
//             }
//             return '';
//           },
//         ),
//         leftTitles: SideTitles(
//           showTitles: true,
//           textStyle: TextStyle(
//             color: Color(0xff75729e),
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//           ),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 1:
//                 return '1m';
//               case 2:
//                 return '2m';
//               case 3:
//                 return '3m';
//               case 4:
//                 return '5m';
//               case 5:
//                 return '6m';
//             }
//             return '';
//           },
//           margin: 8,
//           reservedSize: 30,
//         ),
//       ),
//       borderData: FlBorderData(
//           show: true,
//           border: const Border(
//             bottom: BorderSide(
//               color: Color(0xff4e4965),
//               width: 4,
//             ),
//             left: BorderSide(
//               color: Colors.transparent,
//             ),
//             right: BorderSide(
//               color: Colors.transparent,
//             ),
//             top: BorderSide(
//               color: Colors.transparent,
//             ),
//           )),
//       minX: 0,
//       maxX: 14,
//       maxY: 6,
//       minY: 0,
//       lineBarsData: linesBarData2(),
//     );
//   }

//   List<LineChartBarData> linesBarData2() {
//     return [
//       LineChartBarData(
//         spots: [
//           FlSpot(1, 1),
//           FlSpot(3, 4),
//           FlSpot(5, 1.8),
//           FlSpot(7, 5),
//           FlSpot(10, 2),
//           FlSpot(12, 2.2),
//           FlSpot(13, 1.8),
//         ],
//         isCurved: true,
//         curveSmoothness: 0,
//         colors: const [
//           Color(0x444af699),
//         ],
//         barWidth: 4,
//         isStrokeCapRound: true,
//         dotData: FlDotData(
//           show: false,
//         ),
//         belowBarData: BarAreaData(
//           show: false,
//         ),
//       ),
//       LineChartBarData(
//         spots: [
//           FlSpot(1, 1),
//           FlSpot(3, 2.8),
//           FlSpot(7, 1.2),
//           FlSpot(10, 2.8),
//           FlSpot(12, 2.6),
//           FlSpot(13, 3.9),
//         ],
//         isCurved: true,
//         colors: const [
//           Color(0x99aa4cfc),
//         ],
//         barWidth: 4,
//         isStrokeCapRound: true,
//         dotData: FlDotData(
//           show: false,
//         ),
//         belowBarData: BarAreaData(show: true, colors: [
//           const Color(0x33aa4cfc),
//         ]),
//       ),
//       LineChartBarData(
//         spots: [
//           FlSpot(1, 3.8),
//           FlSpot(3, 1.9),
//           FlSpot(6, 5),
//           FlSpot(10, 3.3),
//           FlSpot(13, 4.5),
//         ],
//         isCurved: true,
//         curveSmoothness: 0,
//         colors: const [
//           Color(0x4427b6fc),
//         ],
//         barWidth: 2,
//         isStrokeCapRound: true,
//         dotData: FlDotData(show: true),
//         belowBarData: BarAreaData(
//           show: false,
//         ),
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       backgroundColor: Colors.white,
//       appBar: new AppBar(
//         title: Text('Growth Results'),
//         bottom: new TabBar(
//           isScrollable: true,
//           unselectedLabelColor: Colors.grey,
//           labelColor: Colors.white,
//           indicatorSize: TabBarIndicatorSize.tab,
//           indicator: new BubbleTabIndicator(
//             indicatorHeight: 25.0,
//             indicatorColor: Colors.transparent,
//             tabBarIndicatorSize: TabBarIndicatorSize.tab,
//           ),
//           tabs: tabs,
//           controller: _tabController,
//         ),
//       ),
//       body: new TabBarView(
//         controller: _tabController,
//         children: tabs.map((Tab tab) {
//           return new Container(
//             height: MediaQuery.of(context).size.height * 0.75,
//             child: AspectRatio(
//               aspectRatio: 1.0,
//               child: Container(
//                 margin: EdgeInsets.all(5.0),
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(18)),
//                   color: Colors.indigo,
//                 ),
//                 child: Stack(
//                   children: <Widget>[
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: <Widget>[
//                         const SizedBox(
//                           height: 41,
//                         ),
//                         const Text(
//                           'Your results growth',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               decoration: TextDecoration.none,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 2),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(
//                           height: 37,
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.only(right: 16.0, left: 6.0),
//                             child: LineChart(
//                               //  isShowingMainData
//                               // ?
//                               sampleData1(),
//                               //  : sampleData2(), //isShowingMainData ? sampleData1() :
//                               swapAnimationDuration:
//                                   const Duration(milliseconds: 250),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
