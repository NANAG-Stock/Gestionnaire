// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/alert_box_2.dart';
import 'package:application_principal/Blocks/alert_box_3.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/function.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/database/commande_details_model.dart';
import 'package:application_principal/database/credit_model.dart';
import 'package:application_principal/database/depense_model.dart';
import 'package:application_principal/database/list_pay_com_num.dart';
import 'package:application_principal/database/payment_liste_model.dart';
import 'package:application_principal/database/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Secret1Comptabilite extends StatefulWidget {
  const Secret1Comptabilite({Key? key}) : super(key: key);

  @override
  _Secret1ComptabiliteState createState() => _Secret1ComptabiliteState();
}

class _Secret1ComptabiliteState extends State<Secret1Comptabilite> {
  List<CreditModel>? listCredit;
  List<PaymentListeModel>? listpayment;
  List<PayComNumListModel>? listpayComTypeNum;
  List<CommandeDetailsModel>? listcommandes;
  LineChartData? prodData;
  List<DepenseModel>? depenseList;
  List<DepenseModel>? dayDepenseList;
  TextEditingController? moisVal;
  TextEditingController? anneVal;
  List<String> mois = [
    'Jan',
    'Feb',
    'Mar',
    'Avr',
    'Mai',
    'Jui',
    'Juil',
    'Aou',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  List<String> annee = [
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030'
  ];
  Map<dynamic, dynamic> moisValues = {
    'Jan': '01',
    'Feb': '02',
    'Mar': '03',
    'Avr': '04',
    'Mai': '05',
    'Jui': '06',
    'Juil': '07',
    'Aou': '08',
    'Sep': '09',
    'Oct': '10',
    'Nov': '11',
    'Dec': '12'
  };
  Map<dynamic, dynamic> fullMois = {
    'Jan': 'Janvier',
    'Feb': 'Fevrier',
    'Mar': 'Mars',
    'Avr': 'Avril',
    'Mai': 'Mai',
    'Jui': 'Juin',
    'Juil': 'Juillet',
    'Aou': 'Aoute',
    'Sep': 'Septembre',
    'Oct': 'Octobre',
    'Nov': 'Novembre',
    'Dec': 'Decembre'
  };
  String msg = " ";

  List<String> vide = [];

  List<Map<int, int>> donnee = [];
  List<int> vBar = [];
  int maxX = 0;
  bool checkAnnee = true;
  bool seeMois = true;
  bool checkMois = true;
  List<FlSpot> flspots = [];
  int totalVente = 0;
  bool _isEmpty = false;
  bool _isLoading = true;
  bool _isDay = false;
  bool _isDayEmpty = false;
  DateTime _date = DateTime.now();
  TextEditingController? _selectDate;
  @override
  void initState() {
    listCredit = [];
    listpayment = [];
    listcommandes = [];
    checkAnnee = true;
    depenseList = [];
    dayDepenseList = [];
    checkMois = true;
    seeMois = true;
    moisVal = TextEditingController();
    anneVal = TextEditingController();
    _selectDate = TextEditingController();
    donnee = [];
    // prodData = setChartData();
    getChartData('', '');
    getCredit('', '');
    getpayListe('', '');
    getSelectDate('', '');
    getcomListe('', '');
    getDepenseListe();
    getDayDepense('', '');
    getPayComTypeListe();
    _isLoading = true;
    super.initState();
  }

  _handleDate(TextEditingController thedate) async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100));

    if (date != _date) {
      setState(() {
        _date = date!;
        thedate.text = date.toString().split(' ')[0];
      });
    }
  }

