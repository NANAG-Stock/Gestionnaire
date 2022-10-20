// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/database/produit_use_model.dart';
import 'package:application_principal/database/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProduitsUse extends StatefulWidget {
  const ProduitsUse({Key? key}) : super(key: key);

  @override
  _ProduitsUseState createState() => _ProduitsUseState();
}

class _ProduitsUseState extends State<ProduitsUse> {
  List<ProduitUseModel>? produit_use_List;
  List<ProduitUseModel>? copy_produit_use_List;
  ProduitUseModel? produit_use;
  bool nomSearch = true;
  bool catSearch = false;
  bool dateSearch = false;
  bool agentSearch = false;
  final controller = ScrollController();

  @override
  void initState() {
    produit_use_List = [];
    copy_produit_use_List = [];
    getProduitsUse();
    super.initState();
  }

  getProduitsUse() {
    Services.getProdutsUse().then((value) {
      if (int.parse(value.map((e) => e.id).toList()[0]) <= 0) {
        if (int.parse(value.map((e) => e.id).toList()[0]) == 0) {
          ConfirmBox().showAlert(context, 'Aucun produit trouvé', false);
        } else {
          ConfirmBox().showAlert(context, 'Erreur de connexion', false);
        }

        setState(() {
          produit_use_List = [];
          copy_produit_use_List = [];
        });
      } else {
        setState(() {
          produit_use_List = value;
          copy_produit_use_List = value;
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
              label: Row(
                children: [
                  Text("Désignation"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        copy_produit_use_List = produit_use_List;
                        nomSearch = true;
                        catSearch = false;
                        dateSearch = false;
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
                  Text("Catégorie"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        copy_produit_use_List = produit_use_List;
                        nomSearch = false;
                        catSearch = true;
                        dateSearch = false;
                        agentSearch = false;
                      });
                    },
                    icon: Icon(
                      Icons.filter_list_alt,
                      size: 20,
                      color: catSearch ? Colors.green : Colors.black,
                    ),
                  )
                ],
              ),
            ),
            DataColumn(
              label: Container(child: Text(" Prix")),
            ),
            DataColumn(
              label: Container(child: Text(" Quantitée")),
            ),
            DataColumn(
              label: Row(
                children: [
                  Text("Date"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        copy_produit_use_List = produit_use_List;
                        nomSearch = false;
                        catSearch = false;
                        dateSearch = true;
                        agentSearch = false;
                      });
                    },
                    icon: Icon(
                      Icons.filter_list_alt,
                      size: 20,
                      color: dateSearch ? Colors.green : Colors.black,
                    ),
                  )
                ],
              ),
            ),
            DataColumn(
              label: Row(
                children: [
                  Text("Agent"),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          copy_produit_use_List = produit_use_List;
                          nomSearch = false;
                          catSearch = false;
                          dateSearch = false;
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
              label: Text("Description"),
            ),
            DataColumn(
              label: Text("Actions"),
            ),
          ],
          rows: copy_produit_use_List!
              .map(
                (e) => DataRow(cells: [
                  DataCell(
                    Text(e.designation),
                  ),
                  DataCell(
                    Text(e.categorie),
                  ),
                  DataCell(
                    Text("${e.prix} Fcfa"),
                  ),
                  DataCell(
                    Text(e.qts),
                  ),
                  DataCell(
                    Text(e.date),
                  ),
                  DataCell(
                    Text(e.agent),
                  ),
                  DataCell(
                    Text(e.desc),
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
                            produit_use = e;

                            setState(() {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AddProduitUse(
                                      produit_use: produit_use!,
                                      is_add: false,
                                    );
                                  }).then((value) {
                                setState(() {
                                  getProduitsUse();
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
                            produit_use = e;
                            String content =
                                "Voulez-vous réellement supprimer cet élément?";
                            AlertBox()
                                .showAlertDialod(
                                    context,
                                    int.parse(produit_use!.id),
                                    content,
                                    'delProduitUse')
                                .then((value) {
                              if (int.parse(value) == 1) {
                                Services.deleteProduitUse(produit_use!.id)
                                    .then((value) {
                                  if (int.parse(value) <= 0) {
                                    if (int.parse(value) == 0) {
                                      ConfirmBox().showAlert(
                                          context, "Opération echouée", true);
                                    } else {
                                      ConfirmBox().showAlert(
                                          context, "Erreur de connexion", true);
                                    }
                                  } else {
                                    ConfirmBox().showAlert(
                                        context, "Opération réussie!!", true);
                                  }
                                });
                              }
                              setState(() {
                                getProduitsUse();
                              });
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
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  margin: EdgeInsets.only(
                                    left: state.isClosed! ? 0 : 7,
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
                                                        "Rechercher par designation..."),
                                                onChanged: (seach) {
                                                  setState(() {
                                                    copy_produit_use_List =
                                                        produit_use_List!
                                                            .where(
                                                              (element) => (element
                                                                  .designation
                                                                  .toLowerCase()
                                                                  .contains(
                                                                    seach
                                                                        .toLowerCase(),
                                                                  )),
                                                            )
                                                            .toList();
                                                  });
                                                },
                                              ),
                                            )
                                          : catSearch
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10, left: 5),
                                                  width: 400,
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        hintText:
                                                            "Rechercher par categorie..."),
                                                    onChanged: (seach) {
                                                      setState(() {
                                                        copy_produit_use_List =
                                                            produit_use_List!
                                                                .where((element) => (element
                                                                    .categorie
                                                                    .toLowerCase()
                                                                    .contains(seach
                                                                        .toLowerCase())))
                                                                .toList();
                                                      });
                                                    },
                                                  ),
                                                )
                                              : dateSearch
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
                                                                "Rechercher par date..."),
                                                        onChanged: (seach) {
                                                          setState(() {
                                                            copy_produit_use_List =
                                                                produit_use_List!
                                                                    .where((element) => (element
                                                                        .date
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            seach.toLowerCase())))
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
                                                            copy_produit_use_List =
                                                                produit_use_List!
                                                                    .where((element) => (element
                                                                        .agent
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            seach.toLowerCase())))
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
                                                  return AddProduitUse(
                                                    is_add: true,
                                                  );
                                                }).then((value) {
                                              setState(() {
                                                getProduitsUse();
                                              });
                                            });
                                          },
                                          color: Color(0xFF26345d),
                                          child: Text(
                                            "Ajouter",
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
