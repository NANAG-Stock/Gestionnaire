// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, duplicate_ignore, unused_field

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
import 'package:flutter_redux/flutter_redux.dart';

class MagaCommande extends StatefulWidget {
  const MagaCommande({Key? key}) : super(key: key);

  @override
  _MagaCommandeState createState() => _MagaCommandeState();
}

class _MagaCommandeState extends State<MagaCommande> {
  TextEditingController? fourName;
  TextEditingController? user;
  List<String>? fourList;
  List<CommandeModel>? commList;
  List<CommandeModel>? copyCommList;
  CommandeModel? selectCom;
  GlobalKey<FormState>? _comKey;
  bool checkEmpty = true;
  bool clickCom = false;
  bool clienSearch = true;
  bool idSearch = false;
  bool dateSearch = false;
  double colSpace = 49;

  @override
  void initState() {
    fourName = TextEditingController();
    user = TextEditingController();
    _comKey = GlobalKey();
    checkEmpty = true;
    clickCom = false;
    commList = [];
    copyCommList = [];
    fourList = [];
    colSpace = 49;
    getFouList();
    getCommandes();
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

  void getCommandes() {
    Services.getCom().then((value) {
      if (int.parse(value.map((e) => e.idCom).toList()[0]) == 0) {
        ConfirmBox().showAlert(context, 'Aucune commande trouveé', false);
        setState(() {
          commList = [];
          copyCommList = [];
        });
      } else if (int.parse(value.map((e) => e.idCom).toList()[0]) > 0) {
        setState(() {
          commList = value;
          copyCommList = value;
        });
      } else if (int.parse(value.map((e) => e.idCom).toList()[0]) < 0) {
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
          columnSpacing: 52,
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
                                  getCommandes();
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
                                            .then((value) => getCommandes());
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
                                        getCommandes();
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
                                                clienSearch
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 10,
                                                            left: 5),
                                                        width: 400,
                                                        child: TextField(
                                                          decoration: InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              hintText:
                                                                  "Rechercher par fournisseur..."),
                                                          onChanged: (seach) {
                                                            setState(() {
                                                              copyCommList = commList!
                                                                  .where((element) => (element
                                                                      .fourNom
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          seach
                                                                              .toLowerCase())))
                                                                  .toList();
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    : idSearch
                                                        ? Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 10,
                                                                    left: 5),
                                                            width: 400,
                                                            child: TextField(
                                                              decoration: InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  hintText:
                                                                      "Rechercher par numero de commande..."),
                                                              onChanged:
                                                                  (seach) {
                                                                setState(() {
                                                                  copyCommList = commList!
                                                                      .where((element) => (element
                                                                          .idCom
                                                                          .toLowerCase()
                                                                          .contains(
                                                                              seach.toLowerCase())))
                                                                      .toList();
                                                                });
                                                              },
                                                            ),
                                                          )
                                                        : Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 10,
                                                                    left: 5),
                                                            width: 400,
                                                            child: TextField(
                                                              decoration: InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  hintText:
                                                                      "Rechercher par date de creation de commande..."),
                                                              onChanged:
                                                                  (seach) {
                                                                setState(() {
                                                                  copyCommList = commList!
                                                                      .where((element) => (element
                                                                          .comDate
                                                                          .toLowerCase()
                                                                          .contains(
                                                                              seach.toLowerCase())))
                                                                      .toList();
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            250,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.black),
                                                    ),
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            205,
                                                    child: Row(
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
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 7),
                                                  width: 200,
                                                  height: 60,
                                                  child: Builder(
                                                      builder: (context) {
                                                    return MaterialButton(
                                                        color:
                                                            Color(0xff101c3a),
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
                                                              .then((value) {
                                                            getFouList();
                                                            if (value
                                                                    .toString()
                                                                    .split('=>')
                                                                    .length >
                                                                1) {
                                                              Services.creatCom(
                                                                      fourName!
                                                                          .text
                                                                          .split(
                                                                              '=>')[0],
                                                                      user!.text)
                                                                  .then((value) {
                                                                if (int.parse(
                                                                        value) ==
                                                                    1) {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          false,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return CreatCommande(
                                                                          fourId: fourName!
                                                                              .text
                                                                              .split('=>')[0],
                                                                          forName: fourName!
                                                                              .text
                                                                              .split('=>')[1],
                                                                        );
                                                                      }).then((value) {
                                                                    setState(
                                                                        () {
                                                                      fourName!
                                                                          .text = "";
                                                                      getCommandes();
                                                                    });
                                                                  });
                                                                } else if (int
                                                                        .parse(
                                                                            value) ==
                                                                    0) {
                                                                  ConfirmBox()
                                                                      .showAlert(
                                                                          context,
                                                                          'Impossible de créer la Commande',
                                                                          false);
                                                                } else {
                                                                  ConfirmBox()
                                                                      .showAlert(
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
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ));
                                                  }),
                                                ),
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
