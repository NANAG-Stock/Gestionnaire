// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/database/commande_details_model.dart';
import 'package:application_principal/database/credit_model.dart';
import 'package:application_principal/database/payment_liste_model.dart';
import 'package:application_principal/database/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Inventaire extends StatefulWidget {
  const Inventaire({Key? key}) : super(key: key);

  @override
  _InventaireState createState() => _InventaireState();
}

class _InventaireState extends State<Inventaire> {
  List<CommandeDetailsModel>? listInventaire;
  List<CommandeDetailsModel>? copylistInventaire;
  List<PaymentListeModel>? listpayment;
  List<CreditModel>? listCredit;
  LineChartData? prodData;
  TextEditingController? debutDate;
  TextEditingController? finDate;
  bool _isDebuSelect = false;
  bool _isFinSelect = false;

  bool clienSearch = true;
  bool dateSearch = false;
  bool numCom = false;
  bool typePay = false;
  bool agent = false;
  bool is_loading = false;
  bool is_empty = false;

  String msg = " Détail de recherche";
  DateTime _date = DateTime.now();
  final controller = ScrollController();

  List<String> vide = [];
  int totalVente = 0;
  @override
  void initState() {
    _isDebuSelect = false;
    _isFinSelect = false;
    listInventaire = [];
    copylistInventaire = [];
    listpayment = [];
    listCredit = [];
    debutDate = TextEditingController();
    finDate = TextEditingController();

    super.initState();
  }
  //traitemet de dates

