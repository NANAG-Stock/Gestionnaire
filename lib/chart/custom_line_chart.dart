import 'package:application_principal/Blocks/function.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart {
  final List<Map<int, int>> donnee;

  final Color bodyGradientColor;
  final Color lineColor;
  final TextStyle toultipStyle;
  final Color tooltipBgColor;
  final TextStyle bottomTitleStyle;
  final TextStyle leftTitleStyle;
  String itemsUnit;
  CustomLineChart({
    required this.donnee,
    required this.bodyGradientColor,
    required this.lineColor,
    required this.toultipStyle,
    required this.tooltipBgColor,
    required this.bottomTitleStyle,
    required this.leftTitleStyle,
    required this.itemsUnit,
  });
  late List<FlSpot> flspots = [];
  late LineChartData prodData;
  // vertical bar
  int vertical(int maxValue) {
    return (maxValue / 12).round();
  }

  // create the data of the chart
  startCreateData() {
    flspots.clear();
    for (int i = 0; i < donnee.length; i++) {
      flspots.add(
        FlSpot(
          double.parse((donnee[i].keys.toList()[0]).toString()),
          double.parse(
            (int.parse(
                      donnee[i].values.toList()[0].toString(),
                    ) /
                    vertical(MyFunctions.getMaxValue([donnee])['maxval']!))
                .toString(),
          ),
        ),
      );
    }

    return setChartData();
  }

  // reset the data of the chart
  resetChart({required List<Map<int, int>> newChartData}) {
    flspots.clear();
    donnee.clear();
    donnee.addAll(newChartData);
    return updatechart(chartData: newChartData);
  }

  // update chart
  updatechart({required List<Map<int, int>> chartData}) {
    for (int i = 0; i < chartData.length; i++) {
      flspots.add(
        FlSpot(
          double.parse((chartData[i].keys.toList()[0]).toString()),
          double.parse(
            (int.parse(
                      chartData[i].values.toList()[0].toString(),
                    ) /
                    vertical(MyFunctions.getMaxValue([donnee])['maxval']!))
                .toString(),
          ),
        ),
      );
    }

    return prodData = setChartData();
  }

// left titles widget
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = leftTitleStyle;
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text(
            "${MyFunctions.addDelimiter((vertical(MyFunctions.getMaxValue([
                      donnee
                    ])['maxval']!) * 1).toString())} $itemsUnit",
            style: style);
        break;
      case 3:
        text = Text(
            "${MyFunctions.addDelimiter((vertical(MyFunctions.getMaxValue([
                      donnee
                    ])['maxval']!) * 3).toString())} $itemsUnit",
            style: style);
        break;
      case 5:
        text = Text(
            "${MyFunctions.addDelimiter((vertical(MyFunctions.getMaxValue([
                      donnee
                    ])['maxval']!) * 5).toString())} $itemsUnit",
            style: style);
        break;
      case 7:
        text = Text(
            "${MyFunctions.addDelimiter((vertical(MyFunctions.getMaxValue([
                      donnee
                    ])['maxval']!) * 7).toString())} $itemsUnit",
            style: style);
        break;
      case 9:
        text = Text(
            "${MyFunctions.addDelimiter((vertical(MyFunctions.getMaxValue([
                      donnee
                    ])['maxval']!) * 9).toString())} $itemsUnit",
            style: style);
        break;
      case 11:
        text = Text(
            "${MyFunctions.addDelimiter((vertical(MyFunctions.getMaxValue([
                      donnee
                    ])['maxval']!) * 11).toString())} $itemsUnit",
            style: style);
        break;
      case 13:
        text = Text(
            "${MyFunctions.addDelimiter((vertical(MyFunctions.getMaxValue([
                      donnee
                    ])['maxval']!) * 13).toString())} $itemsUnit",
            style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: text,
    );
  }

  SideTitles get leftTitles => SideTitles(
        showTitles: true,
        reservedSize: MyFunctions.getMaxValue([donnee])['maxval']
                    .toString()
                    .length >
                12
            ? 160
            : MyFunctions.getMaxValue([donnee])['maxval'].toString().length >= 9
                ? 100
                : 80,
        interval: 1,
        getTitlesWidget: leftTitleWidgets,
      );

// bottom title data
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = bottomTitleStyle;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
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

//set the data of the chart
  LineChartData setChartData() {
    LineChartData data = LineChartData(
        lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                tooltipBgColor: tooltipBgColor,
                getTooltipItems: (value) {
                  return value
                      .map(
                        (e) => LineTooltipItem(
                          "${MyFunctions.addDelimiter((e.y.toDouble() * vertical(MyFunctions.getMaxValue([
                                    donnee
                                  ])['maxval']!)).toStringAsFixed(1))} $itemsUnit",
                          toultipStyle,
                        ),
                      )
                      .toList();
                })),
        gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 0.5,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 0.5,
              );
            }),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: bottomTitles()),
          leftTitles: AxisTitles(sideTitles: leftTitles),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          show: true,
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2),
            left: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1),
            right: BorderSide(color: Colors.transparent),
            top: BorderSide(color: Colors.transparent),
          ),
        ),
        minX: 1,
        maxX: MyFunctions.getMaxValue([donnee])['maxX']!.toDouble(),
        minY: 0,
        maxY: 14,
        lineBarsData: [
          LineChartBarData(
            spots: flspots,
            isCurved: false,
            color: lineColor,
            dotData: FlDotData(
              show: true,
            ),
            belowBarData: BarAreaData(
                show: true, color: bodyGradientColor.withOpacity(0.2)),
          ),
        ]);
    return data;
  }
}
