// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, duplicate_ignore, non_constant_identifier_names

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/alert_box_2.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/database/CommandeModel.dart';
import 'package:application_principal/database/services.dart';
import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Commande extends StatefulWidget {
  const Commande({Key? key}) : super(key: key);

  @override
  _CommandeState createState() => _CommandeState();
}

class _CommandeState extends State<Commande> {
  TextEditingController? fourName;
  TextEditingController? user;
  List<String>? fourList;
  List<CommandeModel>? commList;
  List<CommandeModel>? copyCommList;
  CommandeModel? selectCom;
  // GlobalKey<FormState>? _comKey;
  bool checkEmpty = true;
  bool clickCom = false;
  bool clienSearch = true;
  bool idSearch = false;
  bool dateSearch = false;
  double colSpace = 49;
  bool is_loading = true;
  bool is_empty = false;

  bool isDeliver = false;

  TextEditingController end = TextEditingController();
  TextEditingController seach = TextEditingController();
  TextEditingController seachInput = TextEditingController();
  bool isSeachInputEmpty = true;
  bool endPred = false;
  bool endSuiv = false;

  @override
  void initState() {
    fourName = TextEditingController();
    user = TextEditingController();
    // _comKey = GlobalKey();
    checkEmpty = true;
    clickCom = false;
    commList = [];
    copyCommList = [];
    fourList = [];
    colSpace = 49;
    getFouList();
    end.text = "0";
    seach.text = '';
    getCommandes('0', seach.text, end.text, true, true);
    super.initState();
  }

  getFouList() {
    Services.getFournisseur().then((value) {
      if (int.parse(value.map((e) => e.idFour).toList()[0]) == 0) {
        ConfirmBox().showAlert(context, 'Aucun fournisseur trouve', false);
        setState(() {
          fourList = [];
        });
      } else if (int.parse(value.map((e) => e.idFour).toList()[0]) > 0) {
        setState(() {
          fourList = value.map((e) => '${e.idFour} => ${e.nomFour}').toList();
        });
      }
    });
  }

  // Recuperation des achat avec Limit
  void getCommandes(
      String isDeliver, String search, String ends, bool isfront, bool same) {
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

    Services.getComLimit(isDeliver, limit, search).then((value) {
      setState(() {
        is_loading = false;
      });
      if (int.parse(value.map((e) => e.idCom).toList()[0]) == 0) {
        setState(() {
          is_empty = true;
        });
        // ConfirmBox().showAlert(context, 'Aucune commande trouveé', false);
        setState(() {
          commList = [];
          copyCommList = [];
        });
      } else if (int.parse(value.map((e) => e.idCom).toList()[0]) > 0) {
        setState(() {
          commList = value;
          copyCommList = value;
          value.length < 12 ? endSuiv = true : endSuiv = false;
        });
      } else if (int.parse(value.map((e) => e.idCom).toList()[0]) < 0) {
        setState(() {
          is_empty = true;
        });
        ConfirmBox().showAlert(context, 'Erreur de connexion', false);
        setState(() {
          commList = [];
          copyCommList = [];
        });
      }
    }).then((value) {
      if (!commList!.map((e) => e.comEtat).toList().contains('0')) {
        setState(() {
          colSpace = 49;
        });
      } else {
        setState(() {
          colSpace = 31;
        });
      }
    });
  }

