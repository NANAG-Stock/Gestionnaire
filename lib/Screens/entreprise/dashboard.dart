// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_unnecessary_containers, sized_box_for_whitespace
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/Blocks/block.dart';
import 'package:application_principal/Blocks/drawer_side_bar.dart';
import 'package:application_principal/Blocks/function.dart';
import 'package:application_principal/Screens/entreprise/custom_data_table.dart';
import 'package:application_principal/chart/custom_line_chart.dart';
import 'package:application_principal/chart/pie_chart.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:responsive_ui/responsive_ui.dart';

class Dashboad extends StatefulWidget {
  const Dashboad({
    Key? key,
  }) : super(key: key);

  @override
  DashboadState createState() => DashboadState();
}

class DashboadState extends State<Dashboad> {
  bool isDrawer = false;
  List<Map<int, int>> data = [];
  List<int> pieData = [];
  List pieItems = []; //latest Dart

  @override
  initState() {
    super.initState();
    data.addAll([
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
      {16: 80000},
      {17: 900000},
      {18: 10000},
      {19: 11000},
      {20: 12000},
      {21: 80000},
      {22: 900000},
      {23: 10000},
      {24: 11000},
      {25: 12000},
    ]);
    pieData.addAll([6000, 6000, 5000, 8000, 2000, 5000, 8000, 600, 9000]);
    pieItems.addAll([
      "Ouaga",
      "Koudougou",
      "Bobo",
      "Kaya",
      "Banfora",
      "Dedougou",
      "Orodara",
      "Ouahigouya",
      "Ziniare"
    ]);
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  tableButton() {
    print("To delete? ");
  }

  final GlobalKey<ScaffoldState> scafKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    print(MyFunctions.deviceSize(context)['w']);

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          isDrawer =
              MyFunctions.deviceSize(context)['w']! <= 960.0 ? true : false;

          return Scaffold(
              drawerEnableOpenDragGesture: false,
              key: scafKey,
              drawer: DrawerSideBar(
                droit: state.user!.droit.toString(),
                bgColor: Color(0xFF26345d),
              ),
              body: Row(
                children: [
                  (isDrawer || state.isClosed!)
                      ? Text('')
                      : Expanded(
                          child: Container(
                            color: Color(0xFF26345d),
                            child: SideBar(
                              droit: state.user!.droit.toString(),
                            ),
                          ),
                        ),
                  Expanded(
                      flex: 5,
                      child: Container(
                        color: Color(0xFFd0d2d4),
                        child: Column(
                          children: [
                            Container(
                              color: Color(0xFF26345d),
                              height: 55,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 3),
                              margin: EdgeInsets.only(
                                left: (isDrawer || state.isClosed!) ? 0 : 7,
                              ),
                              child: AppBarCus(
                                scafKey: scafKey,
                                isDrawer: isDrawer,
                              ),
                            ),
                            Expanded(
                              flex: 11,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: (isDrawer || state.isClosed!) ? 0 : 5,
                                ),
                                child: ListView(
                                  controller: ScrollController(),
                                  children: [
                                    Card(
                                      child: Responsive(children: [
                                        Div(
                                          divison: Division(
                                            colL: MyFunctions.viewPort['colL'],
                                            colM: MyFunctions.viewPort['colM'],
                                            colS: MyFunctions.viewPort['colS'],
                                            colXL:
                                                MyFunctions.viewPort['colXL'],
                                            colXS:
                                                MyFunctions.viewPort['colXS']!,
                                          ),
                                          child: Block(
                                            title: "Vente",
                                            color:
                                                Color.fromARGB(255, 2, 131, 51),
                                            content: "2 000 000 000 000",
                                            titleStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            contentStyle: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Div(
                                          divison: Division(
                                            colL: MyFunctions.viewPort['colL'],
                                            colM: MyFunctions.viewPort['colM'],
                                            colS: MyFunctions.viewPort['colS'],
                                            colXL:
                                                MyFunctions.viewPort['colXL'],
                                            colXS:
                                                MyFunctions.viewPort['colXS']!,
                                          ),
                                          child: Block(
                                            title: "Crédits",
                                            color:
                                                Color.fromARGB(255, 188, 20, 5),
                                            content: "2000",
                                            titleStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            contentStyle: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Div(
                                          divison: Division(
                                            colL: MyFunctions.viewPort['colL'],
                                            colM: MyFunctions.viewPort['colM'],
                                            colS: MyFunctions.viewPort['colS'],
                                            colXL:
                                                MyFunctions.viewPort['colXL'],
                                            colXS:
                                                MyFunctions.viewPort['colXS']!,
                                          ),
                                          child: Block(
                                            title: "Rupture de stock",
                                            color: Color.fromARGB(
                                                255, 188, 74, 12),
                                            content: "2000",
                                            titleStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            contentStyle: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Div(
                                          divison: Division(
                                            colL: MyFunctions.viewPort['colL'],
                                            colM: MyFunctions.viewPort['colM'],
                                            colS: MyFunctions.viewPort['colS'],
                                            colXL:
                                                MyFunctions.viewPort['colXL'],
                                            colXS:
                                                MyFunctions.viewPort['colXS']!,
                                          ),
                                          child: Block(
                                            title: "Dépenses",
                                            color: Color.fromARGB(
                                                255, 11, 121, 141),
                                            content: "2000",
                                            titleStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            contentStyle: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Div(
                                          divison: Division(
                                            colL: MyFunctions.viewPort['colL'],
                                            colM: MyFunctions.viewPort['colM'],
                                            colS: MyFunctions.viewPort['colS'],
                                            colXL:
                                                MyFunctions.viewPort['colXL'],
                                            colXS:
                                                MyFunctions.viewPort['colXS']!,
                                          ),
                                          child: Block(
                                            title: "Vente",
                                            color:
                                                Color.fromARGB(255, 2, 131, 51),
                                            content: "2 000 000 000 000",
                                            titleStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            contentStyle: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Div(
                                          divison: Division(
                                            colL: MyFunctions.viewPort['colL'],
                                            colM: MyFunctions.viewPort['colM'],
                                            colS: MyFunctions.viewPort['colS'],
                                            colXL:
                                                MyFunctions.viewPort['colXL'],
                                            colXS:
                                                MyFunctions.viewPort['colXS']!,
                                          ),
                                          child: Block(
                                            title: "Crédits",
                                            color:
                                                Color.fromARGB(255, 188, 20, 5),
                                            content: "2000",
                                            titleStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            contentStyle: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ]),
                                    ),
                                    Responsive(
                                      children: [
                                        Div(
                                          divison: Division(
                                            colL: 12,
                                            colM: 12,
                                            colS: 12,
                                            colXL: 8,
                                            colXS: 12,
                                          ),
                                          child: Card(
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              height: 500,
                                              child: LineChart(
                                                CustomLineChart(
                                                        donnee: data,
                                                        bodyGradientColor:
                                                            Colors.green,
                                                        lineColor: Colors.green,
                                                        toultipStyle: TextStyle(
                                                            color: Colors
                                                                .white),
                                                        tooltipBgColor: Colors
                                                            .green,
                                                        bottomTitleStyle:
                                                            TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                        leftTitleStyle:
                                                            TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                        itemsUnit: "F")
                                                    .startCreateData(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Div(
                                          divison: Division(
                                            colL: 12,
                                            colM: 12,
                                            colS: 12,
                                            colXL: 4,
                                            colXS: 12,
                                          ),
                                          child: Responsive(
                                            children: [
                                              Div(
                                                divison: Division(
                                                  colL: 6,
                                                  colM: 7,
                                                  colS: 12,
                                                  colXL: 12,
                                                  colXS: 12,
                                                ),
                                                child: Card(
                                                  child: Container(
                                                    height: 300,
                                                    child: CustomPieChart(
                                                        pieData: pieData,
                                                        items: pieItems,
                                                        centerSpaceRadius: 40),
                                                  ),
                                                ),
                                              ),
                                              Div(
                                                divison: Division(
                                                  colL: 6,
                                                  colM: 5,
                                                  colS: 12,
                                                  colXL: 12,
                                                  colXS: 12,
                                                ),
                                                child: Card(
                                                    child: Container(
                                                  height: 190,
                                                )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Responsive(children: [
                                      Div(
                                        child: Container(
                                          height: 400,
                                          child: Card(
                                            child: CustomDataTable(
                                              data: [
                                                {
                                                  "id": 1,
                                                  "nom": "Boutique KDG",
                                                  "tel": "65384473",
                                                  "address": "Secteur 9",
                                                  "pays": "Burkina Faso",
                                                  "stock": "202",
                                                  "responsalbe": "Nana Jeremie",
                                                  "button": IconButton(
                                                    onPressed: () {
                                                      tableButton();
                                                    },
                                                    icon:
                                                        Icon(Icons.visibility),
                                                  )
                                                },
                                                {
                                                  "id": 2,
                                                  "nom": "Boutique Ouaga",
                                                  "tel": "65384473",
                                                  "address": "Secteur 45",
                                                  "pays": "Burkina Faso",
                                                  "stock": "202",
                                                  "responsalbe": "Nana Jeremie",
                                                  "button": IconButton(
                                                    onPressed: () {
                                                      tableButton();
                                                    },
                                                    icon:
                                                        Icon(Icons.visibility),
                                                  )
                                                },
                                              ],
                                              headers: const [
                                                "ID",
                                                "Nom",
                                                "Tel",
                                                "Address",
                                                "Pay",
                                                "Stock",
                                                "Responsable",
                                                "Action"
                                              ],
                                              steps: 20,
                                              totalItems: 100,
                                              nextStep: (int currentSteps,
                                                  int step, bool isFront) {},
                                              headerBgColor: Colors.teal,
                                              showSelect: false,
                                            ),
                                          ),
                                        ),
                                      )
                                    ])
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ));
        });
  }
}
