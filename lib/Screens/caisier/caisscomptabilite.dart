// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/alert_box_3.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/database/commande_details_model.dart';
import 'package:application_principal/database/credit_model.dart';
import 'package:application_principal/database/depense_model.dart';
import 'package:application_principal/database/payment_liste_model.dart';
import 'package:application_principal/database/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CaisseComptabilite extends StatefulWidget {
  const CaisseComptabilite({Key? key}) : super(key: key);

  @override
  _CaisseComptabiliteState createState() => _CaisseComptabiliteState();
}

class _CaisseComptabiliteState extends State<CaisseComptabilite> {
  List<CreditModel>? listCredit;
  List<PaymentListeModel>? listpayment;
  List<CommandeDetailsModel>? listcommandes;
  LineChartData? prodData;
  List<DepenseModel>? depenseList;
  List<DepenseModel>? copydepenseList;
  TextEditingController? moisVal;
  TextEditingController? anneVal;
  bool agentSearch = false;
  bool dateSearch = true;
  List<String> vide = [];

  TextEditingController end = TextEditingController();
  TextEditingController seach = TextEditingController();
  TextEditingController seachInput = TextEditingController();
  bool endPred = false;
  bool endSuiv = false;

  List<Map<int, int>> donnee = [];
  List<int> vBar = [];
  int maxX = 0;
  bool checkAnnee = true;
  bool seeMois = true;
  bool checkMois = true;
  List<FlSpot> flspots = [];
  int totalVente = 0;
  bool _isLoading = true;
  bool is_empty = false;
  @override
  void initState() {
    listCredit = [];
    listpayment = [];
    listcommandes = [];
    checkAnnee = true;
    depenseList = [];
    copydepenseList = [];
    checkMois = true;
    seeMois = true;
    moisVal = TextEditingController();
    anneVal = TextEditingController();
    donnee = [];
    seach.text = '';
    end.text = "0";
    getDepenseListe(end.text, seach.text, true, true);
    // getDayDepense('', '');
    _isLoading = true;
    super.initState();
  }

//recuperation de depenses
  getDepenseListe(String ends, String cherche, bool isfront, bool same) {
    setState(() {
      _isLoading = true;
      is_empty = false;
    });
    endPred = false;
    if (same) {
      end.text = ends;
    } else {
      if (isfront) {
        endSuiv
            ? end.text = end.text
            : end.text = (int.parse(end.text) + 12).toString();
      } else {
        endSuiv = false;
        if ((int.parse(ends) - 12) > 0) {
          end.text = (int.parse(end.text) - 12).toString();
        } else {
          endPred = true;
          end.text = '0';
        }
      }
    }

    String limit = "LIMIT ${end.text},12";
    Services.getDepenseLisLimit(limit, cherche).then((value) {
      setState(() {
        _isLoading = false;
      });
      if (int.parse(value.map((e) => e.id_dep).toList()[0]) <= 0) {
        if (int.parse(value.map((e) => e.id_dep).toList()[0]) < 0) {
          ConfirmBox().showAlert(context, 'Erreur de connexion', false);
        }
        setState(() {
          depenseList = [];
          copydepenseList = [];
          is_empty = true;
        });
      } else if (int.parse(value.map((e) => e.id_dep).toList()[0]) > 0) {
        setState(() {
          depenseList = value;
          copydepenseList = value;
          value.length < 12 ? endSuiv = true : endSuiv = false;
        });
      } else {
        setState(() {
          depenseList = [];
          copydepenseList = [];
        });
      }
    });
  }

  int getDepenseTotal(List<DepenseModel> listdepense) {
    int dep = 0;
    for (int i = 0; i < listdepense.length; i++) {
      dep += int.parse(listdepense[i].prix_dep);
    }
    return dep;
  }