// recuperation de credit
  getCredit(String mois, String annee) {
    Services.credit(mois, annee).then((value) {
      if (int.parse(value.map((e) => e.idCre).toList()[0]) <= 0) {
        setState(() {
          listCredit = [];
        });
      } else {
        setState(() {
          listCredit = value;
        });
      }
    });
  }

  // recuperation de la liste de paiement
  getpayListe(String mois, String annee) {
    Services.paymentListe(mois, annee).then((value) {
      if (int.parse(value.map((e) => e.id_pay).toList()[0]) <= 0) {
        setState(() {
          listpayment = [];
        });
      } else {
        setState(() {
          listpayment = value;
        });
      }
    });
  }

  // recuperation de la liste de depense par date
  getDayDepense(String mois, String annee) {
    Services.getDepensePerDate(mois, annee).then((value) {
      if (int.parse(value.map((e) => e.id_dep).toList()[0]) <= 0) {
        setState(() {
          dayDepenseList = [];
        });
      } else {
        setState(() {
          dayDepenseList = value;
        });
      }
    });
  }

  // recuperation de la liste des commandes par date de selection
  getcomListe(String mois, String annee) {
    Services.getCommandesListet(mois, annee).then((value) {
      if (int.parse(value.map((e) => e.id_com).toList()[0]) <= 0) {
        setState(() {
          listcommandes = [];
        });
      } else {
        setState(() {
          listcommandes = value;
        });
      }
    });
  }

  // recuperation des types de paiement des commandes
  getPayComTypeListe() {
    Services.getComPayTypeNum().then((value) {
      if (int.parse(value.map((e) => e.itemId).toList()[0]) <= 0) {
        setState(() {
          listpayComTypeNum = [];
        });
      } else {
        setState(() {
          listpayComTypeNum = value;
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

//recuperation de versement
  getDepenseListe() {
    Services.getDepenseLis().then((value) {
      if (int.parse(value.map((e) => e.id_dep).toList()[0]) < 0) {
        ConfirmBox().showAlert(context, 'Erreur de connexion', false);
        setState(() {
          depenseList = [];
        });
      } else if (int.parse(value.map((e) => e.id_dep).toList()[0]) > 0) {
        setState(() {
          depenseList = [];
        });
      } else {
        setState(() {
          depenseList = [];
        });
      }
    });
  }

  getSelectDate(String mois, String annee) {
    String me = "";
    if (mois.isEmpty && annee.isEmpty) {
      me = "Données du mois actuel";
    } else if (mois.isNotEmpty && annee.isNotEmpty) {
      me = '${"Données de " + fullMois[mois]} $annee';
    } else if (mois.isEmpty && annee.isNotEmpty) {
      me = "Données de l'année $annee";
    }
    setState(() {
      msg = me;
    });
  }

  int getDepenseTotal(List<DepenseModel> listdepense) {
    int dep = 0;
    for (int i = 0; i < listdepense.length; i++) {
      dep += int.parse(listdepense[i].prix_dep);
    }
    return dep;
  }

  int getTotals(List<CreditModel> creditListe, String type) {
    int totalcre = 0;
    int totalPay = 0;
    for (int i = 0; i < creditListe.length; i++) {
      totalcre += int.parse(creditListe[i].reste);
      totalPay += int.parse(creditListe[i].paye);
    }
    return type == 'cred' ? totalcre : totalPay;
  }

  getChartData(String mois, String annee) {
    setState(() {
      vBar.clear();
      totalVente = 0;
      _isLoading = false;
      _isEmpty = false;
    });
    Services.getProdLineChart(mois, annee).then((value) {
      if (int.parse(value.map((e) => e.item).toList()[0]) == -404) {
        setState(() {
          _isEmpty = true;
        });
      } else if (int.parse(value.map((e) => e.item).toList()[0]) == -1 ||
          int.parse(value.map((e) => e.item).toList()[0]) == -2) {
        ConfirmBox()
            .showAlert(context, "Erreur de connexion", false)
            .then((value) {
          setState(() {
            _isEmpty = true;
          });
        });
      } else if (int.parse(value.map((e) => e.item).toList()[0]) >= 0) {
        setState(() {
          maxX = int.parse(value.map((e) => e.number).toList()[0]);
        });
      }

      return value;
    }).then((value) {
      setState(() {
        _isLoading = false;
      });
      int cpt = 0;
      for (int i = 0; i < maxX; i++) {
        if (cpt < value.length &&
            int.parse(value[cpt].item) == (maxX == 24 ? i : i + 1)) {
          setState(() {
            donnee.add({int.parse(value[cpt].item): int.parse(value[cpt].val)});
            vBar.add(int.parse(value[cpt].val));
            totalVente += int.parse(value[cpt].val);
          });

          cpt++;
        } else {
          setState(() {
            donnee.add({(maxX == 24 ? i : i + 1): 0});
            vBar.add(0);
          });
        }
      }
      setState(() {
        startCreateData(donnee);
      });
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
        setState(() {
          // prodData = setChartData();
        });
      });
    }
  }

  void refresh(bool isday) {
    if (isday) {
      getChartData(_selectDate!.text, 'true');
      getcomListe(_selectDate!.text, 'true');
      getCredit(_selectDate!.text, 'true');
      getpayListe(_selectDate!.text, 'true');
      getDayDepense(_selectDate!.text, 'true');
      setState(() {
        msg = 'Données de ${_selectDate!.text}';
      });
    } else {
      if (seeMois) {
        if (moisVal!.text.isEmpty && anneVal!.text.isEmpty) {
          getChartData('', '');
          getCredit('', '');
          getpayListe('', '');
          getcomListe('', '');
          getDayDepense('', '');
          getSelectDate('', '');
          getPayComTypeListe();
        } else if (moisVal!.text.isNotEmpty && anneVal!.text.isEmpty) {
          getPayComTypeListe();
          getcomListe(moisValues[moisVal!.text], '');
          getChartData(moisValues[moisVal!.text], '');
          getCredit(moisValues[moisVal!.text], '');
          getpayListe(moisValues[moisVal!.text], '');
          getDayDepense(moisValues[moisVal!.text], '');
          getSelectDate(moisValues[moisVal!.text], '');
        } else if (moisVal!.text.isEmpty && anneVal!.text.isNotEmpty) {
          getPayComTypeListe();
          getcomListe('', anneVal!.text);
          getChartData('', anneVal!.text);
          getCredit('', anneVal!.text);
          getpayListe('', anneVal!.text);
          getDayDepense('', anneVal!.text);
          getSelectDate('', anneVal!.text);
        } else {
          getPayComTypeListe();
          getcomListe(moisValues[moisVal!.text], anneVal!.text);
          getChartData(moisValues[moisVal!.text], anneVal!.text);
          getCredit(moisValues[moisVal!.text], anneVal!.text);
          getpayListe(moisValues[moisVal!.text], anneVal!.text);
          getDayDepense(moisValues[moisVal!.text], anneVal!.text);
          getSelectDate(moisValues[moisVal!.text], anneVal!.text);
        }
      } else {
        if (anneVal!.text.isEmpty) {
          setState(() {
            checkAnnee = false;
          });
        } else {
          getPayComTypeListe();
          getcomListe('', anneVal!.text);
          getChartData('', anneVal!.text);
          getCredit('', anneVal!.text);
          getpayListe('', anneVal!.text);
          getSelectDate('', anneVal!.text);
          getDayDepense('', anneVal!.text);
          setState(() {
            checkAnnee = true;
          });
        }
      }
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
    const Color(0xB00008A0),
    const Color(0xB00008FF),
  ];
  List<Color> lineColors = [
    const Color(0xB00000cc),
    const Color(0xB00000c1),
  ];

  @override
  Widget build(BuildContext context) {
    // print(getDeviceWidht(context));
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
              body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
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
                                    horizontal: 3, vertical: 3),
                                margin: EdgeInsets.only(left: 7),
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
                              child: _isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              75,
                                      color: Colors.white,
                                      margin: EdgeInsets.only(left: 7, top: 8),
                                      child: SingleChildScrollView(
                                        controller: ScrollController(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 80,
                                              width: double.infinity,
                                              margin: EdgeInsets.only(
                                                top: 10,
                                                left: 50,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    getDeviceWidht(
                                                                context)[0] <=
                                                            1919
                                                        ? MainAxisAlignment
                                                            .start
                                                        : MainAxisAlignment
                                                            .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Par jour: ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Checkbox(
                                                          value: _isDay,
                                                          onChanged:
                                                              (bool? newVal) {
                                                            if (mounted) {
                                                              setState(() {
                                                                _isDay =
                                                                    newVal!;
                                                              });
                                                            }
                                                          }),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      _isDay
                                                          ? SizedBox(
                                                              width: 300,
                                                              height: 80,
                                                              child:
                                                                  TextFormField(
                                                                readOnly: true,
                                                                onTap: () =>
                                                                    _handleDate(
                                                                  _selectDate!,
                                                                ),
                                                                controller:
                                                                    _selectDate!,
                                                                onSaved: (String?
                                                                    value) {},
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      "Selectionner date de debut...",
                                                                  contentPadding:
                                                                      EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10),
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: _isDayEmpty
                                                                              ? Color(0xFFDA0F0F)
                                                                              : Color(0xFF171817),
                                                                          width: 1)),
                                                                  border: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: _isDayEmpty
                                                                              ? Color(0xFFDA0F0F)
                                                                              : Color(0xFF171817),
                                                                          width: 1)),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 200,
                                                                    height: 50,
                                                                    child:
                                                                        DropdownButtonFormField(
                                                                      decoration:
                                                                          InputDecoration(
                                                                        filled: seeMois
                                                                            ? false
                                                                            : true,
                                                                        fillColor:
                                                                            Colors.black12,
                                                                        prefixIcon:
                                                                            Container(
                                                                          margin:
                                                                              EdgeInsets.only(right: 10),
                                                                          child: seeMois
                                                                              ? IconButton(
                                                                                  padding: EdgeInsets.only(right: 9),
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      seeMois = false;
                                                                                      moisVal!.text = '';
                                                                                    });
                                                                                  },
                                                                                  icon: Icon(
                                                                                    Icons.visibility,
                                                                                    size: 30,
                                                                                    color: Colors.green,
                                                                                  ))
                                                                              : IconButton(
                                                                                  padding: EdgeInsets.only(right: 9),
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      seeMois = true;
                                                                                    });
                                                                                  },
                                                                                  icon: Icon(
                                                                                    Icons.visibility_off,
                                                                                    size: 30,
                                                                                    color: Colors.grey,
                                                                                  )),
                                                                        ),
                                                                        contentPadding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                20,
                                                                            horizontal:
                                                                                10),
                                                                        enabledBorder:
                                                                            OutlineInputBorder(borderSide: BorderSide(color: checkMois ? Color(0xFF080808) : Color(0xFFE70C0C), width: 1)),
                                                                        border: OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: checkMois ? Color(0xFF080808) : Color(0xFFE70C0C), width: 1)),
                                                                      ),
                                                                      hint:
                                                                          Text(
                                                                        'Mois',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Color(0xFF3E413E)),
                                                                      ),
                                                                      onChanged:
                                                                          (dynamic
                                                                              value) {
                                                                        moisVal!.text =
                                                                            value;
                                                                      },
                                                                      items: seeMois
                                                                          ? mois.map((String? e) {
                                                                              return DropdownMenuItem(
                                                                                value: e,
                                                                                child: Text(e!, style: TextStyle(color: Color(0xFF3E413E))),
                                                                              );
                                                                            }).toList()
                                                                          : vide.map((String? e) {
                                                                              return DropdownMenuItem(
                                                                                value: e,
                                                                                child: Text(e!, style: TextStyle(color: Color(0xFF3E413E))),
                                                                              );
                                                                            }).toList(),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  SizedBox(
                                                                    width: 200,
                                                                    height: 50,
                                                                    child:
                                                                        DropdownButtonFormField(
                                                                      decoration:
                                                                          InputDecoration(
                                                                        contentPadding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                20,
                                                                            horizontal:
                                                                                10),
                                                                        enabledBorder:
                                                                            OutlineInputBorder(borderSide: BorderSide(color: checkAnnee ? Color(0xFF080808) : Color(0xFFE70C0C), width: 1)),
                                                                        border: OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: checkAnnee ? Color(0xFF080808) : Color(0xFFE70C0C), width: 1)),
                                                                      ),
                                                                      hint:
                                                                          Text(
                                                                        'Année',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Color(0xFF3E413E)),
                                                                      ),
                                                                      onChanged:
                                                                          (dynamic
                                                                              value) {
                                                                        anneVal!.text =
                                                                            value;
                                                                      },
                                                                      items: annee.map(
                                                                          (String?
                                                                              e) {
                                                                        return DropdownMenuItem(
                                                                          value:
                                                                              e,
                                                                          child: Text(
                                                                              e!,
                                                                              style: TextStyle(color: Color(0xFF3E413E))),
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      SizedBox(
                                                        height: 50,
                                                        child: MaterialButton(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      40),
                                                          color:
                                                              Color(0xFF0000C5),
                                                          onPressed: () {
                                                            setState(() {
                                                              flspots.clear();
                                                              donnee.clear();
                                                            });
                                                            if (_isDay) {
                                                              if (_selectDate!
                                                                  .text
                                                                  .isEmpty) {
                                                                if (mounted) {
                                                                  setState(() {
                                                                    _isDayEmpty =
                                                                        true;
                                                                  });
                                                                }
                                                              } else {
                                                                getChartData(
                                                                    _selectDate!
                                                                        .text,
                                                                    'true');

                                                                getcomListe(
                                                                    _selectDate!
                                                                        .text,
                                                                    'true');
                                                                getCredit(
                                                                    _selectDate!
                                                                        .text,
                                                                    'true');
                                                                getpayListe(
                                                                    _selectDate!
                                                                        .text,
                                                                    'true');
                                                                getDayDepense(
                                                                    _selectDate!
                                                                        .text,
                                                                    'true');
                                                                setState(() {
                                                                  msg = 'Données de ${_selectDate!
                                                                          .text}';
                                                                });
                                                              }
                                                            } else {
                                                              if (seeMois) {
                                                                if (moisVal!
                                                                        .text
                                                                        .isEmpty &&
                                                                    anneVal!
                                                                        .text
                                                                        .isEmpty) {
                                                                  setState(() {
                                                                    checkMois =
                                                                        false;
                                                                    checkAnnee =
                                                                        false;
                                                                  });
                                                                } else if (moisVal!
                                                                        .text
                                                                        .isNotEmpty &&
                                                                    anneVal!
                                                                        .text
                                                                        .isEmpty) {
                                                                  setState(() {
                                                                    checkMois =
                                                                        true;
                                                                    checkAnnee =
                                                                        false;
                                                                  });
                                                                } else if (moisVal!
                                                                        .text
                                                                        .isEmpty &&
                                                                    anneVal!
                                                                        .text
                                                                        .isNotEmpty) {
                                                                  setState(() {
                                                                    checkMois =
                                                                        false;
                                                                    checkAnnee =
                                                                        true;
                                                                  });
                                                                } else {
                                                                  getPayComTypeListe();
                                                                  getcomListe(
                                                                      moisValues[
                                                                          moisVal!
                                                                              .text],
                                                                      anneVal!
                                                                          .text);
                                                                  getChartData(
                                                                      moisValues[
                                                                          moisVal!
                                                                              .text],
                                                                      anneVal!
                                                                          .text);
                                                                  getCredit(
                                                                      moisValues[
                                                                          moisVal!
                                                                              .text],
                                                                      anneVal!
                                                                          .text);
                                                                  getpayListe(
                                                                      moisValues[
                                                                          moisVal!
                                                                              .text],
                                                                      anneVal!
                                                                          .text);
                                                                  getSelectDate(
                                                                      moisVal!
                                                                          .text,
                                                                      anneVal!
                                                                          .text);
                                                                  getDayDepense(
                                                                      moisValues[
                                                                          moisVal!
                                                                              .text],
                                                                      anneVal!
                                                                          .text);
                                                                  setState(() {
                                                                    checkMois =
                                                                        true;
                                                                    checkAnnee =
                                                                        true;
                                                                  });
                                                                }
                                                              } else {
                                                                if (anneVal!
                                                                    .text
                                                                    .isEmpty) {
                                                                  setState(() {
                                                                    checkAnnee =
                                                                        false;
                                                                  });
                                                                } else {
                                                                  getPayComTypeListe();
                                                                  getcomListe(
                                                                      '',
                                                                      anneVal!
                                                                          .text);
                                                                  getChartData(
                                                                      '',
                                                                      anneVal!
                                                                          .text);
                                                                  getCredit(
                                                                      '',
                                                                      anneVal!
                                                                          .text);
                                                                  getpayListe(
                                                                      '',
                                                                      anneVal!
                                                                          .text);
                                                                  getSelectDate(
                                                                      '',
                                                                      anneVal!
                                                                          .text);
                                                                  getDayDepense(
                                                                      '',
                                                                      anneVal!
                                                                          .text);
                                                                  setState(() {
                                                                    checkAnnee =
                                                                        true;
                                                                  });
                                                                }
                                                              }
                                                            }
                                                          },
                                                          child: Text(
                                                            "Afficher",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  getDeviceWidht(context)[0] <=
                                                          1919
                                                      ? Row(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 150,
                                                                      right:
                                                                          20),
                                                              child: Text(
                                                                msg,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                color: Colors
                                                                    .black45,
                                                                child:
                                                                    MaterialButton(
                                                                  height: 50,
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return ListVersement();
                                                                        }).then((value) {
                                                                      setState(
                                                                          () {
                                                                        flspots
                                                                            .clear();
                                                                        donnee
                                                                            .clear();
                                                                        refresh(
                                                                            _isDay);
                                                                      });
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      'Versement',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16)),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Container(
                                                                color: Colors
                                                                    .black54,
                                                                child:
                                                                    MaterialButton(
                                                                  height: 50,
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return ListRetrai();
                                                                        }).then((value) {
                                                                      setState(
                                                                          () {
                                                                        flspots
                                                                            .clear();
                                                                        donnee
                                                                            .clear();
                                                                        refresh(
                                                                            _isDay);
                                                                      });
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      'Chèque',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16)),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Container(
                                                                color: Colors
                                                                    .black87,
                                                                child:
                                                                    MaterialButton(
                                                                  height: 50,
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return ListVirement();
                                                                        }).then((value) {
                                                                      setState(
                                                                          () {
                                                                        flspots
                                                                            .clear();
                                                                        donnee
                                                                            .clear();
                                                                        refresh(
                                                                            _isDay);
                                                                      });
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      'Virement',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16)),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                color:
                                                                    Colors.red,
                                                                child:
                                                                    MaterialButton(
                                                                  height: 50,
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AllCredit();
                                                                        }).then((value) {
                                                                      setState(
                                                                          () {
                                                                        flspots
                                                                            .clear();
                                                                        donnee
                                                                            .clear();
                                                                        refresh(
                                                                            _isDay);
                                                                      });
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      'Crédit',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16)),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                color: Colors
                                                                    .green,
                                                                child:
                                                                    MaterialButton(
                                                                  height: 50,
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return ListDepense();
                                                                        }).then((value) {
                                                                      setState(
                                                                          () {
                                                                        flspots
                                                                            .clear();
                                                                        donnee
                                                                            .clear();
                                                                        refresh(
                                                                            _isDay);
                                                                      });
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      'Depense',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                            getDeviceWidht(context)[0] >= 1920.0
                                                ? Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 150,
                                                                right: 20),
                                                        child: Text(
                                                          msg,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 150,
                                                                right: 20),
                                                        child: Text(
                                                          msg,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              color: Colors
                                                                  .black45,
                                                              child:
                                                                  MaterialButton(
                                                                height: 50,
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          false,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return ListVersement();
                                                                      }).then((value) {
                                                                    setState(
                                                                        () {
                                                                      flspots
                                                                          .clear();
                                                                      donnee
                                                                          .clear();
                                                                      refresh(
                                                                          _isDay);
                                                                    });
                                                                  });
                                                                },
                                                                child: Text(
                                                                    'Versement',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16)),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Container(
                                                              color: Colors
                                                                  .black54,
                                                              child:
                                                                  MaterialButton(
                                                                height: 50,
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          false,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return ListRetrai();
                                                                      }).then((value) {
                                                                    setState(
                                                                        () {
                                                                      flspots
                                                                          .clear();
                                                                      donnee
                                                                          .clear();
                                                                      refresh(
                                                                          _isDay);
                                                                    });
                                                                  });
                                                                },
                                                                child: Text(
                                                                    'Chèque',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16)),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Container(
                                                              color: Colors
                                                                  .black87,
                                                              child:
                                                                  MaterialButton(
                                                                height: 50,
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          false,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return ListVirement();
                                                                      }).then((value) {
                                                                    setState(
                                                                        () {
                                                                      flspots
                                                                          .clear();
                                                                      donnee
                                                                          .clear();
                                                                      refresh(
                                                                          _isDay);
                                                                    });
                                                                  });
                                                                },
                                                                child: Text(
                                                                    'Virement',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16)),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              color: Colors.red,
                                                              child:
                                                                  MaterialButton(
                                                                height: 50,
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          false,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AllCredit();
                                                                      }).then((value) {
                                                                    setState(
                                                                        () {
                                                                      flspots
                                                                          .clear();
                                                                      donnee
                                                                          .clear();
                                                                      refresh(
                                                                          _isDay);
                                                                    });
                                                                  });
                                                                },
                                                                child: Text(
                                                                    'Crédit',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16)),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              color:
                                                                  Colors.green,
                                                              child:
                                                                  MaterialButton(
                                                                height: 50,
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          false,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return ListDepense();
                                                                      }).then((value) {
                                                                    setState(
                                                                        () {
                                                                      flspots
                                                                          .clear();
                                                                      donnee
                                                                          .clear();
                                                                      refresh(
                                                                          _isDay);
                                                                    });
                                                                  });
                                                                },
                                                                child: Text(
                                                                    'Depense',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            Container(
                                              width: double.infinity,
                                              height: 400,
                                              margin: EdgeInsets.all(20),
                                              child: _isEmpty
                                                  ? Center(
                                                      child: Text(
                                                        "Aucune donnée trouvée",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                                  : LineChart(prodData!),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: getDeviceWidht(
                                                              context)[0] <
                                                          1920.0
                                                      ? 10
                                                      : 150,
                                                  right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => {
                                                      if (listcommandes!
                                                          .isNotEmpty)
                                                        {
                                                          showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return GetCommandeListe(
                                                                  listpayComTypeNum:
                                                                      listpayComTypeNum,
                                                                  commandeList:
                                                                      listcommandes!
                                                                              .isEmpty
                                                                          ? []
                                                                          : listcommandes!,
                                                                );
                                                              })
                                                        }
                                                    },
                                                    child: Container(
                                                      height: 150,
                                                      width: (getDeviceWidht(
                                                                          context)[
                                                                      0] ==
                                                                  1400.0 &&
                                                              getDeviceWidht(
                                                                      context)[1] >
                                                                  1000.0)
                                                          ? 200
                                                          : 250,
                                                      color: Color(0xFF0000C5),
                                                      child: Center(
                                                          child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                          Text(
                                                              "Total commandes",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "$totalVente Fcfa",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      )),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () => {
                                                      if (listpayment!
                                                          .isNotEmpty)
                                                        {
                                                          showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return PaymentDetail(
                                                                    detailPay: listpayment!
                                                                            .isEmpty
                                                                        ? []
                                                                        : listpayment!);
                                                              }).then((value) {})
                                                        }
                                                    },
                                                    child: Container(
                                                      height: 150,
                                                      width: (getDeviceWidht(
                                                                          context)[
                                                                      0] ==
                                                                  1400.0 &&
                                                              getDeviceWidht(
                                                                      context)[1] >
                                                                  1000.0)
                                                          ? 200
                                                          : 250,
                                                      color: Color(0xFF00ad00),
                                                      child: Center(
                                                          child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                          Text("Total Payé",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "${payTotals(listpayment!)} Fcfa",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      )),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (listCredit!
                                                          .isNotEmpty) {
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return CreditDetail(
                                                                detailCred: listCredit!
                                                                        .isEmpty
                                                                    ? []
                                                                    : listCredit!,
                                                                periode: msg,
                                                              );
                                                            });
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 150,
                                                      width: (getDeviceWidht(
                                                                          context)[
                                                                      0] ==
                                                                  1400.0 &&
                                                              getDeviceWidht(
                                                                      context)[1] >
                                                                  1000.0)
                                                          ? 200
                                                          : 250,
                                                      color: Colors.red,
                                                      child: Center(
                                                          child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                          Text("Total Crédits",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "${getTotals(listCredit!, 'cred')} Fcfa",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      )),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () => {},
                                                    child: Container(
                                                      height: 150,
                                                      width: (getDeviceWidht(
                                                                          context)[
                                                                      0] ==
                                                                  1400.0 &&
                                                              getDeviceWidht(
                                                                      context)[1] >
                                                                  1000.0)
                                                          ? 200
                                                          : 250,
                                                      color: Colors.blueAccent,
                                                      child: Center(
                                                          child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                          Text(
                                                              "Depenses totale",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "${getDepenseTotal(dayDepenseList!)} Fcfa",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      )),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ));
        });
  }
}
