import 'package:application_principal/Blocks/function.dart';
import 'package:application_principal/chart/indicator_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomPieChart extends StatefulWidget {
  final List<int> pieData;
  final List items;
  final double centerSpaceRadius;
  const CustomPieChart(
      {Key? key,
      required this.pieData,
      required this.items,
      required this.centerSpaceRadius})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<CustomPieChart> {
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  PieChartData pieChart(List<int> pieData) {
    return PieChartData(
      pieTouchData: PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                pieTouchResponse == null ||
                pieTouchResponse.touchedSection == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
          });
        },
      ),
      borderData: FlBorderData(
        show: false,
      ),
      sectionsSpace: 0,
      centerSpaceRadius: widget.centerSpaceRadius,
      sections: showingSections(pieData),
    );
  }

// Sum up the items values
  int somme(List<int> pieData) {
    int total = 0;
    for (int val in pieData) {
      total += val;
    }
    return total;
  }

// Find the value in percentage of an item
  double findValue(int total, int value) {
    return (value * 100 / total).roundToDouble();
  }

// generate the indicators
  List<Widget> getIndicators(List items, List<int> pieData) {
    List<Widget> indicators = [];
    int cpt = 0;
    for (var item in items) {
      if (indicators.isNotEmpty) {
        indicators.add(
          const SizedBox(
            height: 4,
          ),
        );
      }
      indicators.add(
        Indicator(
          color: MyFunctions.pieColors[cpt],
          text:
              "$item (${findValue(somme(pieData), pieData[cpt]).toString().split('.')[0]}%)",
          isSquare: true,
        ),
      );
      cpt++;
    }

    return indicators;
  }

// generate the pie chart
  List<PieChartSectionData> showingSections(List<int> pieData) {
    return List.generate(pieData.length, (i) {
      // print(i);
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        borderSide: BorderSide(
            strokeAlign: StrokeAlign.outside,
            width: 2,
            color: MyFunctions.pieColors[i]),
        color: MyFunctions.pieColors[i],
        value: findValue(somme(pieData), pieData[i]),
        title:
            '${findValue(somme(pieData), pieData[i]).toString().split('.')[0]}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 18,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(0),
            child: PieChart(
              pieChart(widget.pieData),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: getIndicators(widget.items, widget.pieData)),
        ),
      ],
    );
  }
}
