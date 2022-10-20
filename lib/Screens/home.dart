// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/function.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/database/commande_details_model.dart';
import 'package:application_principal/database/credit_model.dart';
import 'package:application_principal/database/payment_liste_model.dart';
import 'package:application_principal/database/product.dart';
import 'package:application_principal/database/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LineChartData? prodData;
  List<Product>? productList;
  List<FlSpot> flspots = [];
  List<String> vide = [];
  List<CreditModel>? listCredit;
  List<PaymentListeModel>? listpayment;
  List<CommandeDetailsModel>? listcommandes;
  List<Map<int, int>> donnee = [];
  List<int> vBar = [];
  int rupNumber = 0;
  bool _isEmpty = false;
  bool _prodLoading = true;
  int maxX = 0;
  String ventInfo = '0-0-0';
  @override
  void initState() {
    listCredit = [];
    listpayment = [];
    listcommandes = [];
    flspots = [];
    vBar = [];
    donnee = [];
    productList = [];
    ventInfo = '0-0-0';
    getChartData('', '');
    // prodData = setChartData();
    _prodLoading = true;
    getProdList();

    getCredit('', '');
    getpayListe('', '');
    getcomListe('', '');
    // refresh();
    super.initState();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void getProdList() {
    Services.getProdList().then((value) {
      if (value['status'] == 200) {
        setStateIfMounted(() {
          productList = value['data'];
          getruptureProd(productList!);
        });
      } else {
        setStateIfMounted(() {
          productList = [];
        });
        ConfirmBox().showAlert(context,
            "${value['status']}: " + value['message'], false);
      }
    });
  }

  void getruptureProd(List<Product> listProduct) {
    int rptProd = listProduct
        .where((element) => double.parse(element.stock.toString()) <= 20)
        .toList()
        .length;
    setStateIfMounted(() {
      rupNumber = rptProd;
    });
  }

  double prodcount(List<Product> productist) {
    double qts = 0;
    for (int i = 0; i < productist.length; i++) {
      qts += double.parse(productist[i].stock.toString());
    }
    return qts;
  }

  // recuperation de credit
  getCredit(String mois, String annee) {
    Services.credit(mois, annee).then((value) {
      if (int.parse(value.map((e) => e.idCre).toList()[0]) <= 0) {
        setStateIfMounted(() {
          listCredit = [];
        });
      } else {
        setStateIfMounted(() {
          listCredit = value;
        });
      }
    });
  }

  int getCredTotals(List<CreditModel> creditListe, String type) {
    int totalcre = 0;
    int totalPay = 0;
    for (int i = 0; i < creditListe.length; i++) {
      totalcre += int.parse(creditListe[i].reste);
      totalPay += int.parse(creditListe[i].paye);
    }

    return type == 'cred' ? totalcre : totalPay;
  }

  // recuperation de la liste de paiement
  getpayListe(String mois, String annee) {
    Services.paymentListe(mois, annee).then((value) {
      if (int.parse(value.map((e) => e.id_pay).toList()[0]) <= 0) {
        setStateIfMounted(() {
          listpayment = [];
        });
      } else {
        setStateIfMounted(() {
          listpayment = value;
        });
      }
    });
  }

  // recuperation de la liste des commandes par date de selection
  getcomListe(String mois, String annee) {
    Services.getCommandesListet(mois, annee).then((value) {
      if (int.parse(value.map((e) => e.id_com).toList()[0]) <= 0) {
        setStateIfMounted(() {
          listcommandes = [];
        });
      } else {
        setStateIfMounted(() {
          listcommandes = value;
        });
      }
    });
  }

  int payTotals(List<PaymentListeModel> payListe) {
    int total = 0;
    for (int i = 0; i < payListe.length; i++) {
      total += int.parse(payListe[i].somme_pay);
    }
    return total;
  }

  getChartData(String mois, String annee) {
    Services.getProdLineChart(mois, annee).then((value) {
      if (int.parse(value.map((e) => e.item).toList()[0]) == -404) {
        setStateIfMounted(() {
          _isEmpty = true;
        });
      } else if (int.parse(value.map((e) => e.item).toList()[0]) == -1 ||
          int.parse(value.map((e) => e.item).toList()[0]) == -2) {
        ConfirmBox()
            .showAlert(context, "Erreur de connexion", false)
            .then((value) {
          setStateIfMounted(() {
            _isEmpty = true;
          });
        });
      } else if (int.parse(value.map((e) => e.item).toList()[0]) >= 0) {
        setStateIfMounted(() {
          maxX = int.parse(value.map((e) => e.number).toList()[0]);
        });
      }
      return value;
    }).then((value) {
      setStateIfMounted(() {
        _prodLoading = false;
      });
      int cpt = 0;
      for (int i = 0; i < maxX; i++) {
        if (cpt < value.length &&
            int.parse(value[cpt].item) == (maxX == 24 ? i : i + 1)) {
          setStateIfMounted(() {
            donnee.add({int.parse(value[cpt].item): int.parse(value[cpt].val)});
            vBar.add(int.parse(value[cpt].val));
          });

          cpt++;
        } else {
          setStateIfMounted(() {
            donnee.add({(maxX == 24 ? i : i + 1): 0});
            vBar.add(0);
          });
        }
      }
      startCreateData(donnee);
    });
  }

  Future<void> startCreateData(List<Map<int, int>> donnee) async {
    for (int i = 0; i < donnee.length; i++) {
      await Future.delayed((Duration(milliseconds: 20))).then((value) {
        flspots.add(
          FlSpot(
              double.parse((donnee[i].keys.toList()[0]).toString()),
              double.parse((int.parse(donnee[i].values.toList()[0].toString()) /
                      MyFunctions.vertical(vBar))
                  .toString())),
        );
        setStateIfMounted(() {
          // prodData = setChartData();
        });
      });
    }
  }

  // LineChartData setChartData() {
  //   LineChartData data = LineChartData(
  //       lineTouchData: LineTouchData(
  //           touchTooltipData: LineTouchTooltipData(
  //               fitInsideHorizontally: true,
  //               tooltipBgColor: Color(0xB00008A0),
  //               getTooltipItems: (value) {
  //                 return value
  //                     .map(
  //                       (e) => LineTooltipItem(
  //                         "${e.y.toDouble() * MyFunctions.vertical(vBar)} Fcfa",
  //                         TextStyle(fontSize: 20, color: Colors.white),
  //                       ),
  //                     )
  //                     .toList();
  //               })),
  //       gridData: FlGridData(
  //           show: true,
  //           drawVerticalLine: true,
  //           getDrawingHorizontalLine: (value) {
  //             return FlLine(
  //               color: Color(0xff37434d),
  //               strokeWidth: 0.5,
  //             );
  //           },
  //           getDrawingVerticalLine: (value) {
  //             return FlLine(
  //               color: Color(0xff37434d),
  //               strokeWidth: 0.5,
  //             );
  //           }),
  //       titlesData: FlTitlesData(
  //         bottomTitles: SideTitles(
  //           showTitles: true,
  //           reservedSize: 22,
  //           getTextStyles: (context, value) => TextStyle(
  //             color: Color(0xff67727d),
  //             fontWeight: FontWeight.bold,
  //             fontSize: 15,
  //           ),
  //           margin: 12,
  //         ),
  //         leftTitles: SideTitles(
  //             showTitles: true,
  //             reservedSize: 120,
  //             getTextStyles: (context, value) => TextStyle(
  //                   color: Color(0xff67727d),
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 15,
  //                 ),
  //             margin: 12,
  //             getTitles: (y) {
  //               return MyFunctions.chartVerticalData(y: y, vBar: vBar);
  //             }),
  //         show: true,
  //       ),
  //       borderData: FlBorderData(
  //         show: true,
  //         border: Border.all(
  //           color: Color(0xff37434d),
  //           width: 1,
  //         ),
  //       ),
  //       minX: maxX.toDouble() == 24 ? 0 : 1,
  //       maxX: maxX.toDouble() == 24 ? 23 : maxX.toDouble(),
  //       minY: 0,
  //       maxY: 12,
  //       lineBarsData: [
  //         LineChartBarData(
  //           spots: flspots,
  //           isCurved: false,
  //           colors: lineColors,
  //           isStrokeCapRound: false,
  //           dotData: FlDotData(
  //             show: true,
  //           ),
  //           belowBarData: BarAreaData(
  //             show: true,
  //             colors: gradientColors
  //                 .map(
  //                   (colors) => colors.withOpacity(0.3),
  //                 )
  //                 .toList(),
  //           ),
  //         ),
  //       ]);
  //   return data;
  // }

  // color des graphes
  List<Color> gradientColors = [
    const Color(0xB000A200),
    const Color(0xB00ff000),
  ];
  List<Color> lineColors = [
    const Color(0xB0019000),
    const Color(0xB0019000),
  ];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
              body: Row(
            children: [
              state.isClosed!
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
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Color(0xFF26345d),
                            height: 100,
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 3),
                            margin: EdgeInsets.only(
                              left: state.isClosed! ? 0 : 7,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: AppBarCus(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 11,
                          child: SingleChildScrollView(
                            child: Container(
                              height: MediaQuery.of(context).size.height - 80,
                              margin: EdgeInsets.only(
                                  left: state.isClosed! ? 0 : 7, top: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  color: Color(0xFF1C10BD),
                                                  height: 120,
                                                  child: Center(
                                                    // ignore: prefer_const_literals_to_create_immutables
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                          Text(
                                                            'Produits en stock',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            prodcount(
                                                                    productList!)
                                                                .toStringAsFixed(
                                                                    2),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 7),
                                                  height: 120,
                                                  color: Color(0xFF0F974C),
                                                  child: Center(
                                                    // ignore: prefer_const_literals_to_create_immutables
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                          Text(
                                                            'Ventes realisées',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${payTotals(listpayment!)} F',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 7),
                                                  height: 120,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () => Navigator
                                                              .pushNamed(
                                                                  context,
                                                                  'stock'),
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              bottom: 5,
                                                            ),
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    176,
                                                                    106,
                                                                    14),
                                                            child: Center(
                                                              // ignore: prefer_const_literals_to_create_immutables
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  // ignore: prefer_const_literals_to_create_immutables
                                                                  children: [
                                                                    Text(
                                                                      'Rupture de stock',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      rupNumber
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          color:
                                                              Color(0xFFF00C0C),
                                                          child: Center(
                                                            // ignore: prefer_const_literals_to_create_immutables
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                // ignore: prefer_const_literals_to_create_immutables
                                                                children: [
                                                                  Text(
                                                                    'Crédit',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${getCredTotals(listCredit!,
                                                                                'cred')} F',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 7),
                                                      height: 120,
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                bottom: 5,
                                                              ),
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      19,
                                                                      121,
                                                                      229),
                                                              child: Center(
                                                                child: Column(
                                                                  children: const [
                                                                    Text(
                                                                      "En attente de paiement...",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "20",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      247,
                                                                      123,
                                                                      15),
                                                              child: Center(
                                                                child: Column(
                                                                  children: const [
                                                                    Text(
                                                                      "En attente de livraison...",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "10",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            flex: 5,
                                            child: Container(
                                              height: 800,
                                              margin: EdgeInsets.only(top: 10),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                              color: Colors.white,
                                              child: _prodLoading
                                                  ? Center(
                                                      child: Container(
                                                          height: 50,
                                                          width: 50,
                                                          child:
                                                              CircularProgressIndicator()))
                                                  : _isEmpty
                                                      ? Center(
                                                          child: Text(
                                                            'Aucune vente trouvée',
                                                            style: TextStyle(
                                                                fontSize: 19,
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )
                                                      : LineChart(prodData!),
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ));
        });
  }
}
