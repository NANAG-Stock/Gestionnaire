// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unused_field, prefer_final_fields, unused_local_variable

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/alert_box_2.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/Blocks/text_input.dart';
import 'package:application_principal/Screens/connection.dart';
import 'package:application_principal/database/categorieModel.dart';
import 'package:application_principal/database/product.dart';
import 'package:application_principal/database/services.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MagaProduits extends StatefulWidget {
  const MagaProduits({Key? key}) : super(key: key);

  @override
  _MagaProduitsState createState() => _MagaProduitsState();
}

class _MagaProduitsState extends State<MagaProduits> {
  // categorie

  TextEditingController? _catName;
  GlobalKey<FormState>? _catFormKey;
  List<CategorieModel>? _listCategorie;
  CategorieModel? categorieData;
  bool _catLoading = true;

  // fin categorie
  // produits
  TextEditingController? categorie;
  TextEditingController? description;
  TextEditingController? designation;
  TextEditingController? promo;
  TextEditingController? user;
  TextEditingController? prix;
  List<Product>? productList;
  Product? prod;
  bool _isEmptyCategorie = true;
  bool _isEmptyFournisseur = true;
  GlobalKey<FormState>? _formKey;
  List<String> listCategorie = [];

  bool _prodLoading = true;
  bool _isEmptyProd = true;
  bool _isEmptyCat = true;
  final controller = ScrollController();
  final controller1 = ScrollController();
// fin produits
  @override
  void initState() {
    // categorie
    _catName = TextEditingController();
    _catFormKey = GlobalKey<FormState>();
    _listCategorie = [];
    _getCategorie();
    _catLoading = true;
    // //////
    bool isEmptyCategorie = true;
    bool isEmptyFournisseur = true;
    bool prodLoading = true;
    bool isEmptyProd = true;
    bool isEmptyCat = true;
    listCategorie = [];
    productList = [];
    categorie = TextEditingController();
    description = TextEditingController();
    designation = TextEditingController();
    promo = TextEditingController();
    user = TextEditingController();
    prix = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _getCategorieList();
    getProdList();

    super.initState();
  }

// categorie ******************************
// ajouter une categorie
  _addCategorie() {
    Services.addCategorie(_catName!.text, user!.text).then((value) {
      if (int.parse(value) == 1) {
        setState(() {
          _getCategorieList();
          getProdList();
          _getCategorie();
          _catName!.text = "";
          ConfirmBox().showAlert(
              context, "La categorie a ete ajouter avec success", true);
        });
        // print("bien ajouter");
      } else if (int.parse(value) == 0) {
        ConfirmBox().showAlert(context, "Cette categorie existe deja", false);
      } else if (int.parse(value) == -4) {
        ConfirmBox().showAlert(
            context, "Ajout refuser. Veuillez revoir le nom.", false);
      } else {
        ConfirmBox()
            .showAlert(context, "Impossible de se connecter au serveur", false);
      }
    });
  }

// Recuperer une categorie
  _getCategorie() {
    Services.getCategorie().then((value) {
      if (int.parse(value.map((e) => e.catId).toList()[0]) == 0) {
        setState(() {
          _listCategorie = [];
          _catLoading = false;
        });
      } else {
        if (int.parse(value.map((e) => e.catId).toList()[0]) > 0) {
          setState(() {
            _listCategorie = value;
            _catLoading = false;
          });
        } else {
          setState(() {
            _listCategorie = [];
          });
          ConfirmBox().showAlert(context, "Erreur de connexion", false);
        }
      }
    });
  }

  // /////////////////////////////////////////////////////////////
  bool checkprod(List<Product> proList, String salai) {
    int temoin = 0;
    for (int i = 0; i < proList.length; i++) {
      if (proList[i].id_cat == salai) {
        temoin = 1;
        break;
      }
    }
    return temoin == 0 ? false : true;
  }

