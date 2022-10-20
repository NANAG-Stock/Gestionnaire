// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, duplicate_ignore, non_constant_identifier_names, body_might_complete_normally_nullable

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/database/fournisseur_prod.dart';
import 'package:application_principal/database/product.dart';
import 'package:application_principal/database/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Secret2Stock extends StatefulWidget {
  const Secret2Stock({Key? key}) : super(key: key);

  @override
  _Secret2StockState createState() => _Secret2StockState();
}

class _Secret2StockState extends State<Secret2Stock> {
  List<Product>? productList;
  List<Product>? copyProductList;

  List<FournisseurProduct>? fourProductList;
  List<FournisseurProduct>? copyFourProductList;

  bool _prodLoading = false;
  bool catSearch = true;
  bool prodSearch = false;
  TextEditingController val = TextEditingController();
  int rupNumber = 0;
  TextEditingController end = TextEditingController();
  TextEditingController seach = TextEditingController();
  TextEditingController seachInput = TextEditingController();
  bool endPred = false;
  bool endSuiv = false;
  bool is_stock = true;
  bool is_loading = true;
  bool is_empty = false;

  final controller = ScrollController();
  @override
  void initState() {
    val.text = '0';
    productList = [];
    fourProductList = [];
    copyFourProductList = [];
    _prodLoading = false;
    seach.text = '';
    end.text = "1";
    getProdList(end.text, seach.text, true, true);
    getFourProdList(end.text, seach.text, true, true);

    super.initState();
  }

