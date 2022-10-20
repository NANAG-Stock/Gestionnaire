import 'package:application_principal/Blocks/function.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomManyMinesCharts extends StatelessWidget {
  // data to be showed in the chart
  final List<List<Map<int, int>>> donnee;
  // The color of the drawed lines
  final List<Color> lineColors;
  // The style to be apply when touch the line
  final List<TextStyle> toultipStyle;
  // the backgroundColor of the tooltip
  final Color tooltipBgColor;
  // The unit to be added to the vertical values
  String itemsUnit;
  // enable the chart to be curve
  final bool isCurve;
  // color of the bottom titles
  final Color bottomTitlesColor;
  // color of the left titles
  final Color leftTitleColor;
  // The background color of the chart area
  final Color chartBgColor;
  CustomManyMinesCharts({
    Key? key,
    required this.donnee,
    required this.lineColors,
    required this.toultipStyle,
    required this.tooltipBgColor,
    required this.itemsUnit,
    this.isCurve = true,
    required this.bottomTitlesColor,
    required this.leftTitleColor,
    required this.chartBgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData,
      swapAnimationDuration: const Duration(milliseconds: 150),
    );
  }

// 4

  LineChartData get sampleData => LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: lineBarsData,
      minX: 1,
      maxX: MyFunctions.getMaxValue(donnee)['maxX']!.toDouble(),
      maxY: 14,
      minY: 0,
      backgroundColor: chartBgColor.withOpacity(0.1));

// 1
  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: tooltipBgColor,
          getTooltipItems: (value) {
            return value
                .map((e) => LineTooltipItem(
                    "${MyFunctions.addDelimiter((e.y.toDouble() * vertical(MyFunctions.getMaxValue(donnee)['maxval']!)).toStringAsFixed(1))} $itemsUnit",
                    toultipStyle[value.indexOf(e)]))
                .toList();
          },
        ),
      );

// 2

  List<LineChartBarData> get lineBarsData => startCreateData(donnee);

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles(),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles,
        ),
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: bottomTitlesColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(value.toStringAsFixed(0),
          style: style, textAlign: TextAlign.center),
    );
  }

  SideTitles bottomTitles() => SideTitles(
        getTitlesWidget: bottomTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 50,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: leftTitleColor,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text(
            "${MyFunctions.addDelimiter(
                    (vertical(MyFunctions.getMaxValue(donnee)['maxval']!) * 1)
                        .toString())} $itemsUnit",
            style: style);
        break;
      case 3:
        text = Text(
            "${MyFunctions.addDelimiter(
                    (vertical(MyFunctions.getMaxValue(donnee)['maxval']!) * 3)
                        .toString())} $itemsUnit",
            style: style);
        break;
      case 5:
        text = Text(
            "${MyFunctions.addDelimiter(
                    (vertical(MyFunctions.getMaxValue(donnee)['maxval']!) * 5)
                        .toString())} $itemsUnit",
            style: style);
        break;
      case 7:
        text = Text(
            "${MyFunctions.addDelimiter(
                    (vertical(MyFunctions.getMaxValue(donnee)['maxval']!) * 7)
                        .toString())} $itemsUnit",
            style: style);
        break;
      case 9:
        text = Text(
            "${MyFunctions.addDelimiter(
                    (vertical(MyFunctions.getMaxValue(donnee)['maxval']!) * 9)
                        .toString())} $itemsUnit",
            style: style);
        break;
      case 11:
        text = Text(
            "${MyFunctions.addDelimiter(
                    (vertical(MyFunctions.getMaxValue(donnee)['maxval']!) * 11)
                        .toString())} $itemsUnit",
            style: style);
        break;
      case 13:
        text = Text(
            "${MyFunctions.addDelimiter(
                    (vertical(MyFunctions.getMaxValue(donnee)['maxval']!) * 13)
                        .toString())} $itemsUnit",
            style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get leftTitles => SideTitles(
        showTitles: true,
        reservedSize: 160,
        interval: 1,
        getTitlesWidget: leftTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2),
          left: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

// vertical bar
  int vertical(int maxValue) {
    return (maxValue / 12).round();
  }

// create the data of the chart
  List<LineChartBarData> startCreateData(List<List<Map<int, int>>> donnees) {
    int nbr = 0;
    List<LineChartBarData> lineChartData = [];
    for (List<Map<int, int>> donnee in donnees) {
      List<FlSpot> flspots = [];
      for (int i = 0; i < donnee.length; i++) {
        flspots.add(
          FlSpot(
            double.parse((donnee[i].keys.toList()[0]).toString()),
            double.parse(
              (int.parse(
                        donnee[i].values.toList()[0].toString(),
                      ) /
                      vertical(MyFunctions.getMaxValue(donnees)['maxval']!))
                  .toString(),
            ),
          ),
        );
      }
      lineChartData.add(
        LineChartBarData(
          isCurved: isCurve,
          color: lineColors[nbr],
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0x00aa4cfc),
          ),
          spots: flspots,
        ),
      );
      nbr++;
    }

    return lineChartData;
  }
}
