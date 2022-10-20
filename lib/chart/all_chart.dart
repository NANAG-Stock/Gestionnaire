// ignore_for_file: prefer_const_constructors
import 'package:application_principal/chart/custom_many_lines_charts.dart';
import 'package:application_principal/chart/custom_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

class AllChart extends StatefulWidget {
  const AllChart({Key? key}) : super(key: key);

  @override
  _AllChartState createState() => _AllChartState();
}

class _AllChartState extends State<AllChart> {
  LineChartData? prodData;

  List<Map<int, int>> donnee = [];
  List<int> vBar = [];
  int maxX = 31;
  List<FlSpot> flspots = [];
  CustomManyMinesCharts? chartTesxt;
  CustomLineChart? lineChart;
  // color des graphes
  List<Color> gradientColors = [
    Color.fromARGB(172, 205, 120, 22),
    Color.fromARGB(172, 161, 130, 8),
  ];
  List<Color> lineColors = [
    Color.fromARGB(173, 204, 61, 0),
    Color.fromARGB(175, 163, 107, 10),
  ];
  @override
  void initState() {
    donnee.addAll([
      {1: 1000},
      {2: 2000},
      {3: 3000},
      {4: 20000},
      {5: 5000},
      {6: 6000},
      {7: 11000},
      {8: 8000},
      {9: 11000},
      {10: 10000},
      {11: 11000},
      {12: 12000},
      {13: 600000},
      {14: 40000},
      {15: 20000},
    ]);

    vBar.addAll([
      1000,
      2000,
      3000,
      4000,
      5000,
      6000,
      7000,
      8000,
      9000,
      10000,
      11000,
      600000,
    ]);
    setState(() {
      flspots.clear();
    });

    lineChart = CustomLineChart(
        donnee: donnee,
        bodyGradientColor: Colors.blue,
        lineColor: Colors.blue,
        toultipStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        tooltipBgColor: Colors.blue,
        bottomTitleStyle: TextStyle(fontWeight: FontWeight.bold),
        leftTitleStyle: TextStyle(fontWeight: FontWeight.bold),
        itemsUnit: "F");

    chartTesxt = CustomManyMinesCharts(
      isCurve: false,
      donnee: [
        donnee,
        const [
          {1: 1000},
          {2: 222000},
          {3: 30000},
          {4: 40000},
          {5: 50000},
          {6: 6000},
          {7: 20000},
          {8: 80000},
          {9: 900000},
          {10: 10000},
          {11: 11000},
          {12: 12000},
          {13: 60000},
          {14: 40000},
          {15: 20000},
        ]
      ],
      lineColors: const [Colors.green, Colors.blue],
      toultipStyle: const [
        TextStyle(
          color: Colors.green,
        ),
        TextStyle(
          color: Colors.blue,
        )
      ],
      tooltipBgColor: Colors.white,
      itemsUnit: 'F',
      bottomTitlesColor: Colors.black,
      leftTitleColor: Colors.black,
      chartBgColor: Colors.green,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: ScrollController(),
        children: [
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(1, 0),
                      blurRadius: 2,
                      spreadRadius: 1)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(7))),
            height: 500,
            width: 800,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: LineChart(
                lineChart!.startCreateData(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(1, 0),
                      blurRadius: 2,
                      spreadRadius: 1)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(7))),
            height: 500,
            width: 800,
            child: Padding(padding: EdgeInsets.all(10), child: chartTesxt),
          ),
        ],
      ),
    );
  }
}
