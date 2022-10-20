// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/alert_box_3.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/database/bon_sortie_model.dart';
import 'package:application_principal/database/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Secret1BonDeSortie extends StatefulWidget {
  const Secret1BonDeSortie({Key? key}) : super(key: key);

  @override
  _Secret1BonDeSortieState createState() => _Secret1BonDeSortieState();
}

class _Secret1BonDeSortieState extends State<Secret1BonDeSortie> {
  TextEditingController? user;
  List<String>? fourList;
  List<BonSortieModel>? listbonSortie;
  List<BonSortieModel>? copyListbonSortie;
  BonSortieModel? selectCom;
  bool checkEmpty = true;
  bool clickCom = false;
  bool clienSearch = true;
  bool idSearch = false;
  bool dateSearch = false;
  bool afficheType = true;
  final controller = ScrollController();
  double colSpace = 49;
  String typeBon = 'boutique';
  String idBon = '';

  @override
  void initState() {
    user = TextEditingController();
    listbonSortie = [];
    copyListbonSortie = [];
    checkEmpty = true;
    clickCom = false;
    fourList = [];
    colSpace = 49;
    getListeBon('boutique');
    super.initState();
  }

  getListeBon(String type) {
    Services.getAllBonSortieInfos(type).then((value) {
      if (int.parse(value.map((e) => e.id_bon).toList()[0]) < 0) {
        ConfirmBox().showAlert(context, "Erreur de connexion", false);
        setState(() {
          listbonSortie = [];
          copyListbonSortie = [];
        });
      } else {
        if (int.parse(value.map((e) => e.id_bon).toList()[0]) == 0) {
          ConfirmBox().showAlert(context, "Aucune donnée trouvée", false);
          setState(() {
            listbonSortie = [];
            copyListbonSortie = [];
          });
        } else {
          setState(() {
            listbonSortie = value;
            copyListbonSortie = value;
          });
        }
      }
    });
  }

