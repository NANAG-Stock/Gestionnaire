// gestion des achat chez fournisseur
// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/function.dart';
import 'package:application_principal/Blocks/text_input.dart';
import 'package:application_principal/Screens/excel.dart';
import 'package:application_principal/database/CommandeModel.dart';
import 'package:application_principal/database/categorieModel.dart';
import 'package:application_principal/database/comInfos.dart';
import 'package:application_principal/database/commande_details_model.dart';
import 'package:application_principal/database/credit_model.dart';
import 'package:application_principal/database/depense_model.dart';
import 'package:application_principal/database/fourPay.dart';
import 'package:application_principal/database/list_pay_com_num.dart';
import 'package:application_principal/database/payment_liste_model.dart';
import 'package:application_principal/database/product.dart';
import 'package:application_principal/database/retrait_model.dart';
import 'package:application_principal/database/salaireModel.dart';
import 'package:application_principal/database/services.dart';
import 'package:application_principal/database/virement_model.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CreatCommande extends StatefulWidget {
  final String fourId;
  final String forName;
  const CreatCommande({
    Key? key,
    required this.fourId,
    required this.forName,
  }) : super(key: key);

  @override
  State<CreatCommande> createState() => _CreatCommandeState();
}

class _CreatCommandeState extends State<CreatCommande> {
  List<Product>? productList;
  List<Product>? filterProdList;
  List<CommandInfos>? infoCom;
  Product? prod;
  final controle = ScrollController();
  final controle1 = ScrollController();
  List<ContenuCom> comList = [];
  List<String> listType = ['Particulier', 'Societe'];
  TextEditingController nbr = TextEditingController();
  bool isloading = true;

  TextEditingController end = TextEditingController();
  TextEditingController seach = TextEditingController();
  TextEditingController seachInput = TextEditingController();
  bool endPred = false;
  bool endSuiv = false;

  @override
  void initState() {
    super.initState();
    nbr = TextEditingController();
    comList = [];
    productList = [];
    filterProdList = [];
    infoCom = [];
    seach.text = '';
    end.text = "0";
    getProdList(end.text, seach.text, true, true);
  }

// Liste des produits
  void getProdList(String ends, String cherche, bool isfront, bool same) {
    endPred = false;
    if (same) {
      end.text = ends;
    } else {
      if (isfront) {
        endSuiv
            ? end.text = end.text
            : end.text = (int.parse(end.text) + 12).toString();
      } else {
        if ((int.parse(ends) - 12) > 0) {
          end.text = (int.parse(end.text) - 12).toString();
        } else {
          endPred = true;
          end.text = '0';
        }
      }
    }

    String limit = "LIMIT ${end.text},12";

    Services.getProdList2(limit, cherche).then((value) {
      setState(() {
        productList = [];
        filterProdList = [];
      });
      if (int.parse(value.map((e) => e.id_prod).toList()[0]) == -1 ||
          int.parse(value.map((e) => e.id_prod).toList()[0]) == -2) {
        setState(() {
          productList = [];
          filterProdList = [];
        });
        ConfirmBox().showAlert(context, "Erreur de connexion", false);
      } else {
        if (int.parse(value.map((e) => e.id_prod).toList()[0]) == -3) {
          setState(() {
            productList = [];
            filterProdList = [];
          });
        } else {
          setState(() {
            productList = value;
            filterProdList = value;

            value.length < 12 ? endSuiv = true : endSuiv = false;
          });
        }
      }
    }).then((value) => setState(() {
          getComInfos();
        }));
  }

  void getComInfos() {
    Services.getComInfos(widget.fourId).then((value) {
      if (int.parse(value.map((e) => e.comId).toList()[0]) > 0) {
        setState(() {
          infoCom = value;
          isloading = false;
        });
      }
    });
  }

  int getProdQts(String key) {
    int qts = 0;
    int prix = 0;
    for (int i = 0; i < comList.length; i++) {
      qts += int.parse(comList[i].qtsProd);
      prix +=
          (int.parse(comList[i].prixUnit) * (int.parse(comList[i].qtsProd)));
    }
    return key == 'prix' ? prix : qts;
  }

