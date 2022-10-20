// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/database/clientModel.dart';
import 'package:application_principal/database/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Secret1Client extends StatefulWidget {
  const Secret1Client({Key? key}) : super(key: key);

  @override
  _Secret1ClientState createState() => _Secret1ClientState();
}

class _Secret1ClientState extends State<Secret1Client> {
  List<ClientModel>? clienList;
  List<ClientModel>? copyclienList;
  ClientModel? client;
  bool nomSearch = false;
  bool typeSearch = false;
  bool agentSearch = true;
  bool is_loading = true;
  bool is_empty = false;
  final controller = ScrollController();

  TextEditingController end = TextEditingController();
  TextEditingController seach = TextEditingController();
  TextEditingController seachInput = TextEditingController();
  bool endPred = false;
  bool endSuiv = false;

  @override
  void initState() {
    clienList = [];
    copyclienList = [];
    end.text = "0";
    seach.text = '';
    getClientList(seach.text, end.text, true, true);
    super.initState();
  }

  getClientList(String seach, String ends, bool isfront, bool same) {
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

    Services.getClientsLimit(limit, seach).then((value) {
      setState(() {
        is_loading = false;
      });
      if (int.parse(value.map((e) => e.id_client).toList()[0]) == 0) {
        // ConfirmBox().showAlert(context, 'Aucun client trouvé', false);
        setState(() {
          is_empty = true;
          clienList = [];
          copyclienList = [];
        });
      } else if (int.parse(value.map((e) => e.id_client).toList()[0]) > 0) {
        setState(() {
          clienList = value;
          copyclienList = value;
          value.length < 12 ? endSuiv = true : endSuiv = false;
        });
      } else if (int.parse(value.map((e) => e.id_client).toList()[0]) < 0) {
        setState(() {
          is_empty = true;
        });
        ConfirmBox().showAlert(context, 'Erreur de connexion', false);
      }
    });
  }