  void ajoutProduct() {
    Services.addProd(
            designation!.text.toString(),
            categorie!.text.toString(),
            description!.text.toString(),
            prix!.text.toString(),
            promo!.text.toString(),
            user!.text)
        .then((value) {
      if (int.parse(value) == -1) {
        ConfirmBox().showAlert(
            context, "Impossible d'ajouter cet produits. Reassayer", false);
      } else if (int.parse(value) == -2) {
        ConfirmBox().showAlert(context, "Erreur de connexion", false);
      } else if (int.parse(value) == 0) {
        ConfirmBox().showAlert(context, "Cet Produit existe deja", false);
      } else {
        ConfirmBox()
            .showAlert(context, "Le produit a ete ajoute avec success", true)
            .then((value) {
          setState(() {
            designation!.text = "";
            categorie!.text = "";
            description!.text = "";
            prix!.text = "";
            promo!.text = "";
          });
        });
        setState(() {
          getProdList();
        });
      }
    });
  }

  void getProdList() {
    Services.getProdList().then((value) {
      if (int.parse(value.map((e) => e.id_prod).toList()[0]) == -1 ||
          int.parse(value.map((e) => e.id_prod).toList()[0]) == -2) {
        setState(() {
          listCategorie = [];
          productList = [];
        });
        ConfirmBox().showAlert(context, "Erreur de connexion", false);
      } else {
        if (int.parse(value.map((e) => e.id_prod).toList()[0]) == -3) {
          setState(() {
            productList = [];
          });
        } else {
          setState(() {
            _isEmptyProd = false;
            productList = value;
          });
        }
        setState(() {
          _prodLoading = false;
        });
      }
    });
  }

  // get Categories List

  _getCategorieList() {
    Services.getCategorie().then((value) {
      if (int.parse(value.map((e) => e.catId).toList()[0]) > 0) {
        setState(() {
          listCategorie = value.map((e) => e.catName).toList();
        });
      } else {
        setState(() {
          listCategorie = [];
        });
      }
    });
  }

  // categorie ********************************************