  WidgetBuilder get _achatHorizontalDrawerBuilder {
    return (BuildContext context) {
      return Container(
        margin: EdgeInsets.only(top: 70),
        width: 470,
        height: 755,
        child: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 15,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 390,
                      height: 710,
                      child: DropDownField(
                          value: fourName!.text,
                          required: false,
                          strict: false,
                          labelText: 'Rechercher un fournisseur',
                          items: fourList,
                          itemsVisibleInDropdown: 13,
                          onValueChanged: (dynamic newValue) {
                            fourName!.text = newValue;
                          }),
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (fourName!.text.isEmpty) {
                          ConfirmBox().showAlert(context,
                              "Veuillez choisir un fournisseur", false);
                          setState(() {
                            checkEmpty = false;
                          });
                        } else {
                          Navigator.of(context).pop(fourName!.text);
                        }
                      },
                      height: 57,
                      color: Color(0xFF0D8D42),
                      elevation: 0,
                      child: Text(
                        "Valider",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFECEAEA),
                    border: Border.all(
                      width: 1.5,
                      color: Color(0xFF6D6767),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 60,
                        width: 190,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              fourName!.text = "";
                            });
                            Navigator.pop(context);
                          },
                          color: Color(0xFFF11809),
                          child: Text(
                            "Quitter",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    };
  }

  SingleChildScrollView get _commandeBody {
    return SingleChildScrollView(
      controller: ScrollController(),
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.horizontal,
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
                      Text("Nu_Comm"),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              copyCommList = commList;
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
                      Text("Nom_Four"),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              copyCommList = commList;
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
              label: Text("Prix_total"),
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
                              copyCommList = commList;
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
              label: Text("Etat"),
            ),
            DataColumn(
              label: Text("Action"),
            ),
          ],
          rows: copyCommList!
              .map(
                (e) => DataRow(cells: [
                  DataCell(
                    Text(e.idCom),
                  ),
                  DataCell(
                    Text(e.nbrProd),
                  ),
                  DataCell(
                    Text(e.fourNom),
                  ),
                  DataCell(
                    Text("${e.prixTotal} Fcfa"),
                  ),
                  DataCell(
                    Text(
                      e.comDate,
                    ),
                  ),
                  DataCell(
                    Text(
                      e.comEtat == '0' ? 'En cours...' : 'Valider',
                      style: TextStyle(
                          color: (e.comEtat == '0')
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
                                    return SeeCommande(
                                      selectCom: e,
                                    );
                                  }).then((value) {
                                setState(() {
                                  isDeliver
                                      ? getCommandes(
                                          '1', seach.text, end.text, true, true)
                                      : getCommandes('0', seach.text, end.text,
                                          true, true);
                                });
                              });
                            });
                          },
                        ),
                        int.parse(e.comEtat) == 0
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
                                          int.parse(e.idCom),
                                          'Voulez-vous supprimer cette commande?',
                                          'ravitail')
                                      .then((value) {
                                    if (value == "1") {
                                      setState(() {
                                        ConfirmBox()
                                            .showAlert(
                                                context,
                                                'Commande supprimée avec success',
                                                true)
                                            .then((value) => isDeliver
                                                ? getCommandes('1', seach.text,
                                                    end.text, true, true)
                                                : getCommandes('0', seach.text,
                                                    end.text, true, true));
                                      });
                                    }
                                  });
                                },
                              )
                            : Text(''),
                        int.parse(e.comEtat) == 0
                            ? TextButton(
                                onPressed: () {
                                  AlertBox()
                                      .showAlertDialod(
                                          context,
                                          int.parse(e.idCom),
                                          'Voulez-vous valider cette commande',
                                          'valideCom')
                                      .then((value) {
                                    if (int.parse(value) == 1) {
                                      ConfirmBox()
                                          .showAlert(
                                              context,
                                              "Commande valiée avec success",
                                              true)
                                          .then((value) {
                                        isDeliver
                                            ? getCommandes('1', seach.text,
                                                end.text, true, true)
                                            : getCommandes('0', seach.text,
                                                end.text, true, true);
                                      });
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
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 10,
                                                                    left: 5),
                                                            width: 400,
                                                            child: TextField(
                                                              controller:
                                                                  seachInput,
                                                              decoration: InputDecoration(
                                                                  suffixIcon: MaterialButton(
                                                                    color: Color(
                                                                        0xFF26345d),
                                                                    height: 55,
                                                                    onPressed:
                                                                        () {
                                                                      if (seachInput
                                                                          .text
                                                                          .isEmpty) {
                                                                        if (mounted) {
                                                                          setState(
                                                                              () {
                                                                            seach.text =
                                                                                "";
                                                                            isSeachInputEmpty =
                                                                                true;
                                                                          });
                                                                        }
                                                                      } else {
                                                                        end.text =
                                                                            '0';
                                                                        if (clienSearch) {
                                                                          if (mounted) {
                                                                            setState(() {
                                                                              seach.text = "AND four.Nom_four LIKE '%${seachInput.text}%'";
                                                                            });
                                                                          }
                                                                        } else {
                                                                          if (idSearch) {
                                                                            if (mounted) {
                                                                              setState(() {
                                                                                seach.text = "AND rav.Id_rav LIKE '%${seachInput.text}%'";
                                                                              });
                                                                            }
                                                                          } else {
                                                                            if (mounted) {
                                                                              setState(() {
                                                                                seach.text = "AND rav.Date_rav LIKE '%${seachInput.text}%'";
                                                                              });
                                                                            }
                                                                          }
                                                                        }
                                                                      }
                                                                      isDeliver
                                                                          ? getCommandes(
                                                                              '1',
                                                                              seach
                                                                                  .text,
                                                                              end
                                                                                  .text,
                                                                              true,
                                                                              true)
                                                                          : getCommandes(
                                                                              '0',
                                                                              seach.text,
                                                                              end.text,
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
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  hintText: clienSearch
                                                                      ? "Rechercher par fournisseur..."
                                                                      : idSearch
                                                                          ? "Rechercher par numero de commande..."
                                                                          : "Rechercher par date de creation de commande..."),
                                                              onChanged:
                                                                  (seach) {
                                                                setState(() {
                                                                  isSeachInputEmpty =
                                                                      false;
                                                                  if (clienSearch) {
                                                                    copyCommList = commList!
                                                                        .where((element) => (element
                                                                            .fourNom
                                                                            .toLowerCase()
                                                                            .contains(seach.toLowerCase())))
                                                                        .toList();
                                                                  } else {
                                                                    if (idSearch) {
                                                                      copyCommList = commList!
                                                                          .where((element) => (element
                                                                              .idCom
                                                                              .toLowerCase()
                                                                              .contains(seach.toLowerCase())))
                                                                          .toList();
                                                                    } else {
                                                                      copyCommList = commList!
                                                                          .where((element) => (element
                                                                              .comDate
                                                                              .toLowerCase()
                                                                              .contains(seach.toLowerCase())))
                                                                          .toList();
                                                                    }
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            child:
                                                                MaterialButton(
                                                              height: 40,
                                                              color: !isDeliver
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                              onPressed: () {
                                                                end.text = '0';
                                                                if (mounted) {
                                                                  setState(() {
                                                                    if (isDeliver) {
                                                                      isDeliver =
                                                                          false;
                                                                      getCommandes(
                                                                          '0',
                                                                          seach
                                                                              .text,
                                                                          end.text,
                                                                          true,
                                                                          true);
                                                                    } else {
                                                                      isDeliver =
                                                                          true;
                                                                      getCommandes(
                                                                          '1',
                                                                          seach
                                                                              .text,
                                                                          end.text,
                                                                          true,
                                                                          true);
                                                                    }
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                !isDeliver
                                                                    ? 'Livrée'
                                                                    : "Non Livrée",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              250,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black),
                                                          ),
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
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    _commandeBody,
                                                                  ],
                                                                )),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 7),
                                                        width: 200,
                                                        height: 60,
                                                        child: Builder(
                                                            builder: (context) {
                                                          return MaterialButton(
                                                              color: Color(
                                                                  0xff101c3a),
                                                              onPressed: () {
                                                                showGlobalDrawer(
                                                                        barrierDismissible:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            _achatHorizontalDrawerBuilder,
                                                                        direction:
                                                                            AxisDirection
                                                                                .right)
                                                                    .then(
                                                                        (value) {
                                                                  getFouList();
                                                                  if (value
                                                                          .toString()
                                                                          .split(
                                                                              '=>')
                                                                          .length >
                                                                      1) {
                                                                    Services.creatCom(
                                                                            fourName!.text.split('=>')[
                                                                                0],
                                                                            user!
                                                                                .text)
                                                                        .then(
                                                                            (value) {
                                                                      if (int.parse(
                                                                              value) ==
                                                                          1) {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                CreatCommande(
                                                                              fourId: fourName!.text.split('=>')[0],
                                                                              forName: fourName!.text.split('=>')[1],
                                                                            ),
                                                                          ),
                                                                        ).then(
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            fourName!.text =
                                                                                "";
                                                                            isDeliver
                                                                                ? getCommandes('1', seach.text, end.text, true, true)
                                                                                : getCommandes('0', seach.text, end.text, true, true);
                                                                          });
                                                                        });
                                                                        // showDialog(
                                                                        //     context:
                                                                        //         context,
                                                                        //     barrierDismissible:
                                                                        //         false,
                                                                        //     builder:
                                                                        //         (BuildContext context) {
                                                                        //       return CreatCommande(
                                                                        //         fourId: fourName!.text.split('=>')[0],
                                                                        //         forName: fourName!.text.split('=>')[1],
                                                                        //       );
                                                                        //     }).then((value) {
                                                                        //   setState(
                                                                        //       () {
                                                                        //     fourName!.text =
                                                                        //         "";
                                                                        //     isDeliver
                                                                        //         ? getCommandes('1', seach.text, end.text, true, true)
                                                                        //         : getCommandes('0', seach.text, end.text, true, true);
                                                                        //   });
                                                                        // });
                                                                      } else if (int.parse(
                                                                              value) ==
                                                                          0) {
                                                                        ConfirmBox().showAlert(
                                                                            context,
                                                                            'Impossible de créer la Commande',
                                                                            false);
                                                                      } else {
                                                                        ConfirmBox().showAlert(
                                                                            context,
                                                                            'Erreur de connexion',
                                                                            false);
                                                                      }
                                                                    });
                                                                  }
                                                                });
                                                              },
                                                              child: Text(
                                                                "Nouvelle Commande",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ));
                                                        }),
                                                      ),
                                                      Container(
                                                        width: 300,
                                                        child: BootstrapContainer(
                                                            fluid: true,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 20),
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
                                                                              height: 40,
                                                                              color: endPred ? Colors.grey : Colors.red,
                                                                              onPressed: () {
                                                                                endPred
                                                                                    ? null
                                                                                    : isDeliver
                                                                                        ? getCommandes('1', seach.text, end.text, false, false)
                                                                                        : getCommandes('0', seach.text, end.text, false, false);
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
                                                                                    : isDeliver
                                                                                        ? getCommandes('1', seach.text, end.text, true, false)
                                                                                        : getCommandes('0', seach.text, end.text, true, false);
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
