// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, duplicate_ignore, non_constant_identifier_names

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/alert_box_3.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/database/bon_sortie_model.dart';
import 'package:application_principal/database/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BonDeSortie extends StatefulWidget {
  const BonDeSortie({Key? key}) : super(key: key);

  @override
  _BonDeSortieState createState() => _BonDeSortieState();
}

class _BonDeSortieState extends State<BonDeSortie> {
  TextEditingController? user;
  List<String>? fourList;
  List<BonSortieModel>? listbonSortie;
  List<BonSortieModel>? copyListbonSortie;
  BonSortieModel? selectCom;
  bool checkEmpty = true;
  bool clickCom = false;
  bool clienSearch = true;
  bool livraire = false;
  bool idSearch = false;
  bool dateSearch = false;
  bool afficheType = true;
  final controller = ScrollController();
  double colSpace = 49;
  String typeBon = 'boutique';
  String idBon = '';
  TextEditingController end = TextEditingController();
  TextEditingController seach = TextEditingController();
  TextEditingController seachInput = TextEditingController();
  bool endPred = false;
  bool endSuiv = false;
  bool is_loading = true;
  bool is_empty = false;

  @override
  void initState() {
    user = TextEditingController();
    listbonSortie = [];
    copyListbonSortie = [];
    checkEmpty = true;
    clickCom = false;
    fourList = [];
    colSpace = 49;
    seach.text = '';
    end.text = "0";
    getListeBon('boutique', seach.text, end.text, true, true);
    super.initState();
  }

