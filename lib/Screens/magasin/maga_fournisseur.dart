// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/database/fournisseurModel.dart';
import 'package:application_principal/database/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MagaFournisseur extends StatefulWidget {
  const MagaFournisseur({Key? key}) : super(key: key);

  @override
  _MagaFournisseurState createState() => _MagaFournisseurState();
}

class _MagaFournisseurState extends State<MagaFournisseur> {
  List<FournisseurModel>? fouList;
  List<FournisseurModel>? copyFouList;
  FournisseurModel? fourni;
  bool nomSearch = false;
  bool statutSearch = false;
  bool villeSearch = false;
  bool agentSearch = true;
  final controller = ScrollController();

  @override
  void initState() {
    fouList = [];
    copyFouList = [];
    getFouList();
    super.initState();
  }

  getFouList() {
    Services.getFournisseur().then((value) {
      if (int.parse(value.map((e) => e.idFour).toList()[0]) == 0) {
        ConfirmBox().showAlert(context, 'Aucun fournisseur trouve', false);
        setState(() {
          fouList = [];
          copyFouList = [];
        });
      } else if (int.parse(value.map((e) => e.idFour).toList()[0]) > 0) {
        setState(() {
          fouList = value;
          copyFouList = value;
        });
      }
    });
  }

  SingleChildScrollView get _fournisseuBody {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: DataTable(
          columnSpacing: 25,
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
                  Text("Nom"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        copyFouList = fouList;
                        nomSearch = true;
                        statutSearch = false;
                        villeSearch = false;
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
                  Text("Statut"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        copyFouList = fouList;
                        nomSearch = false;
                        statutSearch = true;
                        villeSearch = false;
                        agentSearch = false;
                      });
                    },
                    icon: Icon(
                      Icons.filter_list_alt,
                      size: 20,
                      color: statutSearch ? Colors.green : Colors.black,
                    ),
                  )
                ],
              ),
            ),
            DataColumn(
              label: Text("Pays"),
            ),
            DataColumn(
              label: Row(
                children: [
                  Text("Ville"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        copyFouList = fouList;
                        nomSearch = false;
                        statutSearch = false;
                        villeSearch = true;
                        agentSearch = false;
                      });
                    },
                    icon: Icon(
                      Icons.filter_list_alt,
                      size: 20,
                      color: villeSearch ? Colors.green : Colors.black,
                    ),
                  )
                ],
              ),
            ),
            DataColumn(
              label: Text("Tel"),
            ),
            DataColumn(
              label: Text("Email"),
            ),
            DataColumn(
              label: Text("Date"),
            ),
            DataColumn(
              label: Row(
                children: [
                  Text("Agent"),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          copyFouList = fouList;
                          nomSearch = false;
                          statutSearch = false;
                          villeSearch = false;
                          agentSearch = true;
                        });
                      },
                      icon: Icon(
                        Icons.filter_list_alt,
                        size: 20,
                        color: agentSearch ? Colors.green : Colors.black,
                      ))
                ],
              ),
            ),
            DataColumn(
              label: Text("Actions"),
            ),
          ],
          rows: copyFouList!
              .map(
                (e) => DataRow(cells: [
                  DataCell(
                    Text(e.idFour),
                  ),
                  DataCell(
                    Text(e.nomFour),
                  ),
                  DataCell(
                    Text(e.typeFour),
                  ),
                  DataCell(
                    Text(e.paysFour),
                  ),
                  DataCell(
                    Text(e.villeFour),
                  ),
                  DataCell(
                    Text(
                      e.telFour,
                    ),
                  ),
                  DataCell(
                    Text(
                      e.emailFour,
                    ),
                  ),
                  DataCell(
                    Text(
                      e.dateFour,
                    ),
                  ),
                  DataCell(
                    Text(
                      e.userFour,
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
                            fourni = e;

                            setState(() {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return ManageFourAlert(
                                      selectFour: fourni!,
                                    );
                                  }).then((value) {
                                setState(() {
                                  getFouList();
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
                            fourni = e;
                            String content =
                                "Voulez-vous réellement supprimer cet fournisseur?";
                            AlertBox()
                                .showAlertDialod(
                                    context,
                                    int.parse(fourni!.idFour),
                                    content,
                                    'fournisseur')
                                .then((value) {
                              if (int.parse(value) == 1) {
                                setState(() {
                                  getFouList();
                                  ConfirmBox().showAlert(
                                      context,
                                      "Le Fournisseur a été supprimé avec succès",
                                      true);
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
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  margin: EdgeInsets.only(
                                    left: 7,
                                    top: 8,
                                  ),
                                  padding: EdgeInsets.only(right: 10, top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      nomSearch
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 10, left: 5),
                                              width: 400,
                                              child: TextField(
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText:
                                                        "Rechercher par fournisseur..."),
                                                onChanged: (seach) {
                                                  setState(() {
                                                    copyFouList = fouList!
                                                        .where((element) => (element
                                                            .nomFour
                                                            .toLowerCase()
                                                            .contains(seach
                                                                .toLowerCase())))
                                                        .toList();
                                                  });
                                                },
                                              ),
                                            )
                                          : statutSearch
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10, left: 5),
                                                  width: 400,
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        hintText:
                                                            "Rechercher par statut..."),
                                                    onChanged: (seach) {
                                                      setState(() {
                                                        copyFouList = fouList!
                                                            .where((element) => (element
                                                                .typeFour
                                                                .toLowerCase()
                                                                .contains(seach
                                                                    .toLowerCase())))
                                                            .toList();
                                                      });
                                                    },
                                                  ),
                                                )
                                              : villeSearch
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 10, left: 5),
                                                      width: 400,
                                                      child: TextField(
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            hintText:
                                                                "Rechercher par ville..."),
                                                        onChanged: (seach) {
                                                          setState(() {
                                                            copyFouList = fouList!
                                                                .where((element) => (element
                                                                    .villeFour
                                                                    .toLowerCase()
                                                                    .contains(seach
                                                                        .toLowerCase())))
                                                                .toList();
                                                          });
                                                        },
                                                      ),
                                                    )
                                                  : Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 10, left: 5),
                                                      width: 400,
                                                      child: TextField(
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            hintText:
                                                                "Rechercher par agent..."),
                                                        onChanged: (seach) {
                                                          setState(() {
                                                            copyFouList = fouList!
                                                                .where((element) => (element
                                                                    .userFour
                                                                    .toLowerCase()
                                                                    .contains(seach
                                                                        .toLowerCase())))
                                                                .toList();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 5, bottom: 5),
                                        height:
                                            MediaQuery.of(context).size.height -
                                                207,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                265,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1, color: Colors.black)),
                                        child: ImprovedScrolling(
                                            enableCustomMouseWheelScrolling:
                                                true,
                                            enableKeyboardScrolling: true,
                                            enableMMBScrolling: true,
                                            mmbScrollConfig: MMBScrollConfig(
                                              customScrollCursor:
                                                  DefaultCustomScrollCursor(
                                                backgroundColor: Colors.white,
                                                cursorColor: Color(0xFF26345d),
                                              ),
                                            ),
                                            customMouseWheelScrollConfig:
                                                CustomMouseWheelScrollConfig(
                                                    scrollAmountMultiplier:
                                                        4.0),
                                            scrollController: controller,
                                            child: _fournisseuBody),
                                      ),
                                      Container(
                                        height: 55,
                                        width: 200,
                                        color: Colors.red,
                                        child: MaterialButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return AddFourAlert();
                                                }).then((value) {
                                              setState(() {
                                                getFouList();
                                              });
                                            });
                                          },
                                          color: Color(0xFF26345d),
                                          child: Text(
                                            "Ajouter un fornisseur",
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