  int checkExitProduc(List<ContenuCom> list, String id) {
    int tem = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].idProd == id) {
        tem = 1;
        break;
      }
    }
    return tem;
  }

  SingleChildScrollView get _fournisseuMove {
    return SingleChildScrollView(
      controller: controle1,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: DataTable(
            columnSpacing: 40,
            headingTextStyle: TextStyle(
              color: Color(0xFF26345d),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            horizontalMargin: 30,
            columns: const [
              DataColumn(
                label: Text("ID"),
              ),
              DataColumn(
                label: Text("Désignation"),
              ),
              DataColumn(
                label: Text("Quantitée"),
              ),
              DataColumn(
                label: Text("Prix_Unit"),
              ),
              DataColumn(
                label: Text("Prix_Total"),
              ),
              DataColumn(
                label: Text("Action"),
              ),
            ],
            rows: comList
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.idProd)),
                      DataCell(Text(e.designation)),
                      DataCell(Text(e.qtsProd)),
                      DataCell(Text('${e.prixUnit} Fcfa')),
                      DataCell(Text(
                          '${int.parse(e.prixUnit) * int.parse(e.qtsProd)} Fcfa')),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit_location_alt,
                              color: Color(0xFFEEBB12),
                              size: 20,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Align(
                                      alignment: Alignment(1, 0),
                                      child: SetComElem(
                                        nameProd: e.designation,
                                        qtPrix: '${e.qtsProd}-${e.prixUnit}',
                                      ),
                                    );
                                  }).then((value) {
                                String qte = value.toString().split('-')[0];
                                String pri = value.toString().split('-')[1];
                                setState(() {
                                  for (int i = 0; i < comList.length; i++) {
                                    if (comList[i].idProd == e.idProd &&
                                        comList[i].idRav == e.idRav) {
                                      comList[i].prixUnit = pri;
                                      comList[i].qtsProd = qte;
                                      break;
                                    }
                                  }
                                });
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () {
                              AlertBox()
                                  .showAlertDialod(
                                      context,
                                      1,
                                      'Voulez-vous supprimer cet produits?',
                                      'custome')
                                  .then((value) {
                                if (value == "1") {
                                  setState(() {
                                    comList.remove(e);
                                  });
                                }
                              });
                            },
                          ),
                        ],
                      ))
                    ],
                  ),
                )
                .toList()),
      ),
    );
  }

  // Table des produits
  SingleChildScrollView get _comProdTable {
    return SingleChildScrollView(
      controller: controle,
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
          columns: const [
            DataColumn(
              label: Text("ID"),
            ),
            DataColumn(
              label: Text("Désignation"),
            ),
            DataColumn(
              label: Text("Catégorie"),
            ),
            DataColumn(
              label: Text("Stock"),
            ),
            DataColumn(
              label: Text("Action"),
            ),
          ],
          rows: filterProdList!
              .map((e) => DataRow(cells: [
                    DataCell(Text(e.id_prod)),
                    DataCell(Text(e.designation)),
                    DataCell(Text(e.id_cat)),
                    DataCell(
                      Text(
                        double.parse(e.stock).toString(),
                        style: TextStyle(
                            color: double.parse(e.stock.toString()) == 0
                                ? Colors.red
                                : Colors.green),
                      ),
                    ),
                    DataCell(
                      TextButton(
                        onPressed: () {
                          prod = e;

                          if (checkExitProduc(comList, e.id_prod) == 1) {
                            ConfirmBox().showAlert(context,
                                "Cet produit est déjà selectionné.", false);
                          } else {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Align(
                                    alignment: Alignment(1, 0),
                                    child: SetComElem(
                                      nameProd: e.designation,
                                      qtPrix: '',
                                    ),
                                  );
                                }).then((value) {
                              String qte = value.toString().split('-')[0];
                              String pri = value.toString().split('-')[1];
                              setState(() {
                                int temoin = 0;
                                for (int i = 0; i < comList.length; i++) {
                                  if (comList[i].idProd == e.id_prod &&
                                      comList[i].idRav ==
                                          infoCom!
                                              .map((e) => e.comId)
                                              .toList()[0]) {
                                    comList[i].prixUnit = pri;
                                    comList[i].qtsProd =
                                        (int.parse(comList[i].qtsProd) +
                                                int.parse(qte))
                                            .toString();
                                    temoin = 1;
                                    break;
                                  }
                                }
                                if (temoin == 0) {
                                  comList.add(ContenuCom(
                                      idProd: e.id_prod,
                                      idFour: widget.fourId,
                                      qtsProd: qte,
                                      prixUnit: pri,
                                      designation: e.designation,
                                      idRav: infoCom!
                                          .map((e) => e.comId)
                                          .toList()[0],
                                      qtsTotal: e.stock.toString(),
                                      prixPromo: e.promo));
                                }
                              });
                            });
                          }
                        },
                        child: Text(
                          'Ajouter',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ]))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: isloading
            ? Center(
                child: Container(
                  padding: EdgeInsets.all(0),
                  child: CircularProgressIndicator(
                    color: Color(0xFF26345d),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    color: Color(0xFF26345d),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                "Remplissage du contenu de la commande",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close),
                              alignment: Alignment.bottomRight,
                              iconSize: 25,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(0),
                    height: MediaQuery.of(context).size.height - 70,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              height: 700,
                              margin: EdgeInsets.only(left: 10),
                              child: ListView(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 2, right: 2, top: 5),
                                        margin: EdgeInsets.only(
                                            bottom: 15, top: 20),
                                        child: Text(
                                            'Commande(${infoCom!.map((e) => e.comId).toList()[0]})/${infoCom!.map((e) => e.dateCom).toList()[0]}',
                                            style: TextStyle(
                                              fontSize: 25,
                                            )),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 2, right: 2, top: 5),
                                        margin: EdgeInsets.only(bottom: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text('Fournisseur: ',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                  infoCom!
                                                      .map((e) => e.fourName)
                                                      .toList()[0]
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Date: ',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                  infoCom!
                                                      .map((e) => e.dateCom)
                                                      .toList()[0]
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.black),
                                        ),
                                        height: 400,
                                        padding: EdgeInsets.only(
                                            left: 2, right: 2, top: 5),
                                        child: ImprovedScrolling(
                                          enableCustomMouseWheelScrolling: true,
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
                                                  scrollAmountMultiplier: 4.0),
                                          scrollController: controle1,
                                          child: _fournisseuMove,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: comList.isEmpty
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          comList.isNotEmpty
                                              ? Container(
                                                  padding: EdgeInsets.all(0),
                                                  height: 40,
                                                  width: 100,
                                                  child: MaterialButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Align(
                                                                  alignment:
                                                                      Alignment(
                                                                          1, 0),
                                                                  child:
                                                                      PayCommande(
                                                                    qtPrix: getProdQts(
                                                                            'prix')
                                                                        .toString(),
                                                                  ));
                                                            }).then((value) {
                                                          if (value
                                                                  .toString()
                                                                  .split('-')
                                                                  .length >
                                                              1) {
                                                            int cpt = 0;
                                                            for (int i = 0;
                                                                i <
                                                                    comList
                                                                        .length;
                                                                i++) {
                                                              Services.sendComList(
                                                                      comList[i]
                                                                          .idProd
                                                                          .toString(),
                                                                      comList[i]
                                                                          .idFour
                                                                          .toString(),
                                                                      comList[i]
                                                                          .qtsProd
                                                                          .toString(),
                                                                      comList[i]
                                                                          .prixUnit
                                                                          .toString(),
                                                                      comList[i]
                                                                          .idRav
                                                                          .toString())
                                                                  .then(
                                                                      (value) {
                                                                return value;
                                                              }).then((value) {
                                                                if (int.parse(
                                                                        value) ==
                                                                    1) {
                                                                  setState(() {
                                                                    cpt += 1;
                                                                    nbr.text = cpt
                                                                        .toString();
                                                                  });
                                                                }
                                                              });
                                                            }
                                                            Services.sendPaiement(
                                                                    value.toString().split(
                                                                        '-')[0],
                                                                    getProdQts(
                                                                            'prix')
                                                                        .toString(),
                                                                    value.toString().split(
                                                                        '-')[1],
                                                                    comList
                                                                        .map((e) =>
                                                                            e.idRav)
                                                                        .toList()[0])
                                                                .then((value) {
                                                              ConfirmBox()
                                                                  .showAlert(
                                                                      context,
                                                                      'La commande a été validée avec succes',
                                                                      true)
                                                                  .then(
                                                                      (value) {
                                                                if (int.parse(
                                                                        value) ==
                                                                    1) {
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              });
                                                            });
                                                          }
                                                        });
                                                      },
                                                      color: Color(0xFF048A0F),
                                                      child: Text(
                                                        "Terminer",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                Colors.white),
                                                      )),
                                                )
                                              : Text(''),
                                          Container(
                                            margin: EdgeInsets.only(top: 15),
                                            padding: EdgeInsets.all(7),
                                            width: 250,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1.5),
                                            ),
                                            child: Column(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    'Resumé',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Nom_Four: ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      infoCom!
                                                          .map(
                                                              (e) => e.fourName)
                                                          .toList()[0]
                                                          .toString(),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Quantité: ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(comList.isEmpty
                                                        ? '0'
                                                        : getProdQts('qts')
                                                            .toString()),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Prix Total: ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(comList.isEmpty
                                                        ? ' 0 '
                                                        : '${getProdQts('prix')} Fcfa'),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 5,
                              child: Container(
                                margin: EdgeInsets.only(left: 30, right: 3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Center(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 2, right: 2, top: 5),
                                        margin: EdgeInsets.only(
                                          bottom: 15,
                                          top: 20,
                                        ),
                                        child: Text('Liste des produits',
                                            style: TextStyle(
                                              fontSize: 25,
                                            )),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(bottom: 10, left: 5),
                                      width: 400,
                                      child: TextField(
                                        controller: seachInput,
                                        decoration: InputDecoration(
                                            suffixIcon: MaterialButton(
                                              color: Color(0xFF26345d),
                                              height: 55,
                                              onPressed: () {
                                                if (seachInput.text.isEmpty) {
                                                  if (mounted) {
                                                    setState(() {
                                                      seach.text = "";
                                                    });
                                                  }
                                                } else {
                                                  end.text = '0';

                                                  seach.text =
                                                      "AND pro.Nom_pro LIKE '%${seachInput.text}%'";
                                                }
                                                getProdList(end.text,
                                                    seach.text, true, true);
                                              },
                                              child: Text(
                                                'OK',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.all(10),
                                            hintText: "Rechercher..."),
                                        onChanged: (seach) {
                                          setState(() {
                                            filterProdList = productList!
                                                .where((element) => (element
                                                        .designation
                                                        .toLowerCase()
                                                        .contains(seach
                                                            .toLowerCase()) ||
                                                    element.id_cat
                                                        .toLowerCase()
                                                        .contains(seach
                                                            .toLowerCase())))
                                                .toList();
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.black)),
                                      height: 520,
                                      child: ImprovedScrolling(
                                        enableCustomMouseWheelScrolling: true,
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
                                                scrollAmountMultiplier: 4.0),
                                        scrollController: controle,
                                        child: _comProdTable,
                                      ),
                                    ),
                                    BootstrapContainer(
                                        fluid: true,
                                        padding: EdgeInsets.only(top: 20),
                                        children: [
                                          BootstrapRow(children: [
                                            BootstrapCol(
                                                sizes: 'col-12',
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    MaterialButton(
                                                      height: 40,
                                                      color: endPred
                                                          ? Colors.grey
                                                          : Colors.red,
                                                      onPressed: () {
                                                        endPred
                                                            ? null
                                                            : getProdList(
                                                                end.text,
                                                                seach.text,
                                                                false,
                                                                false);
                                                      },
                                                      child: Text("Précédent",
                                                          style: TextStyle(
                                                              color: endPred
                                                                  ? Colors.black
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
                                                          : Colors.green,
                                                      onPressed: () {
                                                        endSuiv
                                                            ? null
                                                            : getProdList(
                                                                end.text,
                                                                seach.text,
                                                                true,
                                                                false);
                                                      },
                                                      child: Text(
                                                        "Suivant",
                                                        style: TextStyle(
                                                            color: endSuiv
                                                                ? Colors.black
                                                                : Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                          ])
                                        ])
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
// fin creation de commande

// Voir la commande
class SeeCommande extends StatefulWidget {
  final CommandeModel selectCom;
  const SeeCommande({
    Key? key,
    required this.selectCom,
  }) : super(key: key);

  @override
  State<SeeCommande> createState() => _SeeCommandeState();
}

class _SeeCommandeState extends State<SeeCommande> {
  List<ContenuCom> comList = [];
  List<FourPay>? fourPay;
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    comList = [];
    fourPay = [];
    isloading = true;
    getCommandeCnt();
  }

// recuperation du contenu de la commande
  void getCommandeCnt() {
    Services.getCommandeContent(widget.selectCom.idCom).then((value) {
      if (int.parse(value.map((e) => e.idRav).toList()[0]) == 0) {
        ConfirmBox().showAlert(context, "Aucun contenu trouvé", false);
        setState(() {
          comList = [];
          isloading = false;
        });
      } else if (int.parse(value.map((e) => e.idRav).toList()[0]) < 0) {
        setState(() {
          comList = [];
        });
        ConfirmBox().showAlert(context, "Erreur de connexion", false);
      } else {
        setState(() {
          comList = value;
          getComPay();
        });
      }
    });
  }

  //recuperation des informations de pay d'une commande donnee
  void getComPay() {
    Services.getCommandePay(widget.selectCom.idCom).then((value) {
      if (int.parse(value.map((e) => e.totalPay).toList()[0]) > 0) {
        setState(() {
          fourPay = value;
        });
      }
      isloading = false;
    });
  }

//calcule de la quantite produit de la commande
  int getProdQts(String key) {
    int qts = 0;
    int prix = 0;
    for (int i = 0; i < comList.length; i++) {
      qts += int.parse(comList[i].qtsProd);
      prix +=
          (int.parse(comList[i].prixUnit) * (int.parse(comList[i].qtsProd)));
    }
    return key == 'prix' ? prix : qts;
  }

  SingleChildScrollView get _fournisseuMove {
    return SingleChildScrollView(
      controller: ScrollController(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SingleChildScrollView(
            controller: ScrollController(),
            scrollDirection: Axis.horizontal,
            child: Container(
              child: DataTable(
                  columnSpacing: 66,
                  headingTextStyle: TextStyle(
                    color: Color(0xFF26345d),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  horizontalMargin: 30,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white)),
                  columns: [
                    DataColumn(
                      label: Container(child: Text("ID")),
                    ),
                    DataColumn(
                      label: Text("Désignation"),
                    ),
                    DataColumn(
                      label: Text("Quantitée"),
                    ),
                    DataColumn(
                      label: Text("Prix_unit"),
                    ),
                    DataColumn(
                      label: Text("Prix_Total"),
                    ),
                    DataColumn(
                      label: widget.selectCom.comEtat == '0'
                          ? Text("Action")
                          : Text("Etat"),
                    ),
                  ],
                  rows: comList
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(Text(e.idProd)),
                            DataCell(Text(e.designation)),
                            DataCell(Text(e.qtsProd)),
                            DataCell(Text('${e.prixUnit} Fcfa')),
                            DataCell(Text(
                                '${int.parse(e.prixUnit) * int.parse(e.qtsProd)} Fcfa')),
                            DataCell(Row(
                              children: [
                                widget.selectCom.comEtat == '0'
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
                                                  1,
                                                  'Voulez-vous supprimer cet produits?',
                                                  'custome')
                                              .then((value) {
                                            if (value == "1") {
                                              if ((getProdQts('prix') -
                                                      (int.parse(e.prixUnit) *
                                                          int.parse(
                                                              e.qtsProd))) <
                                                  (int.parse(fourPay!
                                                      .map((e) => e.amountPay)
                                                      .toList()[0]))) {
                                                ConfirmBox().showAlert(
                                                    context,
                                                    "Le montant des produits ne doit pas depasser le montant payé",
                                                    false);
                                              } else {
                                                Services.deleteComItem(
                                                        e.idProd,
                                                        widget.selectCom.idCom,
                                                        e.qtsProd)
                                                    .then((value) {
                                                  if (int.parse(value) == 1) {
                                                    ConfirmBox()
                                                        .showAlert(
                                                            context,
                                                            "Le produit a été supprimé avec success",
                                                            true)
                                                        .then((value) =>
                                                            getCommandeCnt());
                                                  } else if (int.parse(value) ==
                                                      0) {
                                                    ConfirmBox().showAlert(
                                                        context,
                                                        "Impossible de supprimer cet produit",
                                                        false);
                                                  } else if (int.parse(value) <
                                                      0) {
                                                    ConfirmBox().showAlert(
                                                        context,
                                                        "Erreur de connexion",
                                                        false);
                                                  }
                                                });
                                              }
                                            }
                                          });
                                        },
                                      )
                                    : Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                              ],
                            ))
                          ],
                        ),
                      )
                      .toList()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
              color: Color(0xFF26345d),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "Detail de la commande",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        alignment: Alignment.bottomRight,
                        iconSize: 25,
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
            ),
            isloading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF26345d),
                      ),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height - 70,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              height: 700,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text('Fournisseur: ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(widget.selectCom.fourNom,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                )),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 2, right: 2, top: 5),
                                          child: Text(
                                              'Commande(${widget.selectCom.idCom})/${widget.selectCom.comDate}',
                                              style: TextStyle(
                                                fontSize: 25,
                                              )),
                                        ),
                                        Row(
                                          children: [
                                            Text('Date: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(widget.selectCom.comDate,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                    height: 400,
                                    padding: EdgeInsets.only(
                                        left: 2, right: 2, top: 5),
                                    child: _fournisseuMove,
                                  ),
                                  Row(
                                    mainAxisAlignment: comList.isEmpty
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      (getProdQts('prix') -
                                                  int.parse(fourPay!
                                                      .map((e) => e.amountPay)
                                                      .toList()[0])) >
                                              0
                                          ? Container(
                                              height: 50,
                                              width: 120,
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: MaterialButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Align(
                                                              alignment:
                                                                  Alignment(
                                                                      1, 0),
                                                              child: UpdPayCommande(
                                                                  qtPrix: getProdQts(
                                                                          'prix')
                                                                      .toString(),
                                                                  reste: (getProdQts(
                                                                              'prix') -
                                                                          int.parse(fourPay!
                                                                              .map((e) => e.amountPay)
                                                                              .toList()[0]))
                                                                      .toString()));
                                                        }).then((value) {
                                                      if (int.parse(value) >=
                                                          0) {
                                                        Services.fourNewPaiement(
                                                                value
                                                                    .toString()
                                                                    .split(
                                                                        '-')[0],
                                                                comList
                                                                    .map((e) =>
                                                                        e.idRav)
                                                                    .toList()[0])
                                                            .then((value) {
                                                          ConfirmBox()
                                                              .showAlert(
                                                                  context,
                                                                  'Paiement effectuée avec success',
                                                                  true)
                                                              .then((value) {
                                                            if (int.parse(
                                                                    value) ==
                                                                1) {
                                                              getComPay();
                                                            }
                                                          });
                                                        });
                                                      }
                                                    });
                                                  },
                                                  color: Color(0xFFE76006),
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.money,
                                                          color: Colors.white),
                                                      Text(
                                                        "Payer",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  )),
                                            )
                                          : Text(''),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        padding: EdgeInsets.all(2),
                                        width: 280,
                                        height: 165,
                                        child: Column(
                                          children: [
                                            Divider(
                                              thickness: 1.5,
                                              color: Colors.black,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Agent: ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(widget.selectCom.user,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Quantité: ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    comList.isEmpty
                                                        ? '0'
                                                        : getProdQts('qts')
                                                            .toString(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Prix Total: ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    comList.isEmpty
                                                        ? ' 0 '
                                                        : '${getProdQts('prix')} Fcfa',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Payée: ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    '${fourPay!
                                                            .map((e) =>
                                                                e.amountPay)
                                                            .toList()[0]} Fcfa',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.green)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Reste: ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    '${getProdQts('prix') -
                                                                int.parse(fourPay!
                                                                    .map((e) =>
                                                                        e.amountPay)
                                                                    .toList()[0])} Fcfa',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red,
                                                    )),
                                              ],
                                            ),
                                            Divider(
                                              thickness: 1.5,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
// Fin voir commande

// mise a jour d'un salaire
class SaUpdateAlert extends StatefulWidget {
  final SalaireModel? selctedSa;
  const SaUpdateAlert({
    Key? key,
    required this.selctedSa,
  }) : super(key: key);

  @override
  _SaUpdateAlertState createState() => _SaUpdateAlertState();
}

class _SaUpdateAlertState extends State<SaUpdateAlert> {
  TextEditingController? _updSaVal;
  GlobalKey<FormState>? _updCatForm;
  String msg = "";

  @override
  void initState() {
    _updSaVal = TextEditingController();
    _updSaVal!.text = widget.selctedSa!.saVal;
    _updCatForm = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      child: Container(
        height: 230,
        width: 400,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5, left: 10),
              color: Color(0xFF26345d),
              width: double.infinity,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Modification d'un salaire",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        alignment: Alignment.bottomRight,
                        iconSize: 25,
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              child: Center(
                child: Text(
                  msg,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 100,
              child: Form(
                key: _updCatForm,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _updSaVal!,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Veuillez remplire le champ ";
                    }
                    return null;
                  },
                  onSaved: (String? value) {},
                  decoration: InputDecoration(
                    hintText: "Entrer un salaire",
                    suffixIcon: MaterialButton(
                      onPressed: () {
                        if (!_updCatForm!.currentState!.validate()) {
                          return;
                        } else {
                          Services.updSalaire(
                                  _updSaVal!.text, widget.selctedSa!.saId)
                              .then((value) {
                            if (int.parse(value) == 1) {
                              Navigator.of(context).pop('1');
                            } else if (int.parse(value) == 0) {
                              setState(() {
                                msg = "Cet salaire Existe deja";
                              });
                            }
                          });
                        }
                      },
                      height: 60,
                      color: Color(0xFF089928),
                      elevation: 0,
                      child: Text(
                        "Valider",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF0AB94D), width: 2)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF0AB94D), width: 2)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// mise a jour d'une categorie
class CatUpdateAlert extends StatefulWidget {
  final CategorieModel? selctedCat;
  const CatUpdateAlert({
    Key? key,
    required this.selctedCat,
  }) : super(key: key);

  @override
  _CatUpdateAlertState createState() => _CatUpdateAlertState();
}

class _CatUpdateAlertState extends State<CatUpdateAlert> {
  TextEditingController? _updCatName;
  GlobalKey<FormState>? _updCatForm;
  String msg = "";

  @override
  void initState() {
    _updCatName = TextEditingController();
    _updCatName!.text = widget.selctedCat!.catName;
    _updCatForm = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      child: Container(
        height: 230,
        width: 400,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5, left: 10),
              color: Color(0xFF26345d),
              width: double.infinity,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Modification de categorie",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop('0');
                        },
                        icon: Icon(Icons.close),
                        alignment: Alignment.bottomRight,
                        iconSize: 25,
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              child: Center(
                child: Text(
                  msg,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 100,
              child: Form(
                key: _updCatForm,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _updCatName!,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Veuillez remplire le champ ";
                    }
                    return null;
                  },
                  onSaved: (String? value) {},
                  decoration: InputDecoration(
                    hintText: "Entrer une categorie",
                    suffixIcon: MaterialButton(
                      onPressed: () {
                        if (!_updCatForm!.currentState!.validate()) {
                          return;
                        } else {
                          Services.updCategorie(
                                  _updCatName!.text, widget.selctedCat!.catId)
                              .then((value) {
                            if (int.parse(value) == 1) {
                              Navigator.of(context).pop('1');
                            } else if (int.parse(value) == 0) {
                              setState(() {
                                msg = "Cette Categorie Existe déjà";
                              });
                            }
                          });
                        }
                      },
                      height: 60,
                      color: Color(0xFF089928),
                      elevation: 0,
                      child: Text(
                        "Valider",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF0AB94D), width: 2)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF0AB94D), width: 2)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// set commande price and quantity
class SetComElem extends StatefulWidget {
  final String qtPrix;
  final String nameProd;
  const SetComElem({
    Key? key,
    required this.qtPrix,
    required this.nameProd,
  }) : super(key: key);

  @override
  _SetComElemState createState() => _SetComElemState();
}

class _SetComElemState extends State<SetComElem> {
  TextEditingController? prix;
  TextEditingController? qts;
  bool _isQtsEmpty = false;
  bool _isPrixEmpty = false;

  @override
  void initState() {
    prix = TextEditingController();

    qts = TextEditingController();
    if (widget.qtPrix.isNotEmpty) {
      prix!.text = widget.qtPrix.split('-')[1];
      qts!.text = widget.qtPrix.split('-')[0];
    }

    _isQtsEmpty = false;
    _isPrixEmpty = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      child: Container(
        height: 260,
        width: widget.nameProd.split("").length <= 27
            ? 400
            : widget.nameProd.split("").length * 13,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5, left: 10),
              color: Color(0xFF26345d),
              width: double.infinity,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          widget.nameProd,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        alignment: Alignment.bottomRight,
                        iconSize: 25,
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                  top: 30,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 170,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: qts!,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Donner la quantite ";
                        }
                        return null;
                      },
                      onSaved: (String? value) {},
                      decoration: InputDecoration(
                        hintText: "Quantite",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _isQtsEmpty
                                    ? Color(0xFFDA0F0F)
                                    : Color(0xFF171817),
                                width: 1)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _isQtsEmpty
                                    ? Color(0xFFDA0F0F)
                                    : Color(0xFF171817),
                                width: 1)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: prix!,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Donner le Prix";
                        }
                        return null;
                      },
                      onSaved: (String? value) {},
                      decoration: InputDecoration(
                        hintText: "Prix",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _isPrixEmpty
                                    ? Color(0xFFDA0F0F)
                                    : Color(0xFF171817),
                                width: 1)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _isPrixEmpty
                                    ? Color(0xFFDA0F0F)
                                    : Color(0xFF171817),
                                width: 1)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 40,
                          child: MaterialButton(
                            onPressed: () {
                              if (prix!.text.isEmpty && qts!.text.isEmpty) {
                                setState(() {
                                  _isPrixEmpty = true;
                                  _isQtsEmpty = true;
                                });
                              } else if (prix!.text.isNotEmpty &&
                                  qts!.text.isEmpty) {
                                setState(() {
                                  _isQtsEmpty = true;
                                  _isPrixEmpty = false;
                                });
                              } else if (prix!.text.isEmpty &&
                                  qts!.text.isNotEmpty) {
                                setState(() {
                                  _isPrixEmpty = true;
                                  _isQtsEmpty = false;
                                });
                              } else {
                                setState(() {
                                  _isPrixEmpty = false;
                                  _isQtsEmpty = false;
                                });
                                Navigator.of(context)
                                    .pop('${qts!.text}-${prix!.text}');
                              }
                            },
                            color: Color(0xFF1B8D41),
                            child: Text(
                              widget.qtPrix.isEmpty ? "Valider" : 'Modifier',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

// premier paye de commande
//
class PayCommande extends StatefulWidget {
  final String qtPrix;
  const PayCommande({
    Key? key,
    required this.qtPrix,
  }) : super(key: key);

  @override
  _PayCommandeState createState() => _PayCommandeState();
}

class _PayCommandeState extends State<PayCommande> {
  TextEditingController? payType;
  TextEditingController? amountPayed;
  bool _isPaytypeEmpty = true;
  bool _isamountPayedEmpty = false;
  List<String> payTypes = ['Espece', 'Chèque', 'Orange Money', 'Moov Money'];

  @override
  void initState() {
    payType = TextEditingController();
    payType!.text = payTypes[0];
    amountPayed = TextEditingController();
    _isPaytypeEmpty = true;
    _isamountPayedEmpty = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      child: Container(
        height: 410,
        width: 400,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5, left: 10),
              color: Color(0xFF26345d),
              width: double.infinity,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "Payement de la commande",
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop('0');
                        },
                        icon: Icon(Icons.close),
                        alignment: Alignment.bottomRight,
                        iconSize: 25,
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                height: 340,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Somme Total: ".toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        Text('${widget.qtPrix} Fcfa',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    ),
                    MyFunction().dropdown("Type de payement", payTypes, payType,
                        _isPaytypeEmpty, 'upd', payTypes[0]),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Somme à payer',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: amountPayed!,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Donner une somme ";
                        }
                        return null;
                      },
                      onSaved: (String? value) {},
                      decoration: InputDecoration(
                        hintText: "Somme à payer",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _isamountPayedEmpty
                                    ? Color(0xFFDA0F0F)
                                    : Color(0xFF171817),
                                width: 1)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _isamountPayedEmpty
                                    ? Color(0xFFDA0F0F)
                                    : Color(0xFF171817),
                                width: 1)),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 40,
                          child: MaterialButton(
                            onPressed: () {
                              if (payType!.text.isEmpty &&
                                  amountPayed!.text.isEmpty) {
                                setState(() {
                                  _isPaytypeEmpty = true;
                                  _isamountPayedEmpty = true;
                                });
                              } else if (!payType!.text.isNotEmpty &&
                                  amountPayed!.text.isEmpty) {
                                setState(() {
                                  _isPaytypeEmpty = true;
                                  _isamountPayedEmpty = true;
                                });
                              } else if (payType!.text.isEmpty &&
                                  !amountPayed!.text.isNotEmpty) {
                                setState(() {
                                  _isPaytypeEmpty = false;
                                  _isamountPayedEmpty = false;
                                });
                              } else {
                                if (int.parse(amountPayed!.text) >
                                    int.parse(widget.qtPrix)) {
                                  ConfirmBox().showAlert(
                                      context,
                                      "La somme payée depasse la somme totale",
                                      false);
                                } else {
                                  Navigator.of(context).pop(
                                      '${payType!.text}-${amountPayed!.text}');
                                }
                                setState(() {
                                  _isPaytypeEmpty = true;
                                  _isamountPayedEmpty = false;
                                });
                              }
                            },
                            color: Color(0xFF1B8D41),
                            child: Text(
                              "Valider",
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
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

//mise a jour du paiement de la commande
class UpdPayCommande extends StatefulWidget {
  final String qtPrix;
  final String reste;
  const UpdPayCommande({
    Key? key,
    required this.qtPrix,
    required this.reste,
  }) : super(key: key);

  @override
  _UpdPayCommandeState createState() => _UpdPayCommandeState();
}

class _UpdPayCommandeState extends State<UpdPayCommande> {
  TextEditingController? amountPayed;
  bool _isamountPayedEmpty = false;

  @override
  void initState() {
    amountPayed = TextEditingController();
    _isamountPayedEmpty = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      child: Container(
        height: 260,
        width: 400,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5, left: 10),
              color: Color(0xFF26345d),
              width: double.infinity,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "Payement de la commande",
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop('-1');
                        },
                        icon: Icon(Icons.close),
                        alignment: Alignment.bottomRight,
                        iconSize: 25,
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Somme Total: ".toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        Text('${widget.qtPrix} Fcfa',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          "Reste: ".toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        Text('${widget.reste} Fcfa',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Somme à payer',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: amountPayed!,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Donner une somme ";
                        }
                        return null;
                      },
                      onSaved: (String? value) {},
                      decoration: InputDecoration(
                        hintText: "Somme à payer",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _isamountPayedEmpty
                                    ? Color(0xFFDA0F0F)
                                    : Color(0xFF171817),
                                width: 1)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _isamountPayedEmpty
                                    ? Color(0xFFDA0F0F)
                                    : Color(0xFF171817),
                                width: 1)),
                        suffixIcon: Container(
                          height: 50,
                          child: MaterialButton(
                            onPressed: () {
                              if (amountPayed!.text.isEmpty) {
                                setState(() {
                                  _isamountPayedEmpty = true;
                                });
                              } else {
                                if (int.parse(amountPayed!.text) >
                                    int.parse(widget.reste)) {
                                  ConfirmBox().showAlert(
                                      context,
                                      "La somme payée depasse le reste à payer",
                                      false);
                                } else {
                                  Navigator.of(context).pop(amountPayed!.text);
                                }
                                setState(() {
                                  _isamountPayedEmpty = false;
                                });
                              }
                            },
                            color: Color(0xFF1B8D41),
                            child: Text(
                              "Payer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

// Voir liste des commandes par date
class GetCommandeListe extends StatefulWidget {
  final List<CommandeDetailsModel> commandeList;
  final List<PayComNumListModel>? listpayComTypeNum;

  const GetCommandeListe({
    Key? key,
    required this.commandeList,
    this.listpayComTypeNum,
  }) : super(key: key);

  @override
  State<GetCommandeListe> createState() => _GetCommandeListeState();
}

class _GetCommandeListeState extends State<GetCommandeListe> {
  List<CommandeDetailsModel>? copycommandeList;
  final controller = ScrollController();
  bool clienSearch = true;
  bool dateSearch = false;
  bool numCom = false;
  bool typePay = false;
  bool agent = false;
  @override
  void initState() {
    copycommandeList = widget.commandeList;

    super.initState();
  }

  // verifier les types de paiement
  String checkPayType(String idcom, String val) {
    List<String> returnVal = [];
    int cheker = 0;
    for (int i = 0; i < widget.listpayComTypeNum!.length; i++) {
      if (widget.listpayComTypeNum![i].itemId == idcom) {
        cheker = 1;
        val == 'type'
            ? !returnVal.contains(widget.listpayComTypeNum![i].itemType)
                ? returnVal.add(widget.listpayComTypeNum![i].itemType)
                : ""
            : !returnVal.contains(widget.listpayComTypeNum![i].itemVal)
                ? returnVal.add(widget.listpayComTypeNum![i].itemVal)
                : "";
      }
    }
    if (cheker == 0 && val == 'type') {
      !returnVal.contains("Crédit") ? returnVal.add('Crédit') : "";
    } else if (cheker == 0 && val != 'type') {
      returnVal.add('========');
    }

    return returnVal.join("-");
  }

  SingleChildScrollView get _fournisseuMove {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: DataTable(
            columnSpacing: 45,
            headingTextStyle: TextStyle(
              color: Color(0xFF26345d),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            horizontalMargin: 30,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white)),
            columns: [
              DataColumn(
                label: Container(
                    child: Row(
                  children: [
                    Text("Num_com"),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            copycommandeList = widget.commandeList;
                            clienSearch = false;
                            dateSearch = false;
                            numCom = true;
                            typePay = false;
                            agent = false;
                          });
                        },
                        icon: Icon(
                          Icons.filter_list_alt,
                          size: 20,
                          color: numCom ? Colors.green : Colors.black,
                        ))
                  ],
                )),
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text("Nom client"),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          copycommandeList = widget.commandeList;
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
                label: Text("Montant"),
              ),
              DataColumn(
                label: Text("Type Paiementt"),
              ),
              DataColumn(
                label: Text("Num_compte"),
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
                              copycommandeList = widget.commandeList;
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
                  ],
                ),
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
                          copycommandeList = widget.commandeList;
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
            rows: copycommandeList!
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(widget.commandeList.isEmpty
                          ? ''
                          : ConfirmBox()
                              .numFacture(e.date_com.split('-')[0], e.id_com))),
                      DataCell(Text(e.client_com)),
                      DataCell(Text('${e.total_com} Fcfa')),
                      DataCell(Text(checkPayType(e.id_com, 'type'))),
                      DataCell(Text(checkPayType(e.id_com, 'none'))),
                      DataCell(Text(e.date_com)),
                      DataCell(
                        Text(
                            int.parse(e.deliver_com) == 1
                                ? 'Livrée'
                                : 'Non livrée',
                            style: TextStyle(
                                color: int.parse(e.deliver_com) == 0
                                    ? Colors.blue
                                    : Colors.green)),
                      ),
                      DataCell(Text(e.user_com)),
                    ],
                  ),
                )
                .toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
              color: Color(0xFF26345d),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "Liste des commandes",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        alignment: Alignment.bottomRight,
                        iconSize: 25,
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 700,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10, left: 5),
                          width: 400,
                          child: clienSearch
                              ? TextField(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      hintText:
                                          "Rechercher par nom du Client..."),
                                  onChanged: (seach) {
                                    setState(() {
                                      copycommandeList = widget.commandeList
                                          .where((element) => (element
                                              .client_com
                                              .toLowerCase()
                                              .contains(seach.toLowerCase())))
                                          .toList();
                                    });
                                  },
                                )
                              : agent
                                  ? TextField(
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          hintText: "Rechercher par agent..."),
                                      onChanged: (seach) {
                                        setState(() {
                                          copycommandeList = widget.commandeList
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
                                                  EdgeInsets.all(10),
                                              hintText:
                                                  "Rechercher par numero de commande..."),
                                          onChanged: (seach) {
                                            setState(() {
                                              copycommandeList = widget
                                                  .commandeList
                                                  .where((element) => (element
                                                      .id_com
                                                      .toLowerCase()
                                                      .contains(
                                                          seach.toLowerCase())))
                                                  .toList();
                                            });
                                          },
                                        )
                                      : TextField(
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              hintText:
                                                  "Rechercher par date..."),
                                          onChanged: (seach) {
                                            setState(() {
                                              copycommandeList = widget
                                                  .commandeList
                                                  .where((element) => (element
                                                      .date_com
                                                      .toLowerCase()
                                                      .contains(
                                                          seach.toLowerCase())))
                                                  .toList();
                                            });
                                          },
                                        ),
                        ),
                        Container(
                          height: 640,
                          padding: EdgeInsets.only(left: 2, right: 2, top: 5),
                          child: ImprovedScrolling(
                              enableCustomMouseWheelScrolling: true,
                              enableKeyboardScrolling: true,
                              enableMMBScrolling: true,
                              mmbScrollConfig: MMBScrollConfig(
                                customScrollCursor: DefaultCustomScrollCursor(
                                  backgroundColor: Colors.white,
                                  cursorColor: Color(0xFF26345d),
                                ),
                              ),
                              customMouseWheelScrollConfig:
                                  CustomMouseWheelScrollConfig(
                                      scrollAmountMultiplier: 4.0),
                              scrollController: controller,
                              child: _fournisseuMove),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Voir detail paiement
class PaymentDetail extends StatefulWidget {
  final List<PaymentListeModel> detailPay;
  const PaymentDetail({
    Key? key,
    required this.detailPay,
  }) : super(key: key);

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  List<PaymentListeModel>? copydetailPay;
  final controller = ScrollController();
  bool clienSearch = true;
  bool dateSearch = false;
  bool numCom = false;
  bool typePay = false;
  bool agent = false;
  bool is_loading = true;
  @override
  void initState() {
    copydetailPay = widget.detailPay;
    super.initState();
    // print(widget.detailPay.map((e) => print(e.toMap())));
  }

  int getTotal(List<PaymentListeModel> data) {
    int total = 0;
    for (int i = 0; i < data.length; i++) {
      total += int.parse(data[i].somme_pay);
    }
    // Loader.hide();
    return total;
  }

  SingleChildScrollView get _fournisseuMove {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: DataTable(
            columnSpacing: 85,
            headingTextStyle: TextStyle(
              color: Color(0xFF26345d),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            horizontalMargin: 30,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
            ),
            columns: [
              DataColumn(
                label: Container(
                    child: Row(
                  children: [
                    Text("Num_com"),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          copydetailPay = widget.detailPay;
                          clienSearch = false;
                          dateSearch = false;
                          numCom = true;
                          typePay = false;
                          agent = false;
                        });
                      },
                      icon: Icon(
                        Icons.filter_list_alt,
                        size: 20,
                        color: numCom ? Colors.green : Colors.black,
                      ),
                    )
                  ],
                )),
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text("Nom client"),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          copydetailPay = widget.detailPay;
                          clienSearch = true;
                          dateSearch = false;
                          numCom = false;
                          agent = false;
                          typePay = false;
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
                label: Row(
                  children: [
                    Text("Type paiement"),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          copydetailPay = widget.detailPay;
                          clienSearch = false;
                          dateSearch = false;
                          numCom = false;
                          agent = false;
                          typePay = true;
                        });
                      },
                      icon: Icon(
                        Icons.filter_list_alt,
                        size: 20,
                        color: typePay ? Colors.green : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              DataColumn(
                label: Text("Somme payée"),
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text("Date paiement"),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          copydetailPay = widget.detailPay;
                          clienSearch = false;
                          dateSearch = true;
                          numCom = false;
                          typePay = false;
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
                    Text("Agent"),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          copydetailPay = widget.detailPay;
                          clienSearch = false;
                          dateSearch = false;
                          numCom = false;
                          agent = true;
                          typePay = false;
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
            rows: copydetailPay!
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          int.parse(e.is_manual) == 1
                              ? e.fact_num
                              : widget.detailPay.isEmpty
                                  ? ''
                                  : ConfirmBox().numFacture(
                                      e.date_pay.split('-')[0], e.idcom_pay),
                          style: TextStyle(
                              color: int.parse(e.is_manual) == 1
                                  ? Colors.red
                                  : Colors.black),
                        ),
                      ),
                      DataCell(Text(e.client_pay)),
                      DataCell(
                        Text(e.pay_type,
                            style: TextStyle(
                                color: e.pay_type.split("=>")[0] == 'Credit'
                                    ? Colors.blue
                                    : Colors.green)),
                      ),
                      DataCell(Text('${e.somme_pay} Fcfa')),
                      DataCell(Text(e.date_pay)),
                      DataCell(Text(e.user_pay)),
                    ],
                  ),
                )
                .toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      is_loading = false;
    });

    return Dialog(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: is_loading
          ? CircularProgressIndicator()
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    color: Color(0xFF26345d),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                "Détail de Paiements",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close),
                              alignment: Alignment.bottomRight,
                              iconSize: 25,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: 700,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Espèce: "),
                                          Text("${getTotal(widget.detailPay
                                                      .where((element) => (element
                                                          .pay_type
                                                          .toLowerCase()
                                                          .contains("Espèce"
                                                              .toLowerCase())))
                                                      .toList())} Fcfa")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Chèque: "),
                                          Text("${getTotal(widget.detailPay
                                                      .where((element) => (element
                                                          .pay_type
                                                          .toLowerCase()
                                                          .contains("Chèque"
                                                              .toLowerCase())))
                                                      .toList())} Fcfa")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Orange Money: "),
                                          Text("${getTotal(widget.detailPay
                                                      .where((element) => (element
                                                          .pay_type
                                                          .toLowerCase()
                                                          .contains("Orange Money"
                                                              .toLowerCase())))
                                                      .toList())} Fcfa")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Moov Money: "),
                                          Text("${getTotal(widget.detailPay
                                                      .where((element) => (element
                                                          .pay_type
                                                          .toLowerCase()
                                                          .contains("Moov Money"
                                                              .toLowerCase())))
                                                      .toList())} Fcfa")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Bon de sortie: "),
                                          Text("${getTotal(widget.detailPay
                                                      .where((element) => (element
                                                          .pay_type
                                                          .toLowerCase()
                                                          .contains("Bon de sortie"
                                                              .toLowerCase())))
                                                      .toList())} Fcfa")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Crédit (Espèce): ",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          Text("${getTotal(widget.detailPay
                                                      .where((element) => (element
                                                          .pay_type
                                                          .toLowerCase()
                                                          .contains(
                                                              "Credit=>Espece"
                                                                  .toLowerCase())))
                                                      .toList())} Fcfa")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Crédit (Chèque): ",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          Text("${getTotal(widget.detailPay
                                                      .where((element) => (element
                                                          .pay_type
                                                          .toLowerCase()
                                                          .contains(
                                                              "Credit=>Chèque"
                                                                  .toLowerCase())))
                                                      .toList())} Fcfa")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Crédit (Orange Money): ",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          Text("${getTotal(widget.detailPay
                                                      .where((element) => (element
                                                          .pay_type
                                                          .toLowerCase()
                                                          .contains(
                                                              "Credit=>Orange Money"
                                                                  .toLowerCase())))
                                                      .toList())} Fcfa")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Crédit (Moov Money): ",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          Text("${getTotal(widget.detailPay
                                                      .where((element) => (element
                                                          .pay_type
                                                          .toLowerCase()
                                                          .contains(
                                                              "Credit=>Moov Money"
                                                                  .toLowerCase())))
                                                      .toList())} Fcfa")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Crédit (Inconnu): ",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          Text("${getTotal(widget.detailPay
                                                      .where((element) => (element
                                                              .pay_type
                                                              .toLowerCase() ==
                                                          "Credit"
                                                              .toLowerCase()))
                                                      .toList())} Fcfa")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Crédit (Total): ",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          Text("${getTotal(widget.detailPay
                                                      .where((element) => (element
                                                          .pay_type
                                                          .toLowerCase()
                                                          .split('=>')[0]
                                                          .contains("Credit"
                                                              .toLowerCase())))
                                                      .toList())} Fcfa")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10, left: 5),
                                width: 300,
                                child: clienSearch
                                    ? TextField(
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            hintText:
                                                "Rechercher par nom du Client..."),
                                        onChanged: (seach) {
                                          setState(() {
                                            copydetailPay = widget.detailPay
                                                .where((element) => (element
                                                    .client_pay
                                                    .toLowerCase()
                                                    .contains(
                                                        seach.toLowerCase())))
                                                .toList();
                                          });
                                        },
                                      )
                                    : agent
                                        ? TextField(
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                hintText:
                                                    "Rechercher par agent..."),
                                            onChanged: (seach) {
                                              setState(() {
                                                copydetailPay = widget.detailPay
                                                    .where((element) => (element
                                                        .user_pay
                                                        .toLowerCase()
                                                        .contains(seach
                                                            .toLowerCase())))
                                                    .toList();
                                              });
                                            },
                                          )
                                        : numCom
                                            ? TextField(
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText:
                                                        "Rechercher par numéro de commande..."),
                                                onChanged: (seach) {
                                                  setState(() {
                                                    copydetailPay = widget
                                                        .detailPay
                                                        .where((element) => (element
                                                            .idcom_pay
                                                            .toLowerCase()
                                                            .contains(seach
                                                                .toLowerCase())))
                                                        .toList();
                                                  });
                                                },
                                              )
                                            : typePay
                                                ? TextField(
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        hintText:
                                                            "Rechercher par type de paiement..."),
                                                    onChanged: (seach) {
                                                      setState(() {
                                                        copydetailPay = widget
                                                            .detailPay
                                                            .where((element) => (element
                                                                .pay_type
                                                                .toLowerCase()
                                                                .contains(seach
                                                                    .toLowerCase())))
                                                            .toList();
                                                      });
                                                    },
                                                  )
                                                : TextField(
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        hintText:
                                                            "Rechercher par date..."),
                                                    onChanged: (seach) {
                                                      setState(() {
                                                        copydetailPay = widget
                                                            .detailPay
                                                            .where((element) => (element
                                                                .date_pay
                                                                .toLowerCase()
                                                                .contains(seach
                                                                    .toLowerCase())))
                                                            .toList();
                                                      });
                                                    },
                                                  ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.black),
                                ),
                                height: 550,
                                padding:
                                    EdgeInsets.only(left: 2, right: 2, top: 5),
                                child: ImprovedScrolling(
                                    enableCustomMouseWheelScrolling: true,
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
                                            scrollAmountMultiplier: 4.0),
                                    scrollController: controller,
                                    child: _fournisseuMove),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}