  getListeBon(
      String type, String cherche, String ends, bool isfront, bool same) {
    setState(() {
      is_loading = true;
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

    Services.getAllBonSortieInfosLimit(type, limit, cherche).then((value) {
      setState(() {
        is_loading = false;
      });
      if (int.parse(value.map((e) => e.id_bon).toList()[0]) < 0) {
        ConfirmBox().showAlert(context, "Erreur de connexion", false);
        setState(() {
          is_empty = true;
          listbonSortie = [];
          copyListbonSortie = [];
        });
      } else {
        if (int.parse(value.map((e) => e.id_bon).toList()[0]) == 0) {
          // ConfirmBox().showAlert(context, "Aucune donnée trouvée", false);
          setState(() {
            is_empty = true;
            listbonSortie = [];
            copyListbonSortie = [];
          });
        } else {
          setState(() {
            listbonSortie = value;
            copyListbonSortie = value;
            value.length < 12 ? endSuiv = true : endSuiv = false;
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
                              livraire = false;
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
                              livraire = false;
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
                              livraire = false;
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
              label: Row(
                children: [
                  Text("Livraire"),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          copyListbonSortie = listbonSortie;
                          clienSearch = false;
                          idSearch = false;
                          dateSearch = false;
                          livraire = true;
                        });
                      },
                      icon: Icon(
                        Icons.filter_list_alt,
                        size: 20,
                        color: livraire ? Colors.green : Colors.black,
                      ))
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
                    e.livraire_bon == "NULL"
                        ? Center(
                            child: Text(
                              '=======',
                            ),
                          )
                        : Text(
                            e.livraire_bon,
                          ),
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
                          color: (e.is_print_bon == '0')
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
                                    getListeBon('boutique', seach.text,
                                        end.text, true, true);
                                    afficheType = true;
                                  } else {
                                    getListeBon(
                                        ' ', seach.text, end.text, true, true);
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
                                              getListeBon(
                                                  'boutique',
                                                  seach.text,
                                                  end.text,
                                                  true,
                                                  true);
                                              afficheType = true;
                                            } else {
                                              getListeBon(' ', seach.text,
                                                  end.text, true, true);
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
                                        child: AppBarCus()),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 11,
                              child: SingleChildScrollView(
                                controller: ScrollController(),
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
                                        margin: EdgeInsets.only(
                                            left: state.isClosed! ? 0 : 7,
                                            top: 8),
                                        width: double.infinity,
                                        child: is_loading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10,
                                                                      left: 5),
                                                              width: 400,
                                                              child: TextField(
                                                                controller:
                                                                    seachInput,
                                                                decoration: InputDecoration(
                                                                    suffixIcon: MaterialButton(
                                                                      color: Color(
                                                                          0xFF26345d),
                                                                      height:
                                                                          55,
                                                                      onPressed:
                                                                          () {
                                                                        if (seachInput
                                                                            .text
                                                                            .isEmpty) {
                                                                          if (mounted) {
                                                                            setState(() {
                                                                              seach.text = "";
                                                                            });
                                                                          }
                                                                        } else {
                                                                          end.text =
                                                                              '0';
                                                                          if (clienSearch) {
                                                                            if (mounted) {
                                                                              setState(() {
                                                                                if (typeBon == 'boutique') {
                                                                                  seach.text = "AND bou.nom_bout LIKE '%${seachInput.text}%'";
                                                                                } else {
                                                                                  seach.text = "AND cl.nom_complet_client LIKE '%${seachInput.text}%'";
                                                                                }
                                                                              });
                                                                            }
                                                                          } else {
                                                                            if (idSearch) {
                                                                              if (mounted) {
                                                                                setState(() {
                                                                                  seach.text = "AND b.id_bon LIKE '%${seachInput.text}%'";
                                                                                });
                                                                              }
                                                                            } else {
                                                                              if (livraire) {
                                                                                if (mounted) {
                                                                                  setState(() {
                                                                                    seach.text = "AND b.livraire_bon LIKE '%${seachInput.text}%'";
                                                                                  });
                                                                                }
                                                                              } else {
                                                                                if (mounted) {
                                                                                  setState(() {
                                                                                    seach.text = "AND b.date_bon LIKE '%${seachInput.text}%'";
                                                                                  });
                                                                                }
                                                                              }
                                                                            }
                                                                          }
                                                                        }
                                                                        afficheType
                                                                            ? getListeBon(
                                                                                'boutique',
                                                                                seach.text,
                                                                                end.text,
                                                                                true,
                                                                                true)
                                                                            : getListeBon('', seach.text, end.text, true, true);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    contentPadding: EdgeInsets.all(10),
                                                                    hintText: clienSearch
                                                                        ? "Rechercher par client/boutique..."
                                                                        : idSearch
                                                                            ? "Rechercher par numéro de bon..."
                                                                            : livraire
                                                                                ? "Rechercher par nom livraire..."
                                                                                : "Rechercher par date de création du bon..."),
                                                                onChanged:
                                                                    (seach) {
                                                                  setState(() {
                                                                    if (clienSearch) {
                                                                      copyListbonSortie = listbonSortie!
                                                                          .where((element) => (element
                                                                              .nom_bon
                                                                              .toLowerCase()
                                                                              .contains(seach.toLowerCase())))
                                                                          .toList();
                                                                    } else {
                                                                      if (idSearch) {
                                                                        copyListbonSortie = listbonSortie!
                                                                            .where((element) =>
                                                                                (element.id_bon.toLowerCase().contains(seach.toLowerCase())))
                                                                            .toList();
                                                                      } else {
                                                                        if (livraire) {
                                                                          copyListbonSortie = listbonSortie!
                                                                              .where((element) => (element.livraire_bon.toLowerCase().contains(seach.toLowerCase())))
                                                                              .toList();
                                                                        } else {
                                                                          copyListbonSortie = listbonSortie!
                                                                              .where((element) => (element.date_bon.toLowerCase().contains(seach.toLowerCase())))
                                                                              .toList();
                                                                        }
                                                                      }
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                MaterialButton(
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
                                                                          return ClientFactureName();
                                                                        }).then((value) {
                                                                      if (value !=
                                                                          '**0**') {
                                                                        String
                                                                            val =
                                                                            value;
                                                                        Services.getClientIdBon(value.toString().split('*')[0].split('-')[1],
                                                                                ' ')
                                                                            .then((valu) {
                                                                          if (int.parse(valu) !=
                                                                              -1) {
                                                                            showDialog(
                                                                                context: context,
                                                                                barrierDismissible: false,
                                                                                builder: (BuildContext context) {
                                                                                  return CreateBonClient(
                                                                                    clientId: valu,
                                                                                    clientName: val.toString().split('*')[0].split('-')[1],
                                                                                    idCom: val.toString().split('*')[2],
                                                                                  );
                                                                                }).then((value) {
                                                                              setState(() {
                                                                                typeBon = '';
                                                                                getListeBon('', seach.text, end.text, true, true);
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
                                                                  color: Colors
                                                                      .blue,
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
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.white)),
                                                                ),
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                                MaterialButton(
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
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.white)),
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
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height -
                                                            205,
                                                        child: is_empty
                                                            ? Center(
                                                                child: Text(
                                                                  'Aucune donnée trouvée',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .red),
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
                                                                        Colors
                                                                            .white,
                                                                    cursorColor:
                                                                        Color(
                                                                            0xFF26345d),
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
                                                                        width: MediaQuery.of(context).size.width -
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
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          afficheType
                                                              ? MaterialButton(
                                                                  onPressed:
                                                                      () {
                                                                    end.text =
                                                                        '0';
                                                                    getListeBon(
                                                                        '',
                                                                        seach
                                                                            .text,
                                                                        end.text,
                                                                        true,
                                                                        true);
                                                                    setState(
                                                                        () {
                                                                      afficheType =
                                                                          false;
                                                                      typeBon =
                                                                          ' ';
                                                                    });
                                                                  },
                                                                  color: Colors
                                                                      .deepOrange,
                                                                  height: 52,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              30),
                                                                  child: Text(
                                                                    'Bon Client',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                )
                                                              : MaterialButton(
                                                                  onPressed:
                                                                      () {
                                                                    end.text =
                                                                        '0';
                                                                    getListeBon(
                                                                        'boutique',
                                                                        seach
                                                                            .text,
                                                                        end.text,
                                                                        true,
                                                                        true);
                                                                    setState(
                                                                        () {
                                                                      afficheType =
                                                                          true;
                                                                      typeBon =
                                                                          'boutique';
                                                                    });
                                                                  },
                                                                  color: Colors
                                                                      .blue,
                                                                  height: 52,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              30),
                                                                  child: Text(
                                                                    'Bon boutique',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                          SizedBox(
                                                            width: 300,
                                                            child: BootstrapContainer(
                                                                fluid: true,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                children: [
                                                                  BootstrapRow(
                                                                      children: [
                                                                        BootstrapCol(
                                                                            sizes:
                                                                                'col-12',
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                MaterialButton(
                                                                                  height: 40,
                                                                                  color: endPred ? Colors.grey : Colors.red,
                                                                                  onPressed: () {
                                                                                    endPred
                                                                                        ? null
                                                                                        : afficheType
                                                                                            ? getListeBon('boutique', seach.text, end.text, false, false)
                                                                                            : getListeBon('', seach.text, end.text, false, false);
                                                                                  },
                                                                                  child: Text("Précédent", style: TextStyle(color: endPred ? Colors.black : Colors.white)),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 30,
                                                                                ),
                                                                                MaterialButton(
                                                                                  height: 40,
                                                                                  color: endSuiv ? Colors.grey : Colors.green,
                                                                                  onPressed: () {
                                                                                    endSuiv
                                                                                        ? null
                                                                                        : afficheType
                                                                                            ? getListeBon('boutique', seach.text, end.text, true, false)
                                                                                            : getListeBon('', seach.text, end.text, true, false);
                                                                                  },
                                                                                  child: Text(
                                                                                    "Suivant",
                                                                                    style: TextStyle(color: endSuiv ? Colors.black : Colors.white),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ))
                                                                      ])
                                                                ]),
                                                          )
                                                        ],
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
