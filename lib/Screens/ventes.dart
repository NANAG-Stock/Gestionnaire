// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, duplicate_ignore, non_constant_identifier_names

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/database/services.dart';
import 'package:application_principal/database/venteModel.dart';
import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Ventes extends StatefulWidget {
  const Ventes({Key? key}) : super(key: key);

  @override
  _VentesState createState() => _VentesState();
}

class _VentesState extends State<Ventes> {
  TextEditingController? clientName;
  TextEditingController? user;
  List<String>? clientList;
  List<VenteModel>? venteList;
  List<VenteModel>? venteListCopy;
  VenteModel? selectVente;
  bool checkEmpty = true;
  bool clickCom = false;
  double colSpace = 49;
  bool clienSearch = true;
  bool dateSearch = false;
  bool etatSearch = false;
  bool idSearch = false;
  bool isDeliver = false;
  bool is_loading = true;
  bool is_empty = false;

  final controller = ScrollController();
  final controller1 = ScrollController();
  TextEditingController end = TextEditingController();
  TextEditingController seach = TextEditingController();
  TextEditingController seachInput = TextEditingController();
  bool endPred = false;
  bool endSuiv = false;

  @override
  void initState() {
    clientName = TextEditingController();
    user = TextEditingController();
    checkEmpty = true;
    clickCom = false;
    venteList = [];
    venteListCopy = [];
    clientList = [];
    colSpace = 49;
    getClientList();
    end.text = "0";
    seach.text = '';
    getVente('0', seach.text, end.text, true, true);
    clienSearch = true;
    dateSearch = false;
    etatSearch = false;
    idSearch = false;
    super.initState();
  }

  getClientList() {
    Services.getClients().then((value) {
      if (int.parse(value.map((e) => e.id_client).toList()[0]) == 0) {
        // ConfirmBox().showAlert(context, 'Aucun client trouvé', false);
        setState(() {
          clientList = [];
        });
      } else if (int.parse(value.map((e) => e.id_client).toList()[0]) > 0) {
        setState(() {
          clientList = value
              .map((e) => '${e.id_client} => ${e.nom_complet_client}')
              .toList();
        });
      } else if (int.parse(value.map((e) => e.id_client).toList()[0]) < 0) {
        ConfirmBox().showAlert(context, 'Erreur de connexion', false);
      }
    });
  }