// Voir detail credit
class CreditDetail extends StatefulWidget {
  final List<CreditModel> detailCred;
  final String periode;
  const CreditDetail({
    Key? key,
    required this.detailCred,
    required this.periode,
  }) : super(key: key);

  @override
  State<CreditDetail> createState() => _CreditDetailState();
}

class _CreditDetailState extends State<CreditDetail> {
  final controller = ScrollController();
  bool clienSearch = true;
  bool dateSearch = false;
  List<CreditModel>? copydetailCred;
  @override
  void initState() {
    super.initState();
    copydetailCred = widget.detailCred;
  }

  SingleChildScrollView get _fournisseuMove {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: DataTable(
            columnSpacing: 65,
            headingTextStyle: TextStyle(
              color: Color(0xFF26345d),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            horizontalMargin: 30,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white)),
            columns: [
              DataColumn(
                label: Container(child: Text("Numéro_commande")),
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text("Nom client"),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            copydetailCred = widget.detailCred;
                            clienSearch = true;
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
                label: Text("Prix total"),
              ),
              DataColumn(
                label: Text("Somme payée"),
              ),
              DataColumn(
                label: Text("Reste"),
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text("Date crédit"),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            copydetailCred = widget.detailCred;
                            clienSearch = false;
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
                label: Text("Date_rembour"),
              ),
              DataColumn(
                label: Text("Agent"),
              ),
            ],
            rows: copydetailCred!
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(copydetailCred!.isEmpty
                          ? ''
                          : ConfirmBox()
                              .numFacture(e.dateCred.split('-')[0], e.nume))),
                      DataCell(Text(e.nom)),
                      DataCell(Text(
                          (int.parse(e.paye) + int.parse(e.reste)).toString())),
                      DataCell(Text('${e.paye} Fcfa')),
                      DataCell(Text('${e.reste} Fcfa')),
                      DataCell(Text(e.dateCred)),
                      DataCell(Text(e.dateRem)),
                      DataCell(Text(e.agent)),
                    ],
                  ),
                )
                .toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Container(
        padding: EdgeInsets.all(0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
              color: Color(0xFF26345d),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "Détail de credits",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        alignment: Alignment.bottomRight,
                        iconSize: 25,
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10, left: 5),
                    width: 400,
                    child: clienSearch
                        ? TextField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: "Rechercher par nom client..."),
                            onChanged: (seach) {
                              setState(() {
                                copydetailCred = widget.detailCred
                                    .where((element) => (element.nom
                                        .toLowerCase()
                                        .contains(seach.toLowerCase())))
                                    .toList();
                              });
                            },
                          )
                        : TextField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: "Rechercher par date..."),
                            onChanged: (seach) {
                              setState(() {
                                copydetailCred = widget.detailCred
                                    .where((element) => (element.dateCred
                                        .toLowerCase()
                                        .contains(seach.toLowerCase())))
                                    .toList();
                              });
                            },
                          ),
                  ),
                  TextButton(
                      onPressed: () {
                        ExportExcell.exportCreditExcel(
                          title: widget.periode,
                          creditList: widget.detailCred,
                        );
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.print),
                          Text("Exporter"),
                        ],
                      )),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
              ),
              height: 640,
              child: ImprovedScrolling(
                  enableCustomMouseWheelScrolling: true,
                  enableKeyboardScrolling: true,
                  enableMMBScrolling: true,
                  mmbScrollConfig: MMBScrollConfig(
                    customScrollCursor: DefaultCustomScrollCursor(
                      backgroundColor: Colors.white,
                      cursorColor: Color(0xFF26345d),
                    ),
                  ),
                  customMouseWheelScrollConfig:
                      CustomMouseWheelScrollConfig(scrollAmountMultiplier: 4.0),
                  scrollController: controller,
                  child: _fournisseuMove),
            )
          ],
        ),
      ),
    );
  }
}