  SingleChildScrollView get _fournisseuMove {
    return SingleChildScrollView(
      controller: ScrollController(),
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            controller: ScrollController(),
            scrollDirection: Axis.horizontal,
            child: Container(
              child: DataTable(
                  columnSpacing: 30,
                  headingTextStyle: TextStyle(
                    color: Color(0xFF26345d),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  horizontalMargin: 10,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white)),
                  // ignore: prefer_const_literals_to_create_immutables
                  columns: [
                    DataColumn(
                      label: Container(
                          child: Row(
                        children: [
                          Text("Date"),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                copydepenseList = depenseList;
                                agentSearch = false;
                                dateSearch = true;
                              });
                            },
                            icon: Icon(
                              Icons.filter_list_alt,
                              size: 20,
                              color: dateSearch ? Colors.green : Colors.black,
                            ),
                          )
                        ],
                      )),
                    ),
                    DataColumn(
                      label: Text("Prix"),
                    ),
                    DataColumn(
                      label: Text("Raison"),
                    ),
                    DataColumn(
                      label: Text("Statut"),
                    ),
                    DataColumn(
                      label: Row(
                        children: [
                          Text("agent"),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                copydepenseList = depenseList;
                                agentSearch = true;
                                dateSearch = false;
                              });
                            },
                            icon: Icon(
                              Icons.filter_list_alt,
                              size: 20,
                              color: agentSearch ? Colors.green : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    DataColumn(
                      label: Text("Action"),
                    ),
                  ],
                  // ignore: prefer_const_literals_to_create_immutables
                  rows: copydepenseList!
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(Text(e.date_dep)),
                            DataCell(Text('${e.prix_dep} Fcfa')),
                            DataCell(Text(e.raison_dep)),
                            DataCell(
                              Text(
                                int.parse(e.etat) == 0
                                    ? 'En traitement...'
                                    : 'Acceptée ',
                                style: TextStyle(
                                    color: int.parse(e.etat) == 0
                                        ? Colors.blue
                                        : Colors.green),
                              ),
                            ),
                            DataCell(Text(e.id_user)),
                            DataCell(
                              int.parse(e.etat) == 0
                                  ? Row(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            AlertBox()
                                                .showAlertDialod(
                                                    context,
                                                    int.parse(e.id_dep),
                                                    "Voulez-vous valider cette depense?",
                                                    'validateDep')
                                                .then((value) {
                                              if (int.parse(value) == 1) {
                                                ConfirmBox()
                                                    .showAlert(
                                                        context,
                                                        "Depense validé avec succès",
                                                        true)
                                                    .then((value) {
                                                  getDepenseListe(end.text,
                                                      seach.text, true, true);
                                                });
                                              } else {
                                                ConfirmBox().showAlert(
                                                    context,
                                                    "Impossible de valider cette depense",
                                                    false);
                                              }
                                            });
                                          },
                                          color: Colors.green,
                                          child: Text(
                                            'Valider',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Icon(Icons.check, color: Colors.green),
                            ),
                          ],
                        ),
                      )
                      .toList()
                  // ignore: prefer_const_literals_to_create_immutables

                  ),
            ),
          ),
        ],
      ),
    );
  }

  final scrollView = ScrollController();
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
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height - 110,
                                  color: Colors.white,
                                  margin: EdgeInsets.only(left: 7, top: 8),
                                  child: _isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : SingleChildScrollView(
                                          controller: ScrollController(),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 10, left: 5),
                                                    width: 400,
                                                    child: TextField(
                                                      controller: seachInput,
                                                      decoration:
                                                          InputDecoration(
                                                              suffixIcon:
                                                                  MaterialButton(
                                                                color: Color(
                                                                    0xFF26345d),
                                                                height: 55,
                                                                onPressed: () {
                                                                  if (seachInput
                                                                      .text
                                                                      .isEmpty) {
                                                                    if (mounted) {
                                                                      setState(
                                                                          () {
                                                                        seach.text =
                                                                            "";
                                                                      });
                                                                    }
                                                                  } else {
                                                                    end.text =
                                                                        '0';
                                                                    if (dateSearch) {
                                                                      if (mounted) {
                                                                        setState(
                                                                            () {
                                                                          seach.text = "AND d.Date_dep LIKE '%${seachInput.text}%'";
                                                                        });
                                                                      }
                                                                    } else {
                                                                      if (mounted) {
                                                                        setState(
                                                                            () {
                                                                          seach.text = "AND u.Nom LIKE '%${seachInput.text}%'";
                                                                        });
                                                                      }
                                                                    }
                                                                  }
                                                                  getDepenseListe(
                                                                      end.text,
                                                                      seach
                                                                          .text,
                                                                      true,
                                                                      true);
                                                                },
                                                                child: Text(
                                                                  'OK',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              hintText: dateSearch
                                                                  ? "Rechercher par date..."
                                                                  : "Rechercher par agent..."),
                                                      onChanged: (seach) {
                                                        setState(() {
                                                          if (dateSearch) {
                                                            copydepenseList = depenseList!
                                                                .where((element) => (element
                                                                    .date_dep
                                                                    .toLowerCase()
                                                                    .contains(seach
                                                                        .toLowerCase())))
                                                                .toList();
                                                          } else {
                                                            copydepenseList = depenseList!
                                                                .where((element) => (element
                                                                    .id_user
                                                                    .toLowerCase()
                                                                    .contains(seach
                                                                        .toLowerCase())))
                                                                .toList();
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Builder(
                                                        builder: (context) {
                                                      return Row(
                                                        children: [
                                                          MaterialButton(
                                                            color:
                                                                Color.fromRGBO(
                                                                    223,
                                                                    15,
                                                                    15,
                                                                    1),
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
                                                                  });
                                                            },
                                                            child: Text(
                                                              'Crédit',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          MaterialButton(
                                                            color: Colors
                                                                .blue[800],
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
                                                                  });
                                                            },
                                                            child: Text(
                                                              'Versement',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 600,
                                                margin: EdgeInsets.all(20),
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
                                                    : _fournisseuMove,
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      width: 300,
                                                      child: BootstrapContainer(
                                                          fluid: true,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          children: [
                                                            BootstrapRow(
                                                                children: [
                                                                  BootstrapCol(
                                                                      sizes:
                                                                          'col-12',
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          MaterialButton(
                                                                            height:
                                                                                40,
                                                                            color: endPred
                                                                                ? Colors.grey
                                                                                : Colors.red,
                                                                            onPressed:
                                                                                () {
                                                                              endPred ? null : getDepenseListe(end.text, seach.text, false, false);
                                                                            },
                                                                            child:
                                                                                Text("Précédent", style: TextStyle(color: endPred ? Colors.black : Colors.white)),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                30,
                                                                          ),
                                                                          MaterialButton(
                                                                            height:
                                                                                40,
                                                                            color: endSuiv
                                                                                ? Colors.grey
                                                                                : Colors.green,
                                                                            onPressed:
                                                                                () {
                                                                              endSuiv ? null : getDepenseListe(end.text, seach.text, true, false);
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              "Suivant",
                                                                              style: TextStyle(color: endSuiv ? Colors.black : Colors.white),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ))
                                                                ])
                                                          ]),
                                                    )
                                                  ])
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