  void getVente(
      String isDeliver, String search, String ends, bool isfront, bool same) {
    setState(() {
      is_empty = false;
      is_loading = true;
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

    Services.getVenteLimit(isDeliver, limit, search).then((value) {
      setState(() {
        is_loading = false;
      });
      if (int.parse(value.map((e) => e.idCom).toList()[0]) == 0) {
        // ConfirmBox().showAlert(context, 'Aucune Vente trouveé', false);
        setState(() {
          venteList = [];
          is_empty = true;
        });
      } else if (int.parse(value.map((e) => e.idCom).toList()[0]) > 0) {
        setState(() {
          venteList = value;
          venteListCopy = value;
          value.length < 12 ? endSuiv = true : endSuiv = false;
        });
      } else if (int.parse(value.map((e) => e.idCom).toList()[0]) < 0) {
        ConfirmBox().showAlert(context, 'Erreur de connexion', false);
        setState(() {
          venteList = [];
          is_empty = true;
        });
      }
    }).then((value) {
      if (!venteList!.map((e) => e.comEtat).toList().contains('0')) {
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

  WidgetBuilder get _venteHorizontalDrawerBuilder {
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
                          value: clientName!.text,
                          required: false,
                          strict: false,
                          labelText: 'Rechercher un client',
                          items: clientList,
                          itemsVisibleInDropdown: 13,
                          onValueChanged: (dynamic newValue) {
                            clientName!.text = newValue;
                          }),
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (clientName!.text.isEmpty) {
                          ConfirmBox().showAlert(
                              context, "Veuillez choisir un client", false);
                          setState(() {
                            checkEmpty = false;
                          });
                        } else {
                          Navigator.of(context).pop(clientName!.text);
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
                        width: 100,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              clientName!.text = "";
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
                      Container(
                        width: 200,
                        height: 60,
                        child: MaterialButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AddClientAlert();
                                }).then((value) {
                              Navigator.pop(context);
                            });
                          },
                          color: Color(0xFFDF5B03),
                          child: Text(
                            "Nouveau client",
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
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: DataTable(
          columnSpacing: 43,
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
                  Container(child: Text("ID")),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          venteListCopy = venteList;
                          clienSearch = false;
                          idSearch = true;
                          etatSearch = false;
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
            ),
            DataColumn(
              label: Text("Nbr_Prod"),
            ),
            DataColumn(
              label: Row(
                children: [
                  Text("Nom Client"),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          venteListCopy = venteList;
                          clienSearch = true;
                          idSearch = false;
                          etatSearch = false;
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
            ),
            DataColumn(
              label: Text("Prix_total"),
            ),
            DataColumn(
              label: Row(
                children: [
                  Text("Date"),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          venteListCopy = venteList;
                          clienSearch = false;
                          idSearch = false;
                          etatSearch = false;
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
            ),
            DataColumn(
              label: Row(
                children: [
                  Text("Etat"),
                ],
              ),
            ),
            DataColumn(
              label: Text("Action"),
            ),
          ],
          rows: venteListCopy!
              .map(
                (e) => DataRow(cells: [
                  DataCell(
                    Text(e.idCom),
                  ),
                  DataCell(
                    Text(double.parse(e.nbrProd).toStringAsFixed(2)),
                  ),
                  DataCell(
                    Text(e.clientName),
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
                      e.is_print_com == '0'
                          ? 'Paiement...'
                          : e.is_deliver_com == '0'
                              ? 'Livraison...'
                              : 'Livrée',
                      style: TextStyle(
                          color: (e.is_print_com == '0')
                              ? (Color(0xCCCE7A0B))
                              : e.is_deliver_com == '0'
                                  ? Color(0xCC0B1EC7)
                                  : Color(0xCC0BC70B)),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.visibility,
                            color: Color(0xCCABAD18),
                          ),
                          onPressed: () {
                            selectVente = e;

                            setState(() {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return VenteCommande(
                                      selectCom: e,
                                    );
                                  }).then((value) {
                                setState(() {
                                  if (!isDeliver) {
                                    getVente(
                                        '0', seach.text, end.text, true, true);
                                  } else {
                                    getVente(
                                        '1', seach.text, end.text, true, true);
                                  }
                                });
                              });
                            });
                          },
                        ),
                        int.parse(e.is_print_com) == 0
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
                                          'Voulez-vous supprimer cette Vente?',
                                          'vente')
                                      .then((value) {
                                    if (value == "1") {
                                      setState(() {
                                        ConfirmBox()
                                            .showAlert(
                                                context,
                                                'Vente supprimée avec succès',
                                                true)
                                            .then((value) {
                                          if (!isDeliver) {
                                            getVente('0', seach.text, end.text,
                                                true, true);
                                          } else {
                                            getVente('1', seach.text, end.text,
                                                true, true);
                                          }
                                        });
                                      });
                                    }
                                  });
                                },
                              )
                            : Text(''),
                        SizedBox(
                          width: 5,
                        ),
                        int.parse(e.is_deliver_com) == 0
                            ? MaterialButton(
                                color: Colors.green,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return CreeFacture(
                                          selectCom: e,
                                        );
                                      }).then((value) {
                                    if (!isDeliver) {
                                      getVente('0', seach.text, end.text, true,
                                          true);
                                    } else {
                                      getVente('1', seach.text, end.text, true,
                                          true);
                                    }
                                  });
                                },
                                child: Text(
                                  'Imprimer',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Text(''),
                        SizedBox(
                          width: 7,
                        ),
                        int.parse(e.is_deliver_com) == 0 &&
                                int.parse(e.is_print_com) == 1
                            ? MaterialButton(
                                color: Colors.orange,
                                minWidth: 50,
                                onPressed: () {
                                  AlertBox()
                                      .showAlertDialod(
                                          context,
                                          int.parse(e.idCom),
                                          'La commande est-elle livrée?',
                                          'valideLivraison')
                                      .then((value) {
                                    setState(() {
                                      if (!isDeliver) {
                                        getVente('0', seach.text, end.text,
                                            true, true);
                                      } else {
                                        getVente('1', seach.text, end.text,
                                            true, true);
                                      }
                                    });
                                  });
                                },
                                child: Text(
                                  'Livré',
                                  style: TextStyle(
                                      color: Colors.white,
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
                                      child: AppBarCus(),
                                    ),
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
                                                70,
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
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    child: Row(
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
                                                            decoration:
                                                                InputDecoration(
                                                                    suffixIcon:
                                                                        MaterialButton(
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
                                                                                seach.text = "AND cl.nom_complet_client LIKE '%${seachInput.text}%'";
                                                                              });
                                                                            }
                                                                          } else {
                                                                            if (idSearch) {
                                                                              if (mounted) {
                                                                                setState(() {
                                                                                  seach.text = "AND rav.Id_com LIKE '%${seachInput.text}%'";
                                                                                });
                                                                              }
                                                                            } else {
                                                                              if (mounted) {
                                                                                setState(() {
                                                                                  seach.text = "AND rav.Date_com LIKE '%${seachInput.text}%'";
                                                                                });
                                                                              }
                                                                            }
                                                                          }
                                                                        }
                                                                        isDeliver
                                                                            ? getVente(
                                                                                '1',
                                                                                seach.text,
                                                                                end.text,
                                                                                true,
                                                                                true)
                                                                            : getVente('0', seach.text, end.text, true, true);
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
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    hintText: clienSearch
                                                                        ? "Rechercher par client..."
                                                                        : idSearch
                                                                            ? "Rechercher par numéro de vente..."
                                                                            : "Rechercher par date de création de la vente..."),
                                                            onChanged: (seach) {
                                                              setState(() {
                                                                if (clienSearch) {
                                                                  venteListCopy = venteList!
                                                                      .where((element) => (element
                                                                          .clientName
                                                                          .toLowerCase()
                                                                          .contains(
                                                                              seach.toLowerCase())))
                                                                      .toList();
                                                                } else {
                                                                  if (idSearch) {
                                                                    venteListCopy = venteList!
                                                                        .where((element) => (element
                                                                            .idCom
                                                                            .toLowerCase()
                                                                            .contains(seach.toLowerCase())))
                                                                        .toList();
                                                                  } else {
                                                                    venteListCopy = venteList!
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
                                                                  getVente(
                                                                      '0',
                                                                      seach
                                                                          .text,
                                                                      end.text,
                                                                      true,
                                                                      true);
                                                                } else {
                                                                  isDeliver =
                                                                      true;
                                                                  getVente(
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
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
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
                                                    child: is_empty
                                                        ? Center(
                                                            child: Text(
                                                              'Aucune donnée trouvée',
                                                              style: TextStyle(
                                                                  fontSize: 18,
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
                                                            child: Container(
                                                                child:
                                                                    _commandeBody),
                                                          ),
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
                                                                            _venteHorizontalDrawerBuilder,
                                                                        direction:
                                                                            AxisDirection
                                                                                .right)
                                                                    .then(
                                                                        (value) {
                                                                  getClientList();
                                                                  if (value
                                                                          .toString()
                                                                          .split(
                                                                              '=>')
                                                                          .length >
                                                                      1) {
                                                                    Services.creatVente(
                                                                            clientName!.text.split('=>')[
                                                                                0],
                                                                            user!
                                                                                .text)
                                                                        .then(
                                                                            (value) {
                                                                      if (int.parse(
                                                                              value) ==
                                                                          1) {
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            barrierDismissible:
                                                                                false,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return CreatVente(
                                                                                clientId: clientName!.text.split('=>')[0],
                                                                                clientName: clientName!.text.split('=>')[1],
                                                                              );
                                                                            }).then((value) {
                                                                          setState(
                                                                              () {
                                                                            getVente(
                                                                                '0',
                                                                                seach.text,
                                                                                end.text,
                                                                                true,
                                                                                true);
                                                                            isDeliver =
                                                                                false;
                                                                          });
                                                                        });
                                                                      } else if (int.parse(
                                                                              value) ==
                                                                          0) {
                                                                        ConfirmBox().showAlert(
                                                                            context,
                                                                            'Impossible de créer la vente',
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
                                                                "Nouvelle vente",
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
                                                                                        ? getVente('1', seach.text, end.text, false, false)
                                                                                        : getVente('0', seach.text, end.text, false, false);
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
                                                                                        ? getVente('1', seach.text, end.text, true, false)
                                                                                        : getVente('0', seach.text, end.text, true, false);
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