// Voir detail virement
class ListVirement extends StatefulWidget {
  const ListVirement({
    Key? key,
  }) : super(key: key);

  @override
  State<ListVirement> createState() => _ListVirementState();
}

class _ListVirementState extends State<ListVirement> {
  List<VirementModel>? vireList;
  List<VirementModel>? copvireList;
  final controller = ScrollController();
  bool clienSearch = true;
  bool dateSearch = false;
  bool is_empty = false;
  bool is_loading = true;
  @override
  void initState() {
    super.initState();
    clienSearch = true;
    dateSearch = false;
    vireList = [];
    copvireList = [];
    getVireListe();
  }

  //recuperation de virement
  getVireListe() {
    setState(() {
      is_loading = true;
      is_empty = false;
    });
    Services.getVireLis().then((value) {
      setState(() {
        is_loading = false;
      });
      if (int.parse(value.map((e) => e.id_vire).toList()[0]) <= 0) {
        setState(() {
          is_empty = true;
        });

        if (int.parse(value.map((e) => e.id_vire).toList()[0]) < 0) {
          ConfirmBox().showAlert(context, 'Erreur de connexion', false);
        }
      } else if (int.parse(value.map((e) => e.id_vire).toList()[0]) > 0) {
        setState(() {
          vireList = value;
          copvireList = value;
        });
      }
    });
  }