  SingleChildScrollView get _catBody {
    return SingleChildScrollView(
      controller: controller1,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Container(
          child: DataTable(
            columnSpacing: 50,
            headingTextStyle: TextStyle(
              color: Color(0xFF26345d),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            horizontalMargin: 30,
            decoration: BoxDecoration(
              border: Border.all(width: 1),
            ),
            // ignore: prefer_const_literals_to_create_immutables
            columns: [
              DataColumn(
                label: Container(child: Text("Nom")),
              ),
              DataColumn(
                label: Text("Date"),
              ),
              DataColumn(
                label: Text("Action"),
              ),
            ],
            rows: _listCategorie!
                .map(
                  (e) => DataRow(cells: [
                    DataCell(
                      Text(e.catName.toString()),
                    ),
                    DataCell(
                      Text(e.catDate),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit_location_alt,
                              color: Color(0xFFEEBB12),
                            ),
                            onPressed: () {
                              categorieData = e;
                              if (checkprod(productList!, e.catName)) {
                                ConfirmBox().showAlert(
                                    context,
                                    "Certain produits ont déjà ce catégorie. veuillez modifier leur catégorie d'abord ",
                                    false);
                              } else {
                                setState(() {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Align(
                                          child: CatUpdateAlert(
                                            selctedCat: categorieData!,
                                          ),
                                        );
                                      }).then((value) {
                                    if (int.parse(value) == 1) {
                                      ConfirmBox()
                                          .showAlert(
                                              context,
                                              "La categorie a ete modifiee avec success",
                                              true)
                                          .then((value) {
                                        _getCategorie();
                                        getProdList();
                                      });
                                    }
                                  });
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              categorieData = e;
                              if (checkprod(productList!, e.catName)) {
                                ConfirmBox().showAlert(
                                    context,
                                    "Certain produits ont déjà ce catégorie. veuillez modifier leur catégorie d'abord ",
                                    false);
                              } else {
                                String content =
                                    "Voulez-vous réellement supprimer cette catégorie?";
                                AlertBox()
                                    .showAlertDialod(
                                        context,
                                        int.parse(categorieData!.catId),
                                        content,
                                        'categorie')
                                    .then((value) {
                                  if (int.parse(value) != 2) {
                                    setState(() {
                                      _getCategorie();
                                      if (int.parse(value) == 1) {
                                        ConfirmBox()
                                            .showAlert(
                                                context,
                                                "La categorie a ete supprimee avec success",
                                                true)
                                            .then((value) =>
                                                Navigator.pushNamed(
                                                    context, 'produits'));
                                      }
                                    });
                                  }
                                });
                              }
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
      ),
    );
  }

  /////////////////////////////////////////////////////

  SingleChildScrollView get _dataBody {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: DataTable(
          columnSpacing: 75,
          headingTextStyle: TextStyle(
            color: Color(0xFF26345d),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          horizontalMargin: 30,
          decoration: BoxDecoration(
            border: Border.all(width: 1),
          ),
          // ignore: prefer_const_literals_to_create_immutables
          columns: [
            DataColumn(
              label: Container(child: Text("ID")),
            ),
            DataColumn(
              label: Text("Désignation"),
            ),
            DataColumn(
              label: Text("Catégorie"),
            ),
            DataColumn(
              label: Text("Prix"),
            ),
            DataColumn(
              label: Text("Date"),
            ),
            DataColumn(
              label: Text("Stock"),
            ),
            DataColumn(
              label: Text("Action"),
            ),
          ],
          rows: productList!
              .map(
                (e) => DataRow(cells: [
                  DataCell(
                    Text(e.id_prod.toString()),
                  ),
                  DataCell(
                    Text(e.designation),
                  ),
                  DataCell(
                    Text(e.id_cat),
                  ),
                  DataCell(
                    Text(e.prix),
                  ),
                  DataCell(
                    Text(e.prod_date),
                  ),
                  DataCell(
                    Text(
                      double.parse(e.stock).toStringAsFixed(2),
                      style: TextStyle(
                          color: double.parse(e.stock) > 0
                              ? Colors.green
                              : Colors.red),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit_location_alt,
                            color: Color(0xFFEEBB12),
                          ),
                          onPressed: () {
                            prod = e;

                            setState(() {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return NotifyAlert(
                                      prod: prod!,
                                      listCategorie: listCategorie,
                                    );
                                  }).then((value) {
                                setState(() {
                                  getProdList();
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
                            prod = e;
                            String content =
                                "Voulez-vous reellement supprimer cet produit?";
                            AlertBox()
                                .showAlertDialod(
                                    context,
                                    int.parse(prod!.id_prod),
                                    content,
                                    'produits')
                                .then((value) {
                              if (int.parse(value) == 1) {
                                setState(() {
                                  getProdList();
                                  ConfirmBox().showAlert(
                                      context,
                                      "Le produit a ete supprimer avec success",
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
          user!.text = state.user!.id.toString();
          return Scaffold(
              body: SafeArea(
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
                                    child: WindowTitleBarBox(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    child: Center(
                                                      child: Text(
                                                        "Société Pouloumde Metal SARL",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: Center(
                                                      child: Text(
                                                        "",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                          Text(
                                                            state
                                                                .user!.username,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 17),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          MaterialButton(
                                                            color: Colors.red,
                                                            textColor:
                                                                Colors.white,
                                                            onPressed: () {
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Connection()));
                                                            },
                                                            child: Row(
                                                              // ignore: prefer_const_literals_to_create_immutables
                                                              children: [
                                                                Text(
                                                                    ' Deconnexion'),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              MinimizeWindowButton(
                                                colors: WindowButtonColors(
                                                    iconNormal: Colors.white,
                                                    mouseOver:
                                                        Color(0xff101c3a)),
                                              ),
                                              CloseWindowButton(
                                                colors: WindowButtonColors(
                                                    iconNormal: Colors.white,
                                                    mouseOver:
                                                        Color(0xffff2926)),
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
                          ),
                          Expanded(
                            flex: 11,
                            child: Container(
                              margin: EdgeInsets.only(left: 7, top: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: ListView(
                                        controller: ScrollController(),
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 500,
                                                  padding:
                                                      EdgeInsets.only(top: 9),
                                                  child: Form(
                                                    key: _formKey,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          20),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.only(right: 5),
                                                                          child: MyFunction().dropdown(
                                                                              'Categorie',
                                                                              listCategorie,
                                                                              categorie!,
                                                                              _isEmptyCategorie,
                                                                              'ajout',
                                                                              'none'),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: MyFunction().inputFiled(
                                                                            "Designation",
                                                                            false,
                                                                            designation!,
                                                                            TextInputType.text,
                                                                            false,
                                                                            1,
                                                                            0,
                                                                            true),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.only(right: 5),
                                                                          child: MyFunction().inputFiled(
                                                                              "Prix",
                                                                              false,
                                                                              prix!,
                                                                              TextInputType.number,
                                                                              true,
                                                                              1,
                                                                              0,
                                                                              true),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: MyFunction().inputFiled(
                                                                            "Reduction",
                                                                            false,
                                                                            promo!,
                                                                            TextInputType.number,
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
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.only(right: 5),
                                                                          child: MyFunction().inputFiled(
                                                                              "Description",
                                                                              false,
                                                                              description!,
                                                                              TextInputType.text,
                                                                              false,
                                                                              2,
                                                                              25,
                                                                              false),
                                                                        ),
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
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          40),
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 3,
                                                                        left:
                                                                            3),
                                                                child:
                                                                    MaterialButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (!_formKey!
                                                                        .currentState!
                                                                        .validate()) {
                                                                      return;
                                                                    } else {
                                                                      if (categorie!
                                                                          .text
                                                                          .isEmpty) {
                                                                        setState(
                                                                            () {
                                                                          _isEmptyCategorie =
                                                                              false;
                                                                        });
                                                                      } else if (int.parse(prix!
                                                                              .text) <
                                                                          int.parse(
                                                                              promo!.text)) {
                                                                        ConfirmBox().showAlert(
                                                                            context,
                                                                            "Le prix doit tre supérieur à la réduction",
                                                                            false);
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          _isEmptyCategorie =
                                                                              true;
                                                                        });
                                                                        ajoutProduct();
                                                                      }
                                                                    }
                                                                  },
                                                                  minWidth: 200,
                                                                  height: 60,
                                                                  color: Color(
                                                                      0xFF26345d),
                                                                  elevation: 0,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(2),
                                                                  ),
                                                                  child: Text(
                                                                    "Ajouter",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 300,
                                                  child: !_prodLoading
                                                      ? ImprovedScrolling(
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
                                                          child: _dataBody,
                                                        )
                                                      : Center(
                                                          child: SizedBox(
                                                              height: 50,
                                                              width: 50,
                                                              child:
                                                                  CircularProgressIndicator()),
                                                        ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      height: 800,
                                      width: 60,
                                      color: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      margin: EdgeInsets.only(
                                        left: 7,
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 80,
                                            margin: EdgeInsets.only(top: 10),
                                            child: Form(
                                              key: _catFormKey,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: _catName!,
                                                validator: (String? value) {
                                                  if (value!.isEmpty) {
                                                    return "Veuillez remplire le champ ";
                                                  }
                                                  return '';
                                                },
                                                onSaved: (String? value) {},
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Ajouter une categorie",
                                                  suffixIcon: MaterialButton(
                                                    onPressed: () {
                                                      if (!_catFormKey!
                                                          .currentState!
                                                          .validate()) {
                                                        return;
                                                      } else {
                                                        _addCategorie();
                                                      }
                                                    },
                                                    height: 60,
                                                    color: Color(0xFF26345d),
                                                    elevation: 0,
                                                    child: Text(
                                                      "Ajouter",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF1696D1))),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFF1696D1))),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height: 640,
                                              child: !_catLoading
                                                  ? ImprovedScrolling(
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
                                                          controller1,
                                                      child: Container(
                                                          child: _catBody),
                                                    )
                                                  : Center(
                                                      child: SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    )),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ));
        });
  }
}