  void getProdList(String ends, String cherche, bool isfront, bool same) {
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
          end.text = '1';
        }
      }
    }

    String limit = "LIMIT ${end.text},12";
    setState(() {
      _prodLoading = true;
    });
    Services.getProdList2(limit, cherche).then((value) {
      setState(() {
        is_loading = false;
      });
      setState(() {
        productList = [];
        copyProductList = [];
      });
      if (int.parse(value.map((e) => e.id_prod).toList()[0]) == -1 ||
          int.parse(value.map((e) => e.id_prod).toList()[0]) == -2) {
        setState(() {
          productList = [];
          is_empty = true;
        });
        ConfirmBox().showAlert(context, "Erreur de connexion", false);
      } else {
        if (int.parse(value.map((e) => e.id_prod).toList()[0]) == -3) {
          setState(() {
            productList = [];
            is_empty = true;
          });
        } else {
          setState(() {
            productList = value;
            copyProductList = value;
            value.length < 12 ? endSuiv = true : endSuiv = false;
            getruptureProd(productList!);
          });
        }
      }
    }).then((value) => setState(() {
          _prodLoading = false;
        }));
  }

  // Recuperation de la liste des produits
  void getFourProdList(String ends, String cherche, bool isfront, bool same) {
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
          end.text = '1';
        }
      }
    }

    String limit = "LIMIT ${end.text},12";
    setState(() {
      _prodLoading = true;
    });
    Services.getFourProdList(limit, cherche).then((value) {
      setState(() {
        fourProductList = [];
        copyFourProductList = [];
        is_loading = false;
      });
      if (int.parse(value.map((e) => e.id_four).toList()[0]) == -1 ||
          int.parse(value.map((e) => e.id_four).toList()[0]) == -2) {
        setState(() {
          fourProductList = [];
          is_empty = true;
        });
        ConfirmBox().showAlert(context, "Erreur de connexion", false);
      } else {
        if (int.parse(value.map((e) => e.id_four).toList()[0]) == -3) {
          setState(() {
            fourProductList = [];
            is_empty = true;
          });
        } else {
          setState(() {
            fourProductList = value;
            copyFourProductList = value;
            value.length < 12 ? endSuiv = true : endSuiv = false;
          });
        }
      }
    }).then((value) => setState(() {
          _prodLoading = false;
        }));
  }

  void getruptureProd(List<Product> listProduct) {
    int rptProd = listProduct.isEmpty
        ? 0
        : listProduct
            .where((element) => double.parse(element.stock.toString()) <= 20)
            .toList()
            .length;
    setState(() {
      rupNumber = rptProd;
    });
  }

  // fonction pour modification des quantites des produits
  Widget _updStock(Product e, TextEditingController msg) {
    GlobalKey<FormState> formKey = GlobalKey();
    TextEditingController val = TextEditingController();
    val.text = e.stock;

    return Container(
      width: 150,
      padding: EdgeInsets.all(4),
      child: Form(
        key: formKey,
        child: Row(
          children: [
            Container(
              width: 70,
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9.]'),
                  ),
                ],
                controller: val,
                autofocus: true,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Obligatoire';
                  }
                },
              ),
            ),
            IconButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  } else {
                    Services.updStock(e.id_prod, val.text).then((value) {
                      if (int.parse(value) == 1) {
                        getProdList(end.text, seach.text, true, true);
                        if (mounted) {
                          setState(() {
                            msg.text = '0';
                          });
                        }
                      } else {
                        ConfirmBox().showAlert(
                            context, 'Impossible de modifier', false);
                      }
                    });
                  }
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ))
          ],
        ),
      ),
    );
  }

  final scrollListView = ScrollController();
  SingleChildScrollView get _dataBody {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: is_stock
            ? DataTable(
                columnSpacing: 70,
                headingTextStyle: TextStyle(
                  color: Color(0xFF26345d),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                // ignore: prefer_const_literals_to_create_immutables
                columns: [
                  DataColumn(
                    label: Text("ID"),
                  ),
                  DataColumn(
                    label: Row(
                      children: [
                        Text("Désignation"),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                copyProductList = productList;
                                catSearch = false;
                                prodSearch = true;
                              });
                            },
                            icon: Icon(
                              Icons.filter_list_alt,
                              size: 20,
                              color: prodSearch ? Colors.green : Colors.black,
                            ))
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
                                copyProductList = productList;
                                catSearch = true;
                                prodSearch = false;
                              });
                            },
                            icon: Icon(
                              Icons.filter_list_alt,
                              size: 20,
                              color: catSearch ? Colors.green : Colors.black,
                            ))
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Text("Prix"),
                  ),
                  DataColumn(
                    label: Text("Promo"),
                  ),
                  DataColumn(
                    label: Text("Date"),
                  ),
                  DataColumn(
                    label: Text("Stock"),
                  ),
                ],
                rows: copyProductList!.map((e) {
                  return DataRow(cells: [
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
                      Text('${e.prix} Fcfa'),
                    ),
                    DataCell(
                      Text('${e.promo} Fcfa'),
                    ),
                    DataCell(
                      Text(e.prod_date),
                    ),
                    DataCell(
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onDoubleTap: () {
                            if (mounted) {
                              setState(() {
                                val.text = e.id_prod;
                              });
                            }
                          },
                          child: int.parse(val.text) != int.parse(e.id_prod)
                              ? Container(
                                  width: 50,
                                  child: Text(
                                    double.parse(e.stock).toString(),
                                    style: TextStyle(
                                        color:
                                            double.parse(e.stock.toString()) > 0
                                                ? Colors.green
                                                : Colors.red),
                                  ),
                                )
                              : _updStock(e, val),
                        ),
                      ),
                    ),
                  ]);
                }).toList(),
              )
            : DataTable(
                columnSpacing: 30,
                headingTextStyle: TextStyle(
                  color: Color(0xFF26345d),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                // ignore: prefer_const_literals_to_create_immutables
                columns: [
                  DataColumn(
                    label: Row(
                      children: [
                        Text("Désignation"),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                copyProductList = productList;
                                catSearch = false;
                                prodSearch = true;
                              });
                            },
                            icon: Icon(
                              Icons.filter_list_alt,
                              size: 20,
                              color: prodSearch ? Colors.green : Colors.black,
                            ))
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
                                copyProductList = productList;
                                catSearch = true;
                                prodSearch = false;
                              });
                            },
                            icon: Icon(
                              Icons.filter_list_alt,
                              size: 20,
                              color: catSearch ? Colors.green : Colors.black,
                            ))
                      ],
                    ),
                  ),
                  DataColumn(
                    label: Text("Nom_Four"),
                  ),
                  DataColumn(
                    label: Text("Tel_Four"),
                  ),
                  DataColumn(
                    label: Text("Type_Four"),
                  ),
                  DataColumn(
                    label: Text("Prix_Usine"),
                  ),
                  DataColumn(
                    label: Text("Quantitée"),
                  ),
                  DataColumn(
                    label: Text("Date_com"),
                  ),
                ],
                rows: copyFourProductList!.map((e) {
                  return DataRow(cells: [
                    DataCell(
                      Text(e.designation),
                    ),
                    DataCell(
                      Text(e.categorie),
                    ),
                    DataCell(
                      Text(e.fournisseur),
                    ),
                    DataCell(
                      Text(e.tel_four),
                    ),
                    DataCell(
                      Text(e.type),
                    ),
                    DataCell(
                      Text("${e.prix} FCFA"),
                    ),
                    DataCell(
                      Text(e.quantite),
                    ),
                    DataCell(
                      Text(e.prod_date),
                    ),
                  ]);
                }).toList(),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      color: Colors.white,
                                      margin: EdgeInsets.only(left: 7, top: 8),
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              70,
                                      child: is_loading
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      77,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
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
                                                                                '1';
                                                                            if (catSearch) {
                                                                              if (mounted) {
                                                                                setState(() {
                                                                                  seach.text = "AND cat.Nom_cat LIKE '%${seachInput.text}%'";
                                                                                });
                                                                              }
                                                                            } else {
                                                                              if (mounted) {
                                                                                setState(() {
                                                                                  seach.text = "AND pro.Nom_pro LIKE '%${seachInput.text}%'";
                                                                                });
                                                                              }
                                                                            }
                                                                          }
                                                                          is_stock
                                                                              ? getProdList(end.text, seach.text, true, true)
                                                                              : getFourProdList(end.text, seach.text, true, true);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'OK',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      contentPadding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      hintText: catSearch
                                                                          ? "Rechercher par catégorie..."
                                                                          : "Rechercher par nom du produit..."),
                                                              onChanged:
                                                                  (seach) {
                                                                setState(() {
                                                                  if (is_stock) {
                                                                    if (catSearch) {
                                                                      copyProductList = productList!
                                                                          .where((element) => (element
                                                                              .id_cat
                                                                              .toLowerCase()
                                                                              .contains(seach.toLowerCase())))
                                                                          .toList();
                                                                    } else {
                                                                      copyProductList = productList!
                                                                          .where((element) => (element
                                                                              .designation
                                                                              .toLowerCase()
                                                                              .contains(seach.toLowerCase())))
                                                                          .toList();
                                                                    }
                                                                  } else {
                                                                    if (catSearch) {
                                                                      copyFourProductList = fourProductList!
                                                                          .where((element) => (element
                                                                              .categorie
                                                                              .toLowerCase()
                                                                              .contains(seach.toLowerCase())))
                                                                          .toList();
                                                                    } else {
                                                                      copyFourProductList = fourProductList!
                                                                          .where((element) => (element
                                                                              .designation
                                                                              .toLowerCase()
                                                                              .contains(seach.toLowerCase())))
                                                                          .toList();
                                                                    }
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          is_stock
                                                              ? Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              20),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        'Produits en rupture de stock: ',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                          rupNumber
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.red))
                                                                    ],
                                                                  ))
                                                              : Container(),
                                                        ],
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
                                                            200,
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
                                                                child: _prodLoading
                                                                    ? Center(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              50,
                                                                          width:
                                                                              50,
                                                                          child:
                                                                              CircularProgressIndicator(),
                                                                        ),
                                                                      )
                                                                    : _dataBody,
                                                              ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child:
                                                                MaterialButton(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          20),
                                                              height: 50,
                                                              color: is_stock
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .green,
                                                              onPressed: () {
                                                                end.text = '1';
                                                                seach.text = '';
                                                                if (is_stock) {
                                                                  getProdList(
                                                                      end.text,
                                                                      seach
                                                                          .text,
                                                                      true,
                                                                      true);
                                                                  if (mounted) {
                                                                    setState(
                                                                        () {
                                                                      is_stock =
                                                                          false;
                                                                    });
                                                                  }
                                                                } else {
                                                                  getFourProdList(
                                                                      end.text,
                                                                      seach
                                                                          .text,
                                                                      true,
                                                                      true);
                                                                  if (mounted) {
                                                                    setState(
                                                                        () {
                                                                      is_stock =
                                                                          true;
                                                                    });
                                                                  }
                                                                }
                                                              },
                                                              child: Text(
                                                                is_stock
                                                                    ? "Produit par fournisseur"
                                                                    : "Produit en Stock",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 300,
                                                            child: BootstrapContainer(
                                                                fluid: true,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            20),
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
                                                                                        : is_stock
                                                                                            ? getProdList(end.text, seach.text, false, false)
                                                                                            : getFourProdList(end.text, seach.text, false, false);
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
                                                                                        : is_stock
                                                                                            ? getProdList(end.text, seach.text, true, false)
                                                                                            : getFourProdList(end.text, seach.text, true, false);
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
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
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
                    ),
                  )
                ],
              ),
            ),
          ));
        });
  }
}