  SingleChildScrollView get _fournisseuMove {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: DataTable(
            columnSpacing: 20,
            headingTextStyle: TextStyle(
              color: Color(0xFF26345d),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            horizontalMargin: 30,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white)),
            columns: [
              DataColumn(
                label: Container(
                    child: Row(
                  children: [
                    Text("Nom_compte"),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            copvireList = vireList;
                            clienSearch = true;
                            dateSearch = false;
                          });
                        },
                        icon: Icon(
                          Icons.filter_list_alt,
                          size: 20,
                          color: clienSearch ? Colors.green : Colors.black,
                        ))
                  ],
                )),
              ),
              DataColumn(
                label: Text("Num_compte"),
              ),
              DataColumn(
                label: Text("Banque"),
              ),
              DataColumn(
                label: Text("Agent"),
              ),
              DataColumn(
                label: Text("Somme"),
              ),
              DataColumn(
                label: Text("Agent traiteur"),
              ),
              DataColumn(
                label: Text("Description"),
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text("Date"),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            copvireList = vireList;
                            clienSearch = false;
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
                label: Text("Action"),
              ),
            ],
            rows: copvireList!
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.nom_compte)),
                      DataCell(Text(e.num_compte)),
                      DataCell(Text(e.banq_nom)),
                      DataCell(Text(e.agent)),
                      DataCell(Text(e.somme)),
                      DataCell(Text(e.process)),
                      DataCell(Text(e.desc_vire)),
                      DataCell(Text(e.date_vire)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                AlertBox()
                                    .showAlertDialod(
                                        context,
                                        int.parse(e.id_vire),
                                        'Voulez-vous supprimer le virement?',
                                        'virementbank')
                                    .then((value) {
                                  if (int.parse(value) == -1) {
                                    ConfirmBox().showAlert(
                                        context,
                                        'Impossible de supprimer. Réessayer encore',
                                        false);
                                  } else if (int.parse(value) == 1) {
                                    ConfirmBox()
                                        .showAlert(
                                            context, 'Suppression reussi', true)
                                        .then((value) {
                                      setState(() {
                                        getVireListe();
                                      });
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Container(
        padding: EdgeInsets.all(0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
              color: Color(0xFF26345d),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "Liste de virements",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        alignment: Alignment.bottomRight,
                        iconSize: 25,
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
            ),
            is_loading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height - 110,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: Column(children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10, left: 5),
                                width: 400,
                                child: clienSearch
                                    ? TextField(
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            hintText:
                                                "Rechercher par nom du compte..."),
                                        onChanged: (seach) {
                                          setState(() {
                                            copvireList = vireList!
                                                .where((element) => (element
                                                    .nom_compte
                                                    .toLowerCase()
                                                    .contains(
                                                        seach.toLowerCase())))
                                                .toList();
                                          });
                                        },
                                      )
                                    : TextField(
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            hintText: "Rechercher par date..."),
                                        onChanged: (seach) {
                                          setState(() {
                                            copvireList = vireList!
                                                .where((element) => (element
                                                    .date_vire
                                                    .toLowerCase()
                                                    .contains(
                                                        seach.toLowerCase())))
                                                .toList();
                                          });
                                        },
                                      ),
                              ),
                              Container(
                                child: MaterialButton(
                                  color: Colors.green,
                                  height: 50,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return VirementBank();
                                        }).then((value) {
                                      setState(() {
                                        getVireListe();
                                      });
                                    });
                                  },
                                  child: Text(
                                    'Nouveau virement',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                          height: 640,
                          child: is_empty
                              ? Expanded(
                                  child: Center(
                                    child: Text(
                                      "Aucune donnée trouvée",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : ImprovedScrolling(
                                  enableCustomMouseWheelScrolling: true,
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
                                          scrollAmountMultiplier: 4.0),
                                  scrollController: controller,
                                  child: _fournisseuMove),
                        )
                      ]),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

// Voir detail retrait
class ListRetrai extends StatefulWidget {
  const ListRetrai({
    Key? key,
  }) : super(key: key);

  @override
  State<ListRetrai> createState() => _ListRetraiState();
}

class _ListRetraiState extends State<ListRetrai> {
  List<RetraitModel>? retraiList;
  List<RetraitModel>? copyretraiList;
  bool clienSearch = true;
  bool dateSearch = false;
  bool is_loading = true;
  bool is_empty = false;
  final controller = ScrollController();
  @override
  void initState() {
    super.initState();
    clienSearch = true;
    dateSearch = false;
    retraiList = [];
    copyretraiList = [];
    getRetraiListe();
  }

  //recuperation de virement
  getRetraiListe() {
    setState(() {
      is_empty = false;
      is_loading = true;
    });
    Services.getRetraitLis().then((value) {
      setState(() {
        is_loading = false;
      });
      if (int.parse(value.map((e) => e.id_ret).toList()[0]) <= 0) {
        setState(() {
          is_empty = false;
        });
        if (int.parse(value.map((e) => e.id_ret).toList()[0]) < 0) {
          ConfirmBox().showAlert(context, 'Erreur de connexion', false);
        }
      } else if (int.parse(value.map((e) => e.id_ret).toList()[0]) > 0) {
        setState(() {
          retraiList = value;
          copyretraiList = value;
        });
      } else {
        setState(() {
          retraiList = [];
          copyretraiList = [];
        });
      }
    });
  }

  SingleChildScrollView get _fournisseuMove {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: DataTable(
            columnSpacing: 20,
            headingTextStyle: TextStyle(
              color: Color(0xFF26345d),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            horizontalMargin: 30,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white)),
            columns: [
              DataColumn(
                label: Text("Num_Fact"),
              ),
              DataColumn(
                label: Container(
                    child: Row(
                  children: [
                    Text("Nom_compte"),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            copyretraiList = retraiList;
                            clienSearch = true;
                            dateSearch = false;
                          });
                        },
                        icon: Icon(
                          Icons.filter_list_alt,
                          size: 20,
                          color: clienSearch ? Colors.green : Colors.black,
                        ))
                  ],
                )),
              ),
              DataColumn(
                label: Text("Num_compte"),
              ),
              DataColumn(
                label: Text("Banque"),
              ),
              DataColumn(
                label: Text("Agent"),
              ),
              DataColumn(
                label: Text("Somme"),
              ),
              DataColumn(
                label: Text("Agent traiteur"),
              ),
              DataColumn(
                label: Text("Description"),
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text("Date"),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            copyretraiList = retraiList;
                            clienSearch = false;
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
                label: Text("Action"),
              ),
            ],
            rows: copyretraiList!
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.fact_num)),
                      DataCell(Text(e.nom_compte)),
                      DataCell(Text(e.num_compte)),
                      DataCell(Text(e.banq_nom)),
                      DataCell(Text(e.agent)),
                      DataCell(Text(e.somme)),
                      DataCell(Text(e.process)),
                      DataCell(Text(e.desc_re)),
                      DataCell(Text(e.date_vire)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                AlertBox()
                                    .showAlertDialod(
                                        context,
                                        int.parse(e.id_ret),
                                        'Voulez-vous supprimer le retrait?',
                                        'retraitbank')
                                    .then((value) {
                                  if (int.parse(value) == -1) {
                                    ConfirmBox().showAlert(
                                        context,
                                        'Impossible de supprimer. Réessayer encore',
                                        false);
                                  } else if (int.parse(value) == 1) {
                                    ConfirmBox()
                                        .showAlert(
                                            context, 'Suppression reussi', true)
                                        .then((value) {
                                      setState(() {
                                        getRetraiListe();
                                      });
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
              color: Color(0xFF26345d),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "Liste des retraits",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        alignment: Alignment.bottomRight,
                        iconSize: 25,
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
            ),
            is_loading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height - 110,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: Column(children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10, left: 5),
                                width: 400,
                                child: clienSearch
                                    ? TextField(
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            hintText:
                                                "Rechercher par nom du compte..."),
                                        onChanged: (seach) {
                                          setState(() {
                                            copyretraiList = retraiList!
                                                .where((element) => (element
                                                    .nom_compte
                                                    .toLowerCase()
                                                    .contains(
                                                        seach.toLowerCase())))
                                                .toList();
                                          });
                                        },
                                      )
                                    : TextField(
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            hintText: "Rechercher par date..."),
                                        onChanged: (seach) {
                                          setState(() {
                                            copyretraiList = copyretraiList!
                                                .where((element) => (element
                                                    .date_vire
                                                    .toLowerCase()
                                                    .contains(
                                                        seach.toLowerCase())))
                                                .toList();
                                          });
                                        },
                                      ),
                              ),
                              Container(
                                child: MaterialButton(
                                  color: Colors.green,
                                  height: 50,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return RetraitBank();
                                        }).then((value) {
                                      setState(() {
                                        getRetraiListe();
                                      });
                                    });
                                  },
                                  child: Text(
                                    'Nouveau retrait',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                          height: 640,
                          child: is_empty
                              ? Expanded(
                                  child: Center(
                                    child: Text(
                                      "Aucune donnée trouvée",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : ImprovedScrolling(
                                  enableCustomMouseWheelScrolling: true,
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
                                          scrollAmountMultiplier: 4.0),
                                  scrollController: controller,
                                  child: _fournisseuMove),
                        )
                      ]),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

// engistrement de depenses
class SaveDepense extends StatefulWidget {
  const SaveDepense({Key? key}) : super(key: key);

  @override
  State<SaveDepense> createState() => _SaveDepenseState();
}

class _SaveDepenseState extends State<SaveDepense> {
  TextEditingController? somme;
  TextEditingController? user;
  TextEditingController? desc;
  GlobalKey<FormState>? _depFormKey;
  // bool _isDateSelect = false;
  @override
  void initState() {
    super.initState();
    somme = TextEditingController();
    user = TextEditingController();
    desc = TextEditingController();
    _depFormKey = GlobalKey<FormState>();
    // _isDateSelect = false;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          user!.text = state.user!.id.toString();
          return Dialog(
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            child: Container(
              height: 400,
              width: 440,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    color: Color(0xFF26345d),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                "Enregistrement de credit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close),
                              alignment: Alignment.bottomRight,
                              iconSize: 25,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 330,
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Form(
                            key: _depFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 400,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Somme",
                                                false,
                                                somme!,
                                                TextInputType.text,
                                                true,
                                                1,
                                                0,
                                                true),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 400,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Description",
                                                false,
                                                desc!,
                                                TextInputType.text,
                                                false,
                                                2,
                                                25,
                                                false),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 3, left: 3),
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (!_depFormKey!.currentState!
                                            .validate()) {
                                          return;
                                        } else {
                                          loader(context);
                                          Services.saveDepense(desc!.text,
                                                  somme!.text, user!.text)
                                              .then((value) {
                                            Loader.hide();
                                            if (int.parse(value) == 0) {
                                              ConfirmBox().showAlert(
                                                  context,
                                                  'Impossible d\'enregistrer. réessayer encore',
                                                  false);
                                            } else if (int.parse(value) < 0) {
                                              ConfirmBox().showAlert(context,
                                                  'Erreur de connexion', false);
                                            }
                                            if (int.parse(value) == 1) {
                                              ConfirmBox()
                                                  .showAlert(
                                                      context,
                                                      'Depense enregistrée avec succès.',
                                                      true)
                                                  .then((value) {
                                                somme!.text = '';
                                                desc!.text = '';
                                              });
                                            }
                                          });
                                        }
                                      },
                                      minWidth: 200,
                                      height: 60,
                                      color: Color(0xFF26345d),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(
                                        "Valider",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

// voir les depenses
class ListDepense extends StatefulWidget {
  const ListDepense({
    Key? key,
  }) : super(key: key);

  @override
  State<ListDepense> createState() => _ListDepenseState();
}

class _ListDepenseState extends State<ListDepense> {
  List<DepenseModel>? depenseList;
  List<DepenseModel>? copyDepenseList;
  List acces = ['SECRET1', 'SECRET2'];
  bool agentSearch = false;
  bool etatSearch = false;
  bool dateSearch = true;
  bool is_loading = true;
  bool is_empty = false;

  TextEditingController end = TextEditingController();
  TextEditingController seach = TextEditingController();
  TextEditingController seachInput = TextEditingController();
  bool endPred = false;
  bool endSuiv = false;
  @override
  void initState() {
    super.initState();
    depenseList = [];
    copyDepenseList = [];
    seach.text = '';
    end.text = "0";
    getDepenseListe(end.text, seach.text, true, true);
  }

  //recuperation de depenses
  getDepenseListe(String ends, String cherche, bool isfront, bool same) {
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
    Services.getDepenseLisLimit(limit, cherche).then((value) {
      setState(() {
        is_loading = false;
      });

      if (int.parse(value.map((e) => e.id_dep).toList()[0]) <= 0) {
        setState(() {
          is_empty = true;
        });
        if (int.parse(value.map((e) => e.id_dep).toList()[0]) < 0) {
          ConfirmBox().showAlert(context, 'Erreur de connexion', false);
        }

        setState(() {
          depenseList = [];
          copyDepenseList = [];
        });
      } else if (int.parse(value.map((e) => e.id_dep).toList()[0]) > 0) {
        setState(() {
          depenseList = value;
          copyDepenseList = value;
          value.length < 12 ? endSuiv = true : endSuiv = false;
        });
      } else {
        setState(() {
          depenseList = [];
          copyDepenseList = [];
        });
      }
    });
  }

  SingleChildScrollView _fournisseuMove(String droit) {
    return SingleChildScrollView(
      controller: ScrollController(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SingleChildScrollView(
            controller: ScrollController(),
            scrollDirection: Axis.horizontal,
            child: Container(
              child: DataTable(
                  columnSpacing: 20,
                  headingTextStyle: TextStyle(
                    color: Color(0xFF26345d),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  horizontalMargin: 10,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white)),
                  columns: [
                    DataColumn(
                      label: Container(
                          child: Row(
                        children: [
                          Text("Date"),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                copyDepenseList = depenseList;
                                agentSearch = false;
                                etatSearch = false;
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
                                copyDepenseList = depenseList;
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
                  rows: copyDepenseList!
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
                            DataCell(int.parse(e.etat) == 0
                                ? Row(
                                    children: [
                                      !acces.contains(droit.toUpperCase())
                                          ? MaterialButton(
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
                                                        .then((value) =>
                                                            getDepenseListe(
                                                                end.text,
                                                                seach.text,
                                                                true,
                                                                true));
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Text(''),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          AlertBox()
                                              .showAlertDialod(
                                                  context,
                                                  int.parse(e.id_dep),
                                                  'Voulez-vous supprimer la depense?',
                                                  'depense')
                                              .then((value) {
                                            if (int.parse(value) == -1) {
                                              ConfirmBox().showAlert(
                                                  context,
                                                  'Impossible de supprimer. Réessayer encore',
                                                  false);
                                            } else if (int.parse(value) == 1) {
                                              ConfirmBox()
                                                  .showAlert(
                                                      context,
                                                      'Suppression reussi',
                                                      true)
                                                  .then((value) {
                                                getDepenseListe(end.text,
                                                    seach.text, true, true);
                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : Icon(Icons.check, color: Colors.green)),
                          ],
                        ),
                      )
                      .toList()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Dialog(
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    color: Color(0xFF26345d),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                "Liste des depenses",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close),
                              alignment: Alignment.bottomRight,
                              iconSize: 25,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  is_loading
                      ? Expanded(
                          child: Center(child: CircularProgressIndicator()))
                      : Container(
                          height: MediaQuery.of(context).size.height - 155,
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: Column(children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(bottom: 10, left: 5),
                                      width: 400,
                                      child: TextField(
                                        controller: seachInput,
                                        decoration: InputDecoration(
                                            suffixIcon: MaterialButton(
                                              color: Color(0xFF26345d),
                                              height: 55,
                                              onPressed: () {
                                                if (seachInput.text.isEmpty) {
                                                  if (mounted) {
                                                    setState(() {
                                                      seach.text = "";
                                                    });
                                                  }
                                                } else {
                                                  end.text = '0';
                                                  if (dateSearch) {
                                                    if (mounted) {
                                                      setState(() {
                                                        seach.text =
                                                            "AND d.Date_dep LIKE '%${seachInput
                                                                    .text}%'";
                                                      });
                                                    }
                                                  } else {
                                                    if (mounted) {
                                                      setState(() {
                                                        seach.text =
                                                            "AND u.Nom LIKE '%${seachInput
                                                                    .text}%'";
                                                      });
                                                    }
                                                  }
                                                }
                                                getDepenseListe(end.text,
                                                    seach.text, true, true);
                                              },
                                              child: Text(
                                                'OK',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.all(10),
                                            hintText: dateSearch
                                                ? "Rechercher par date..."
                                                : "Rechercher par agent..."),
                                        onChanged: (seach) {
                                          setState(() {
                                            if (dateSearch) {
                                              copyDepenseList = depenseList!
                                                  .where((element) => (element
                                                      .date_dep
                                                      .toLowerCase()
                                                      .contains(
                                                          seach.toLowerCase())))
                                                  .toList();
                                            } else {
                                              copyDepenseList = depenseList!
                                                  .where((element) => (element
                                                      .id_user
                                                      .toLowerCase()
                                                      .contains(
                                                          seach.toLowerCase())))
                                                  .toList();
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 10, right: 5, bottom: 10),
                                      child: MaterialButton(
                                          color: Colors.green,
                                          height: 50,
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return SaveDepense();
                                                }).then((value) {
                                              setState(() {
                                                getDepenseListe(end.text,
                                                    seach.text, true, true);
                                              });
                                            });
                                          },
                                          child: Text('Nouvelle depense',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ))),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                height: 595,
                                child: is_empty
                                    ? Center(
                                        child: Text(
                                          'Aucune donnée trouvée',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                      )
                                    : _fournisseuMove(
                                        state.user!.droit.toString()),
                              ),
                            ]),
                          ),
                        ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      width: 300,
                      child: BootstrapContainer(
                          fluid: true,
                          padding: EdgeInsets.only(top: 10),
                          children: [
                            BootstrapRow(children: [
                              BootstrapCol(
                                  sizes: 'col-12',
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      MaterialButton(
                                        height: 40,
                                        color:
                                            endPred ? Colors.grey : Colors.red,
                                        onPressed: () {
                                          endPred
                                              ? null
                                              : getDepenseListe(end.text,
                                                  seach.text, false, false);
                                        },
                                        child: Text("Précédent",
                                            style: TextStyle(
                                                color: endPred
                                                    ? Colors.black
                                                    : Colors.white)),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      MaterialButton(
                                        height: 40,
                                        color: endSuiv
                                            ? Colors.grey
                                            : Colors.green,
                                        onPressed: () {
                                          endSuiv
                                              ? null
                                              : getDepenseListe(end.text,
                                                  seach.text, true, false);
                                        },
                                        child: Text(
                                          "Suivant",
                                          style: TextStyle(
                                              color: endSuiv
                                                  ? Colors.black
                                                  : Colors.white),
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
            ),
          );
        });
  }
}

// virement bancaire
class VirementBank extends StatefulWidget {
  const VirementBank({Key? key}) : super(key: key);

  @override
  State<VirementBank> createState() => _VirementBankState();
}

class _VirementBankState extends State<VirementBank> {
  TextEditingController? nom;
  TextEditingController? numCompte;
  TextEditingController? nomBank;
  TextEditingController? agent;
  TextEditingController? somme;
  TextEditingController? dateVir;
  TextEditingController? desc;
  DateTime _date = DateTime.now();
  GlobalKey<FormState>? _vireFormKey;
  bool _isDateSelect = false;
  @override
  void initState() {
    super.initState();
    nom = TextEditingController();
    numCompte = TextEditingController();
    nomBank = TextEditingController();
    agent = TextEditingController();
    somme = TextEditingController();
    dateVir = TextEditingController();
    desc = TextEditingController();
    _vireFormKey = GlobalKey<FormState>();
    _isDateSelect = false;
  }

  _handleDate() async {
    setState(() {
      _isDateSelect = false;
    });

    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100));

    if (date != _date) {
      setState(() {
        _date = date!;
        dateVir!.text = date.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Dialog(
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            child: Container(
              height: 630,
              width: 725,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    color: Color(0xFF26345d),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                "Virement bancaire",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close),
                              alignment: Alignment.bottomRight,
                              iconSize: 25,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 540,
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Form(
                            key: _vireFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Nom du compte",
                                                false,
                                                nom!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          ),
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Numero compte",
                                                false,
                                                numCompte!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Nom de Banque",
                                                false,
                                                nomBank!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          ),
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Agent",
                                                false,
                                                agent!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Somme",
                                                false,
                                                somme!,
                                                TextInputType.text,
                                                true,
                                                1,
                                                0,
                                                true),
                                          ),
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            margin: EdgeInsets.only(top: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Date: ',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextFormField(
                                                  readOnly: true,
                                                  onTap: _handleDate,
                                                  controller: dateVir,
                                                  onSaved: (String? value) {},
                                                  decoration: InputDecoration(
                                                    hintText: "Date",
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: _isDateSelect
                                                                ? Color(
                                                                    0xFFDA0F0F)
                                                                : Color(
                                                                    0xFF171817),
                                                            width: 1)),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: _isDateSelect
                                                                ? Color(
                                                                    0xFFDA0F0F)
                                                                : Color(
                                                                    0xFF171817),
                                                            width: 1)),
                                                  ),
                                                ),
                                                _isDateSelect
                                                    ? Text(
                                                        'Veuillez choisir une date',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 13))
                                                    : Text(''),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 700,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Description",
                                                false,
                                                desc!,
                                                TextInputType.text,
                                                false,
                                                2,
                                                25,
                                                false),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 3, left: 3),
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (!_vireFormKey!.currentState!
                                            .validate()) {
                                          return;
                                        } else {
                                          if (dateVir!.text.isEmpty) {
                                            setState(() {
                                              _isDateSelect = true;
                                            });
                                          } else {
                                            loader(context);
                                            Services.addVirement(
                                              nom!.text,
                                              numCompte!.text,
                                              nomBank!.text,
                                              agent!.text,
                                              somme!.text,
                                              dateVir!.text,
                                              state.user!.id.toString(),
                                              desc!.text,
                                              'vire',
                                            ).then((value) {
                                              Loader.hide();
                                              if (int.parse(value) == 0) {
                                                ConfirmBox().showAlert(
                                                    context,
                                                    'Impossible d\'enregistrer. réessayer encore',
                                                    false);
                                              } else if (int.parse(value) < 0) {
                                                ConfirmBox().showAlert(
                                                    context,
                                                    'Erreur de connexion',
                                                    false);
                                              }
                                              if (int.parse(value) == 1) {
                                                ConfirmBox()
                                                    .showAlert(
                                                        context,
                                                        'Virement enregistré avec succès.',
                                                        true)
                                                    .then((value) {
                                                  nom!.text = "";
                                                  numCompte!.text = "";
                                                  nomBank!.text = "";
                                                  agent!.text = "";
                                                  somme!.text = "";
                                                  dateVir!.text = "";
                                                });
                                              }
                                            });
                                          }
                                        }
                                      },
                                      minWidth: 200,
                                      height: 60,
                                      color: Color(0xFF26345d),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(
                                        "Valider",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
// retrait bancaire

class RetraitBank extends StatefulWidget {
  const RetraitBank({Key? key}) : super(key: key);

  @override
  State<RetraitBank> createState() => _RetraitBankState();
}

class _RetraitBankState extends State<RetraitBank> {
  TextEditingController? nom;
  TextEditingController? numCompte;
  TextEditingController? nomBank;
  TextEditingController? agent;
  TextEditingController? somme;
  TextEditingController? factNum;
  TextEditingController? desc;
  GlobalKey<FormState>? _vireFormKey;
  bool _isDateSelect = false;
  @override
  void initState() {
    super.initState();
    nom = TextEditingController();
    numCompte = TextEditingController();
    nomBank = TextEditingController();
    agent = TextEditingController();
    somme = TextEditingController();
    factNum = TextEditingController();
    desc = TextEditingController();
    _vireFormKey = GlobalKey<FormState>();
    _isDateSelect = false;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Dialog(
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            child: Container(
              height: 630,
              width: 725,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    color: Color(0xFF26345d),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                "Retrait bancaire",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close),
                              alignment: Alignment.bottomRight,
                              iconSize: 25,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 540,
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Form(
                            key: _vireFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Nom du compte",
                                                false,
                                                nom!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          ),
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Numéro compte",
                                                false,
                                                numCompte!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Nom de Banque",
                                                false,
                                                nomBank!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          ),
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Agent",
                                                false,
                                                agent!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Somme",
                                                false,
                                                somme!,
                                                TextInputType.text,
                                                true,
                                                1,
                                                0,
                                                true),
                                          ),
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            margin: EdgeInsets.only(top: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Numéro de facture: ',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextFormField(
                                                  controller: factNum,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _isDateSelect = false;
                                                    });
                                                  },
                                                  onSaved: (String? value) {},
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Numéro de facture...",
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: _isDateSelect
                                                                ? Color(
                                                                    0xFFDA0F0F)
                                                                : Color(
                                                                    0xFF171817),
                                                            width: 1)),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: _isDateSelect
                                                                ? Color(
                                                                    0xFFDA0F0F)
                                                                : Color(
                                                                    0xFF171817),
                                                            width: 1)),
                                                  ),
                                                ),
                                                _isDateSelect
                                                    ? Text(
                                                        'Veuillez choisir le numéro de facture',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 13))
                                                    : Text(''),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 700,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Description",
                                                false,
                                                desc!,
                                                TextInputType.text,
                                                false,
                                                2,
                                                25,
                                                false),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 3, left: 3),
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (!_vireFormKey!.currentState!
                                            .validate()) {
                                          return;
                                        } else {
                                          if (factNum!.text.isEmpty) {
                                            setState(() {
                                              _isDateSelect = true;
                                            });
                                          } else {
                                            if (factNum!.text.split("").length >
                                                    12 ||
                                                factNum!.text.split("")[2] !=
                                                    'F' ||
                                                factNum!.text
                                                        .split("F")
                                                        .length !=
                                                    2 ||
                                                factNum!.text
                                                        .split("F")[0]
                                                        .split("")
                                                        .length !=
                                                    2 ||
                                                factNum!.text
                                                        .split("F")[1]
                                                        .split("")
                                                        .length !=
                                                    6) {
                                              ConfirmBox().showAlert(
                                                  context,
                                                  "Numéro de facture incorrect",
                                                  false);
                                            } else {
                                              loader(context);
                                              Services.addVirement(
                                                nom!.text,
                                                numCompte!.text,
                                                nomBank!.text,
                                                agent!.text,
                                                somme!.text,
                                                factNum!.text,
                                                state.user!.id.toString(),
                                                desc!.text,
                                                'ret',
                                              ).then((value) {
                                                print(value);
                                                Loader.hide();
                                                if (int.parse(value) == 0) {
                                                  ConfirmBox().showAlert(
                                                      context,
                                                      'Impossible d\'enregistrer. réessayer encore',
                                                      false);
                                                } else if (int.parse(value) <
                                                    0) {
                                                  ConfirmBox().showAlert(
                                                      context,
                                                      'Erreur de connexion',
                                                      false);
                                                } else if (int.parse(value) ==
                                                    2) {
                                                  ConfirmBox().showAlert(
                                                      context,
                                                      'Aucun retrait trouvé pour cette facture',
                                                      false);
                                                }
                                                if (int.parse(value) == 1) {
                                                  ConfirmBox()
                                                      .showAlert(
                                                          context,
                                                          'Retrait enregistré avec succès.',
                                                          true)
                                                      .then((value) {
                                                    nom!.text = "";
                                                    numCompte!.text = "";
                                                    nomBank!.text = "";
                                                    agent!.text = "";
                                                    somme!.text = "";
                                                    factNum!.text = "";
                                                  });
                                                }
                                              });
                                            }
                                          }
                                        }
                                      },
                                      minWidth: 200,
                                      height: 60,
                                      color: Color(0xFF26345d),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(
                                        "Valider",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

// Creer un compte de versement

class ComptVersement extends StatefulWidget {
  const ComptVersement({Key? key}) : super(key: key);

  @override
  State<ComptVersement> createState() => _ComptVersementState();
}

class _ComptVersementState extends State<ComptVersement> {
  TextEditingController? client;
  TextEditingController? user;
  List<String> listClient = [];
  GlobalKey<FormState>? _verseFormKey;
  bool is_emptyClient = true;
  @override
  void initState() {
    super.initState();
    is_emptyClient = true;
    listClient = [];
    user = TextEditingController();
    client = TextEditingController();
    _verseFormKey = GlobalKey<FormState>();
    getClientList();
  }

  getClientList() {
    Services.getClients().then((value) {
      if (int.parse(value.map((e) => e.id_client).toList()[0]) == 0) {
        ConfirmBox().showAlert(context, 'Aucun client trouvé', false);
        setState(() {
          listClient = [];
        });
      } else if (int.parse(value.map((e) => e.id_client).toList()[0]) > 0) {
        setState(() {
          listClient = value
              .map((e) => '${e.id_client}=>${e.nom_complet_client}')
              .toList();
        });
      } else if (int.parse(value.map((e) => e.id_client).toList()[0]) < 0) {
        listClient = [];
        ConfirmBox().showAlert(context, 'Erreur de connexion', false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          user!.text = state.user!.id.toString();
          return Dialog(
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            child: Container(
              height: 230,
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    color: Color(0xFF26345d),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                "Création de compte de versement",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close),
                              alignment: Alignment.bottomRight,
                              iconSize: 25,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Form(
                            key: _verseFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 370,
                                            child: MyFunction().dropdown(
                                                'Client',
                                                listClient,
                                                client,
                                                is_emptyClient,
                                                'ajout',
                                                'none'),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 30),
                                            child: MaterialButton(
                                              onPressed: () {
                                                if (!_verseFormKey!
                                                    .currentState!
                                                    .validate()) {
                                                  return;
                                                } else {
                                                  if (client!.text.isEmpty) {
                                                    setState(() {
                                                      is_emptyClient = false;
                                                    });
                                                  } else {
                                                    Services.compteVersement(
                                                      user!.text,
                                                      client!.text
                                                          .split('=>')[0],
                                                    ).then((value) {
                                                      if (int.parse(value) ==
                                                          0) {
                                                        ConfirmBox().showAlert(
                                                            context,
                                                            'Impossible de créer le versement. réessayer!!',
                                                            false);
                                                      } else if (int.parse(
                                                              value) <
                                                          0) {
                                                        ConfirmBox().showAlert(
                                                            context,
                                                            'Erreur de connexion',
                                                            false);
                                                      } else if (int.parse(
                                                              value) ==
                                                          97) {
                                                        ConfirmBox().showAlert(
                                                            context,
                                                            'Cet client a deja un versement en cours',
                                                            false);
                                                      } else if (int.parse(
                                                              value) ==
                                                          1) {
                                                        ConfirmBox().showAlert(
                                                            context,
                                                            'Versement crée avec succès.',
                                                            true);
                                                      }
                                                    });
                                                    setState(() {
                                                      is_emptyClient = true;
                                                    });
                                                  }
                                                }
                                              },
                                              minWidth: 100,
                                              height: 56,
                                              color: Color(0xFF26345d),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              child: Text(
                                                "Valider",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

// versement d'argent

class Versement extends StatefulWidget {
  final String id_cpt;
  const Versement({
    Key? key,
    required this.id_cpt,
  }) : super(key: key);

  @override
  State<Versement> createState() => _VersementState();
}

class _VersementState extends State<Versement> {
  TextEditingController? nom;
  TextEditingController? tel;
  TextEditingController? cnib;
  TextEditingController? somme;
  TextEditingController? desc;
  TextEditingController? user;
  GlobalKey<FormState>? _verseFormKey;
  @override
  void initState() {
    super.initState();
    nom = TextEditingController();
    tel = TextEditingController();
    cnib = TextEditingController();
    somme = TextEditingController();
    desc = TextEditingController();
    user = TextEditingController();
    _verseFormKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          user!.text = state.user!.id.toString();
          return Dialog(
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            child: Container(
              height: 370,
              width: 725,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    color: Color(0xFF26345d),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                "Versement d'argent",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close),
                              alignment: Alignment.bottomRight,
                              iconSize: 25,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Form(
                            key: _verseFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Deposant",
                                                false,
                                                nom!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          ),
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Telephone",
                                                false,
                                                tel!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Montant",
                                                false,
                                                somme!,
                                                TextInputType.number,
                                                true,
                                                1,
                                                0,
                                                true),
                                          ),
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Cnib",
                                                false,
                                                cnib!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 3, left: 3),
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (!_verseFormKey!.currentState!
                                            .validate()) {
                                          return;
                                        } else {
                                          loader(context);
                                          Services.addVersement(
                                                  nom!.text,
                                                  tel!.text,
                                                  cnib!.text,
                                                  somme!.text,
                                                  user!.text,
                                                  widget.id_cpt)
                                              .then((value) {
                                            Loader.hide();
                                            if (int.parse(value) == 0) {
                                              ConfirmBox().showAlert(
                                                  context,
                                                  'Impossible d\'enregistrer. réessayer encore.',
                                                  false);
                                            } else if (int.parse(value) < 0) {
                                              ConfirmBox().showAlert(context,
                                                  'Erreur de connexion', false);
                                            }
                                            if (int.parse(value) == 1) {
                                              ConfirmBox()
                                                  .showAlert(
                                                      context,
                                                      'Versement enregistré avec succès.',
                                                      true)
                                                  .then((value) {
                                                nom!.text = '';
                                                tel!.text = '';
                                                cnib!.text = '';
                                                somme!.text = '';
                                                user!.text = '';
                                              });
                                            }
                                          });
                                        }
                                      },
                                      minWidth: 200,
                                      height: 60,
                                      color: Color(0xFF26345d),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(
                                        "Valider",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