  SingleChildScrollView get _commandeBody {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: DataTable(
          columnSpacing: 30,
          headingTextStyle: TextStyle(
            color: Color(0xFF26345d),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          horizontalMargin: 30,
          // ignore: prefer_const_literals_to_create_immutables
          columns: [
            DataColumn(
              label: Row(
                children: [
                  Row(
                    children: [
                      Text("Num_bon"),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              copyListbonSortie = listbonSortie;
                              clienSearch = false;
                              idSearch = true;
                              dateSearch = false;
                            });
                          },
                          icon: Icon(
                            Icons.filter_list_alt,
                            size: 20,
                            color: idSearch ? Colors.green : Colors.black,
                          ))
                    ],
                  ),
                ],
              ),
            ),
            DataColumn(
              label: Text("Nbr_Prod"),
            ),
            DataColumn(
              label: Row(
                children: [
                  Row(
                    children: [
                      Text("Client/boutique"),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              copyListbonSortie = listbonSortie;
                              clienSearch = true;
                              idSearch = false;
                              dateSearch = false;
                            });
                          },
                          icon: Icon(
                            Icons.filter_list_alt,
                            size: 20,
                            color: clienSearch ? Colors.green : Colors.black,
                          ))
                    ],
                  ),
                ],
              ),
            ),
            DataColumn(
              label: Row(
                children: [
                  Row(
                    children: [
                      Text("Date"),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              copyListbonSortie = listbonSortie;
                              clienSearch = false;
                              idSearch = false;
                              dateSearch = true;
                            });
                          },
                          icon: Icon(
                            Icons.filter_list_alt,
                            size: 20,
                            color: dateSearch ? Colors.green : Colors.black,
                          ))
                    ],
                  ),
                ],
              ),
            ),
            DataColumn(
              label: Text("Agent"),
            ),
            DataColumn(
              label: Text("Etat"),
            ),
            DataColumn(
              label: Text("Action"),
            ),
          ],
          rows: copyListbonSortie!
              .map(
                (e) => DataRow(cells: [
                  DataCell(
                    Text(e.id_bon),
                  ),
                  DataCell(
                    Text(e.qts_bon),
                  ),
                  DataCell(
                    Text(e.nom_bon),
                  ),
                  DataCell(
                    Text(e.date_bon),
                  ),
                  DataCell(
                    Text(
                      e.agent_bon,
                    ),
                  ),
                  DataCell(
                    Text(
                      e.is_print_bon == '0' ? 'En cours...' : 'Valider',
                      style: TextStyle(
                          color: (e.id_bon == '0')
                              ? (Color(0xCCCE7A0B))
                              : Color(0xCC13971A)),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.visibility,
                            color: Color(0xCCABAD18),
                          ),
                          onPressed: () {
                            selectCom = e;

                            setState(() {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return VoirBon(
                                      selectCom: e,
                                      type: typeBon,
                                    );
                                  }).then((value) {
                                setState(() {
                                  if (typeBon == 'boutique') {
                                    getListeBon('boutique');
                                    afficheType = true;
                                  } else {
                                    getListeBon(' ');
                                    afficheType = false;
                                  }
                                });
                              });
                            });
                          },
                        ),
                        int.parse(e.is_print_bon) == 0
                            ? IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () {
                                  AlertBox()
                                      .showAlertDialod(
                                          context,
                                          int.parse(e.id_bon),
                                          'Voulez-vous supprimer ce Bon de sortie?',
                                          'bonDeSortie')
                                      .then((value) {
                                    if (value == "1") {
                                      setState(() {
                                        ConfirmBox()
                                            .showAlert(
                                                context,
                                                'Bon de sortie supprimé avec success',
                                                true)
                                            .then((value) {
                                          setState(() {
                                            if (typeBon == 'boutique') {
                                              getListeBon('boutique');
                                              afficheType = true;
                                            } else {
                                              getListeBon(' ');
                                              afficheType = false;
                                            }
                                          });
                                        });
                                      });
                                    }
                                  });
                                },
                              )
                            : Text(''),
                        int.parse(e.id_bon) == 0
                            ? TextButton(
                                onPressed: () {
                                  AlertBox()
                                      .showAlertDialod(
                                          context,
                                          int.parse(e.id_bon),
                                          'Voulez-vous valider ce Bon de sortie',
                                          'valideCom')
                                      .then((value) {
                                    if (int.parse(value) == 1) {
                                      ConfirmBox()
                                          .showAlert(
                                              context,
                                              "Bon de sortie valié avec success",
                                              true)
                                          .then((value) {});
                                    }
                                  });
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Text(''),
                      ],
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          user!.text = state.user!.id.toString();
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
                              child: SingleChildScrollView(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        color: Colors.white,
                                        height:
                                            MediaQuery.of(context).size.height -
                                                77,
                                        margin:
                                            EdgeInsets.only(left: 7, top: 8),
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      clienSearch
                                                          ? Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10,
                                                                      left: 5),
                                                              width: 400,
                                                              child: TextField(
                                                                decoration: InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    hintText:
                                                                        "Rechercher par fournisseur..."),
                                                                onChanged:
                                                                    (seach) {
                                                                  setState(() {
                                                                    copyListbonSortie = listbonSortie!
                                                                        .where((element) => (element
                                                                            .nom_bon
                                                                            .toLowerCase()
                                                                            .contains(seach.toLowerCase())))
                                                                        .toList();
                                                                  });
                                                                },
                                                              ),
                                                            )
                                                          : idSearch
                                                              ? Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              5),
                                                                  width: 400,
                                                                  child:
                                                                      TextField(
                                                                    decoration: InputDecoration(
                                                                        contentPadding:
                                                                            EdgeInsets.all(
                                                                                10),
                                                                        hintText:
                                                                            "Rechercher par numero de commande..."),
                                                                    onChanged:
                                                                        (seach) {
                                                                      setState(
                                                                          () {
                                                                        copyListbonSortie = listbonSortie!
                                                                            .where((element) =>
                                                                                (element.id_bon.toLowerCase().contains(seach.toLowerCase())))
                                                                            .toList();
                                                                      });
                                                                    },
                                                                  ),
                                                                )
                                                              : Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              5),
                                                                  width: 400,
                                                                  child:
                                                                      TextField(
                                                                    decoration: InputDecoration(
                                                                        contentPadding:
                                                                            EdgeInsets.all(
                                                                                10),
                                                                        hintText:
                                                                            "Rechercher par date de creation de commande..."),
                                                                    onChanged:
                                                                        (seach) {
                                                                      setState(
                                                                          () {
                                                                        copyListbonSortie = listbonSortie!
                                                                            .where((element) =>
                                                                                (element.date_bon.toLowerCase().contains(seach.toLowerCase())))
                                                                            .toList();
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                      Row(
                                                        children: [
                                                          MaterialButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return ClientFactureName();
                                                                  }).then((value) {
                                                                if (value !=
                                                                    '**0**') {
                                                                  String val =
                                                                      value;
                                                                  Services.getClientIdBon(
                                                                          value
                                                                              .toString()
                                                                              .split('*')[0]
                                                                              .split('-')[1],
                                                                          ' ')
                                                                      .then((valu) {
                                                                    if (int.parse(
                                                                            valu) !=
                                                                        -1) {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          barrierDismissible:
                                                                              false,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return CreateBonClient(
                                                                              clientId: valu,
                                                                              clientName: val.toString().split('*')[0].split('-')[1],
                                                                              idCom: val.toString().split('*')[2],
                                                                            );
                                                                          }).then((value) {
                                                                        setState(
                                                                            () {
                                                                          typeBon =
                                                                              '';
                                                                          getListeBon(
                                                                              '');
                                                                        });
                                                                      });
                                                                    } else {
                                                                      ConfirmBox().showAlert(
                                                                          context,
                                                                          "Erreur de connexion",
                                                                          false);
                                                                    }
                                                                  });
                                                                }
                                                              });
                                                            },
                                                            color: Colors.blue,
                                                            height: 50,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        30),
                                                            child: Text(
                                                                'Bon client',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          MaterialButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return ListBoutique();
                                                                  });
                                                            },
                                                            color: Colors
                                                                .deepOrange,
                                                            height: 50,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        30),
                                                            child: Text(
                                                                'Bon boutique',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.black)),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      205,
                                                  child: ImprovedScrolling(
                                                    enableCustomMouseWheelScrolling:
                                                        true,
                                                    enableKeyboardScrolling:
                                                        true,
                                                    enableMMBScrolling: true,
                                                    mmbScrollConfig:
                                                        MMBScrollConfig(
                                                      customScrollCursor:
                                                          DefaultCustomScrollCursor(
                                                        backgroundColor:
                                                            Colors.white,
                                                        cursorColor:
                                                            Color(0xFF26345d),
                                                      ),
                                                    ),
                                                    customMouseWheelScrollConfig:
                                                        CustomMouseWheelScrollConfig(
                                                            scrollAmountMultiplier:
                                                                4.0),
                                                    scrollController:
                                                        controller,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                315,
                                                            child:
                                                                _commandeBody),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                afficheType
                                                    ? MaterialButton(
                                                        onPressed: () {
                                                          getListeBon('');
                                                          setState(() {
                                                            afficheType = false;
                                                            typeBon = ' ';
                                                          });
                                                        },
                                                        color:
                                                            Colors.deepOrange,
                                                        height: 52,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 30),
                                                        child: Text(
                                                          'Bon Client',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )
                                                    : MaterialButton(
                                                        onPressed: () {
                                                          getListeBon(
                                                              'boutique');
                                                          setState(() {
                                                            afficheType = true;
                                                            typeBon =
                                                                'boutique';
                                                          });
                                                        },
                                                        color: Colors.blue,
                                                        height: 52,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 30),
                                                        child: Text(
                                                          'Bon boutique',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