  _handleDate(TextEditingController thedate, bool debut) async {
    setState(() {
      debut ? _isDebuSelect = false : _isFinSelect = false;
    });

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

//recuperation de versement
  getInventaire() {
    setState(() {
      is_loading = true;
      is_empty = false;
    });
    Services.getInventaireComList(debutDate!.text, finDate!.text).then((value) {
      setState(() {
        is_loading = false;
      });
      if (int.parse(value.map((e) => e.id_com).toList()[0]) < 0) {
        ConfirmBox().showAlert(context, 'Erreur de connexion', false);
        setState(() {
          is_empty = true;
          listInventaire = [];
          copylistInventaire = [];
        });
      } else if (int.parse(value.map((e) => e.id_com).toList()[0]) > 0) {
        setState(() {
          listInventaire = value;
          copylistInventaire = value;
        });
      } else {
        setState(() {
          is_empty = true;
          // ConfirmBox().showAlert(context, 'Aucun resultat trouvé', false);
          listInventaire = [];
          copylistInventaire = [];
        });
      }
    });
  }

  // recuperation de la liste de paiement
  getpayListe(String debut, String fin) {
    Services.inventairePayList(debut, fin).then((value) {
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

  // recuperation de credit
  getCredit(String debut, String fin) {
    Services.inventairecredit(debut, fin).then((value) {
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

  int getTotals(List data) {
    int totalcre = 0;
    for (int i = 0; i < data.length; i++) {
      totalcre += int.parse(data[i]);
    }
    return totalcre;
  }

  int getTotalsCred(List data) {
    // print(data);
    int totalcre = 0;
    for (int i = 0; i < data.length; i++) {
      totalcre += int.parse(data[i]);
    }
    return totalcre;
  }

  SingleChildScrollView _inventaireBody() {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: DataTable(
          columnSpacing: 50,
          headingTextStyle: TextStyle(
            color: Color(0xFF26345d),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          horizontalMargin: 30,
          decoration: BoxDecoration(
            border: Border.all(width: 0, color: Colors.white),
          ),
          // ignore: prefer_const_literals_to_create_immutables
          columns: [
            DataColumn(
              label: Container(
                  child: Row(
                children: [
                  Text("Num_Fact"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        copylistInventaire = listInventaire;
                        clienSearch = false;
                        dateSearch = false;
                        numCom = true;
                        agent = false;
                      });
                    },
                    icon: Icon(
                      Icons.filter_list_alt,
                      size: 20,
                      color: numCom ? Colors.green : Colors.black,
                    ),
                  ),
                ],
              )),
            ),
            DataColumn(
              label: Row(
                children: [
                  Text("Date"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        copylistInventaire = listInventaire;
                        clienSearch = false;
                        dateSearch = true;
                        numCom = false;
                        agent = false;
                      });
                    },
                    icon: Icon(
                      Icons.filter_list_alt,
                      size: 20,
                      color: dateSearch ? Colors.green : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            DataColumn(
              label: Row(
                children: [
                  Text("Client"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        copylistInventaire = listInventaire;
                        clienSearch = true;
                        dateSearch = false;
                        numCom = false;
                        agent = false;
                      });
                    },
                    icon: Icon(
                      Icons.filter_list_alt,
                      size: 20,
                      color: clienSearch ? Colors.green : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            DataColumn(
              label: Text("Prix total"),
            ),
            DataColumn(
              label: Text("Livraison"),
            ),
            DataColumn(
              label: Row(
                children: [
                  Text("Agent"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        copylistInventaire = listInventaire;
                        clienSearch = false;
                        dateSearch = false;
                        numCom = false;
                        agent = true;
                      });
                    },
                    icon: Icon(
                      Icons.filter_list_alt,
                      size: 20,
                      color: agent ? Colors.green : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
          rows: copylistInventaire!
              .map(
                (e) => DataRow(cells: [
                  DataCell(
                    Text(ConfirmBox().numFacture(
                        e.date_com.split(' ')[0].split('-')[0], e.id_com)),
                  ),
                  DataCell(
                    Text(e.date_com.split(' ')[0]),
                  ),
                  DataCell(
                    Text(e.client_com),
                  ),
                  DataCell(
                    Text('${e.total_com} Fcfa'),
                  ),
                  DataCell(
                    int.parse(e.deliver_com) == 0
                        ? Text(
                            'Non livrée',
                            style: TextStyle(color: Colors.red),
                          )
                        : Text(
                            'livrée',
                            style: TextStyle(color: Colors.green),
                          ),
                  ),
                  DataCell(
                    Text(
                      e.user_com,
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  final control = ScrollController();

  @override
  Widget build(BuildContext context) {
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
                                    horizontal: 3, vertical: 3),
                                margin: EdgeInsets.only(
                                    left: state.isClosed! ? 0 : 7),
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
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height - 75,
                                  color: Colors.white,
                                  margin: EdgeInsets.only(
                                      left: state.isClosed! ? 0 : 7, top: 8),
                                  child: is_loading
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 80,
                                                width: double.infinity,
                                                margin: EdgeInsets.only(
                                                  top: 10,
                                                  left: 20,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 300,
                                                      height: 80,
                                                      child: TextFormField(
                                                        readOnly: true,
                                                        onTap: () =>
                                                            _handleDate(
                                                                debutDate!,
                                                                true),
                                                        controller: debutDate,
                                                        onSaved:
                                                            (String? value) {},
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Selectionner date de debut...",
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: _isDebuSelect
                                                                      ? Color(
                                                                          0xFFDA0F0F)
                                                                      : Color(
                                                                          0xFF171817),
                                                                  width: 1)),
                                                          border: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: _isDebuSelect
                                                                      ? Color(
                                                                          0xFFDA0F0F)
                                                                      : Color(
                                                                          0xFF171817),
                                                                  width: 1)),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    SizedBox(
                                                      width: 300,
                                                      height: 80,
                                                      child: TextFormField(
                                                        readOnly: true,
                                                        onTap: () =>
                                                            _handleDate(
                                                                finDate!,
                                                                false),
                                                        controller: finDate,
                                                        onSaved:
                                                            (String? value) {},
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Selectionner date de fin...",
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: _isFinSelect
                                                                      ? Color(
                                                                          0xFFDA0F0F)
                                                                      : Color(
                                                                          0xFF171817),
                                                                  width: 1)),
                                                          border: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: _isFinSelect
                                                                      ? Color(
                                                                          0xFFDA0F0F)
                                                                      : Color(
                                                                          0xFF171817),
                                                                  width: 1)),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                    SizedBox(
                                                      height: 48,
                                                      child: MaterialButton(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 40),
                                                        color:
                                                            Color(0xFF0000C5),
                                                        onPressed: () {
                                                          if (debutDate!.text
                                                                  .isEmpty &&
                                                              finDate!.text
                                                                  .isEmpty) {
                                                            setState(() {
                                                              _isDebuSelect =
                                                                  true;
                                                              _isFinSelect =
                                                                  true;
                                                            });
                                                          } else if (debutDate!
                                                                  .text
                                                                  .isNotEmpty &&
                                                              finDate!.text
                                                                  .isEmpty) {
                                                            setState(() {
                                                              _isDebuSelect =
                                                                  false;
                                                              _isFinSelect =
                                                                  true;
                                                            });
                                                          } else if (debutDate!
                                                                  .text
                                                                  .isEmpty &&
                                                              finDate!.text
                                                                  .isNotEmpty) {
                                                            setState(() {
                                                              _isDebuSelect =
                                                                  true;
                                                              _isFinSelect =
                                                                  false;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              if (debutDate!
                                                                      .text
                                                                      .split(
                                                                          ' ')
                                                                      .length >
                                                                  1) {
                                                                debutDate!
                                                                        .text =
                                                                    debutDate!
                                                                        .text;
                                                              } else {
                                                                debutDate!
                                                                    .text = "${debutDate!
                                                                        .text} 00:00:00";
                                                              }
                                                              if (finDate!.text
                                                                      .split(
                                                                          ' ')
                                                                      .length >
                                                                  1) {
                                                                finDate!.text =
                                                                    finDate!
                                                                        .text;
                                                              } else {
                                                                finDate!
                                                                    .text = '${finDate!
                                                                        .text} 23:59:59';
                                                              }
                                                            });
                                                            getInventaire();
                                                            getCredit(
                                                                debutDate!.text,
                                                                finDate!.text);
                                                            getpayListe(
                                                                debutDate!.text,
                                                                finDate!.text);

                                                            setState(() {
                                                              _isDebuSelect =
                                                                  false;
                                                              _isFinSelect =
                                                                  false;
                                                            });
                                                          }
                                                        },
                                                        child: Text(
                                                          "Afficher",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 20),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Inventaire des dates:  ",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${debutDate!.text
                                                              .split(' ')[0]} et ${finDate!.text
                                                              .split(' ')[0]}',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, top: 20),
                                                child: Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Total des ventes:  ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '${getTotals(listInventaire!
                                                                      .map((e) =>
                                                                          e.total_com)
                                                                      .toList())} F',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 40,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Payée:  ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '${getTotalsCred(listpayment!
                                                                      .map((e) =>
                                                                          e.somme_pay)
                                                                      .toList())} F',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 40,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Crédit:  ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '${getTotals(listCredit!
                                                                      .map((e) =>
                                                                          e.reste)
                                                                      .toList())} F',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 5, top: 30),
                                                width: 300,
                                                child: clienSearch
                                                    ? TextField(
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            hintText:
                                                                "Rechercher par nom du Client..."),
                                                        onChanged: (seach) {
                                                          setState(() {
                                                            copylistInventaire = listInventaire!
                                                                .where((element) => (element
                                                                    .client_com
                                                                    .toLowerCase()
                                                                    .contains(seach
                                                                        .toLowerCase())))
                                                                .toList();
                                                          });
                                                        },
                                                      )
                                                    : agent
                                                        ? TextField(
                                                            decoration: InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                hintText:
                                                                    "Rechercher par agent..."),
                                                            onChanged: (seach) {
                                                              setState(() {
                                                                copylistInventaire = listInventaire!
                                                                    .where((element) => (element
                                                                        .user_com
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            seach.toLowerCase())))
                                                                    .toList();
                                                              });
                                                            },
                                                          )
                                                        : numCom
                                                            ? TextField(
                                                                decoration: InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    hintText:
                                                                        "Rechercher par numéro de commande..."),
                                                                onChanged:
                                                                    (seach) {
                                                                  setState(() {
                                                                    copylistInventaire = listInventaire!
                                                                        .where((element) => (element
                                                                            .id_com
                                                                            .toLowerCase()
                                                                            .contains(seach.toLowerCase())))
                                                                        .toList();
                                                                  });
                                                                },
                                                              )
                                                            : TextField(
                                                                decoration: InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    hintText:
                                                                        "Rechercher par date..."),
                                                                onChanged:
                                                                    (seach) {
                                                                  setState(() {
                                                                    copylistInventaire = listInventaire!
                                                                        .where((element) => (element
                                                                            .date_com
                                                                            .toLowerCase()
                                                                            .contains(seach.toLowerCase())))
                                                                        .toList();
                                                                  });
                                                                },
                                                              ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black)),
                                                height: 548,
                                                margin: EdgeInsets.only(
                                                    top: 5, left: 5, right: 5),
                                                child: is_empty
                                                    ? Center(
                                                        child: Text(
                                                          'Aucune donnée trouvée',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      )
                                                    : ImprovedScrolling(
                                                        enableCustomMouseWheelScrolling:
                                                            true,
                                                        enableKeyboardScrolling:
                                                            true,
                                                        enableMMBScrolling:
                                                            true,
                                                        mmbScrollConfig:
                                                            MMBScrollConfig(
                                                          customScrollCursor:
                                                              DefaultCustomScrollCursor(
                                                            backgroundColor:
                                                                Colors.white,
                                                            cursorColor: Color(
                                                                0xFF26345d),
                                                          ),
                                                        ),
                                                        customMouseWheelScrollConfig:
                                                            CustomMouseWheelScrollConfig(
                                                                scrollAmountMultiplier:
                                                                    4.0),
                                                        scrollController:
                                                            controller,
                                                        child:
                                                            _inventaireBody()),
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