  SingleChildScrollView get _clientBody {
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
          // ignore: prefer_const_literals_to_create_immutables
          columns: [
            DataColumn(
              label: Container(child: Text("ID")),
            ),
            DataColumn(
              label: Row(
                children: [
                  Text("NOM COMPLET"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        copyclienList = clienList;
                        nomSearch = true;
                        typeSearch = false;
                        agentSearch = false;
                      });
                    },
                    icon: Icon(
                      Icons.filter_list_alt,
                      size: 20,
                      color: nomSearch ? Colors.green : Colors.black,
                    ),
                  )
                ],
              ),
            ),
            DataColumn(
              label: Row(
                children: [
                  Text("TYPE"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        copyclienList = clienList;
                        nomSearch = false;
                        typeSearch = true;
                        agentSearch = false;
                      });
                    },
                    icon: Icon(
                      Icons.filter_list_alt,
                      size: 20,
                      color: typeSearch ? Colors.green : Colors.black,
                    ),
                  )
                ],
              ),
            ),
            DataColumn(
              label: Text("CNIB"),
            ),
            DataColumn(
              label: Text("TELEPHONE"),
            ),
            DataColumn(
              label: Text("DATE"),
            ),
            DataColumn(
              label: Row(
                children: [
                  Text("AGENT"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        copyclienList = clienList;
                        nomSearch = false;
                        typeSearch = false;
                        agentSearch = true;
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
              label: Text("ACTIONS"),
            ),
          ],
          rows: copyclienList!
              .map(
                (e) => DataRow(cells: [
                  DataCell(
                    Text(e.id_client),
                  ),
                  DataCell(
                    Text(e.nom_complet_client),
                  ),
                  DataCell(
                    Text(e.type_client),
                  ),
                  DataCell(
                    Text(e.cnib_client),
                  ),
                  DataCell(
                    Text(
                      e.tel_client,
                    ),
                  ),
                  DataCell(
                    Text(
                      e.date_client,
                    ),
                  ),
                  DataCell(
                    Text(
                      e.user_client,
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.manage_accounts,
                            color: Color(0xCC0AC529),
                          ),
                          onPressed: () {
                            client = e;
                            setState(() {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return ManageClientAlert(
                                      selectedClient: client!,
                                    );
                                  }).then((value) {
                                setState(() {
                                  getClientList(
                                      seach.text, end.text, true, true);
                                });
                              });
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            client = e;
                            String content =
                                "Voulez-vous reellement supprimer cet Client?";
                            AlertBox()
                                .showAlertDialod(
                                    context,
                                    int.parse(client!.id_client),
                                    content,
                                    'client')
                                .then((value) {
                              if (int.parse(value) == 1) {
                                setState(() {
                                  ConfirmBox().showAlert(context,
                                      "Client supprimé avec success", true);
                                  getClientList(
                                      seach.text, end.text, true, true);
                                });
                              }
                            });
                          },
                        ),
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
                                controller: ScrollController(),
                                child: Container(
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 7, top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      is_loading
                                          ? Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  130,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()))
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10, left: 5),
                                                  width: 400,
                                                  child: TextField(
                                                    controller: seachInput,
                                                    decoration: InputDecoration(
                                                        suffixIcon:
                                                            MaterialButton(
                                                          color:
                                                              Color(0xFF26345d),
                                                          height: 55,
                                                          onPressed: () {
                                                            if (seachInput
                                                                .text.isEmpty) {
                                                              if (mounted) {
                                                                setState(() {
                                                                  seach.text =
                                                                      "";
                                                                });
                                                              }
                                                            } else {
                                                              end.text = '0';
                                                              if (nomSearch) {
                                                                if (mounted) {
                                                                  setState(() {
                                                                    seach.text =
                                                                        "AND cl.nom_complet_client LIKE '%${seachInput.text}%'";
                                                                  });
                                                                }
                                                              } else {
                                                                if (typeSearch) {
                                                                  if (mounted) {
                                                                    setState(
                                                                        () {
                                                                      seach.text = "AND cl.type_client LIKE '%${seachInput
                                                                              .text}%'";
                                                                    });
                                                                  }
                                                                } else {
                                                                  if (mounted) {
                                                                    setState(
                                                                        () {
                                                                      seach.text = "AND us.Nom LIKE '%${seachInput
                                                                              .text}%'";
                                                                    });
                                                                  }
                                                                }
                                                              }
                                                            }
                                                            getClientList(
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
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        hintText: nomSearch
                                                            ? "Rechercher par nom..."
                                                            : typeSearch
                                                                ? "Rechercher par type de client..."
                                                                : "Rechercher par agent..."),
                                                    onChanged: (seach) {
                                                      setState(() {
                                                        if (nomSearch) {
                                                          copyclienList =
                                                              clienList!
                                                                  .where(
                                                                    (element) => (element
                                                                        .nom_complet_client
                                                                        .toLowerCase()
                                                                        .contains(
                                                                          seach
                                                                              .toLowerCase(),
                                                                        )),
                                                                  )
                                                                  .toList();
                                                        } else {
                                                          if (typeSearch) {
                                                            copyclienList =
                                                                clienList!
                                                                    .where(
                                                                      (element) => (element
                                                                          .type_client
                                                                          .toLowerCase()
                                                                          .contains(
                                                                              seach.toLowerCase())),
                                                                    )
                                                                    .toList();
                                                          } else {
                                                            copyclienList = clienList!
                                                                .where((element) => (element
                                                                    .user_client
                                                                    .toLowerCase()
                                                                    .contains(seach
                                                                        .toLowerCase())))
                                                                .toList();
                                                          }
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5, bottom: 3),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.black)),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      195,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      270,
                                                  child: is_empty
                                                      ? Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height -
                                                              130,
                                                          child: Center(
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
                                                          child: _clientBody,
                                                        ),
                                                ),
                                              ],
                                            ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 55,
                                            color: Colors.red,
                                            child: MaterialButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AddClientAlert();
                                                    }).then((value) {
                                                  setState(() {
                                                    getClientList(seach.text,
                                                        end.text, true, true);
                                                  });
                                                });
                                              },
                                              color: Color(0xFF26345d),
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
                                          Container(
                                            width: 300,
                                            child: BootstrapContainer(
                                                fluid: true,
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                children: [
                                                  BootstrapRow(children: [
                                                    BootstrapCol(
                                                        sizes: 'col-12',
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            MaterialButton(
                                                              height: 40,
                                                              color: endPred
                                                                  ? Colors.grey
                                                                  : Colors.red,
                                                              onPressed: () {
                                                                endPred
                                                                    ? null
                                                                    : getClientList(
                                                                        seach
                                                                            .text,
                                                                        end.text,
                                                                        false,
                                                                        false);
                                                              },
                                                              child: Text(
                                                                  "Précédent",
                                                                  style: TextStyle(
                                                                      color: endPred
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .white)),
                                                            ),
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            MaterialButton(
                                                              height: 40,
                                                              color: endSuiv
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .green,
                                                              onPressed: () {
                                                                endSuiv
                                                                    ? null
                                                                    : getClientList(
                                                                        seach
                                                                            .text,
                                                                        end.text,
                                                                        true,
                                                                        false);
                                                              },
                                                              child: Text(
                                                                "Suivant",
                                                                style: TextStyle(
                                                                    color: endSuiv
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .white),
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
