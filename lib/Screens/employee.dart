// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unused_field, prefer_final_fields, unused_local_variable

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/alert_box_2.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/Blocks/text_input.dart';
import 'package:application_principal/database/employee_model.dart';
import 'package:application_principal/database/salaireModel.dart';
import 'package:application_principal/database/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
// Salaire
  TextEditingController? _saName;
  TextEditingController? user;
  GlobalKey<FormState>? _saFormKey;
  List<SalaireModel>? _listsalaire1;
  SalaireModel? selectedSa;
  bool _salLoading = true;
  final controler = ScrollController();
  final controler1 = ScrollController();

////////////////

  TextEditingController? nom;
  TextEditingController? sexe;
  TextEditingController? cnib;
  TextEditingController? fonction;
  TextEditingController? tel;
  TextEditingController? salaire;
  List<EmployeeModel>? employesList;
  EmployeeModel? employes;
  bool _isEmptySalary = true;
  GlobalKey<FormState>? _formKey;
  List<String> _listsalaire = [];
  List<String> sexeListe = ['M', 'F'];
  List<String> fonctionList = [
    'Admin',
    'Secret1',
    'Secret2',
    'Magasin',
    'Caisse'
  ];

  bool _prodLoading = true;
  bool _isEmptyProd = true;
  bool _isEmptyCat = true;

  @override
  void initState() {
// Salaire
    _saName = TextEditingController();
    user = TextEditingController();
    _saFormKey = GlobalKey<FormState>();
    _listsalaire = [];
    _getSalaire();
    _salLoading = true;

/////////////

    bool isEmptyCategorie = true;
    bool isEmptyFournisseur = true;
    bool prodLoading = true;
    bool isEmptyProd = true;
    bool isEmptyCat = true;
    _listsalaire = [];
    employesList = [];
    nom = TextEditingController();
    sexe = TextEditingController();
    sexe!.text = sexeListe[0];
    cnib = TextEditingController();
    fonction = TextEditingController();
    fonction!.text = fonctionList[0];
    tel = TextEditingController();
    salaire = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _getSalaire();
    getEmpList();

    super.initState();
  }

// salaire
// ajouter un salaire
  _addSalaire() {
    Services.addSalaire(_saName!.text, user!.text).then((value) {
      if (int.parse(value) == 1) {
        setState(() {
          _getSalaire();
          _saName!.text = "";
          ConfirmBox().showAlert(context, "Salaire ajouté avec success", true);
        });
      } else if (int.parse(value) == 0) {
        ConfirmBox().showAlert(context, "Cet salaire existe déjà", false);
      } else if (int.parse(value) == -4) {
        ConfirmBox().showAlert(
            context, "Ajout refusé. Veuillez revoir la valeur.", false);
      } else {
        ConfirmBox()
            .showAlert(context, "Impossible de se connecter au serveur", false);
      }
    });
  }

// Recuperer un salaire
  _getSalaire() {
    Services.getSalaire().then((value) {
      if (int.parse(value.map((e) => e.saId).toList()[0]) == 0) {
        setState(() {
          _listsalaire1 = [];
          _listsalaire = [];
          _salLoading = false;
        });
      } else {
        if (int.parse(value.map((e) => e.saId).toList()[0]) > 0) {
          setState(() {
            _listsalaire1 = value;
            _listsalaire = [];
            _listsalaire =
                value.map((e) => '${e.saId}=> ${e.saVal} Fcfa').toList();
            _salLoading = false;
          });
        } else {
          setState(() {
            _listsalaire1 = [];
            _listsalaire = [];
          });
          ConfirmBox().showAlert(context, "Erreur de connexion", false);
        }
      }
    });
  }

  bool checkSalaire(List<EmployeeModel> employeList, String salai) {
    int temoin = 0;
    for (int i = 0; i < employeList.length; i++) {
      if (employeList[i].salaireEmp.split('-')[0] == salai) {
        temoin = 1;
        break;
      }
    }
    return temoin == 0 ? false : true;
  }
// //////////////////////

  void ajoutEmploy() {
    Services.addEmp(nom!.text, cnib!.text, tel!.text,
            salaire!.text.split('=>')[0], fonction!.text, sexe!.text)
        .then((value) {
      if (value.split('-').length > 1) {
        ConfirmBox()
            .showAlert(
                context,
                "employé ajouté avec succès.\nNom d'utilisateur:${value.split('-')[2]}\nMot de passe: ${value.split('-')[1]}",
                true)
            .then((value) {
          nom!.text = '';
          cnib!.text = '';
          tel!.text = '';
        });
        setState(() {
          getEmpList();
        });
      } else {
        if (int.parse(value) == -1) {
          ConfirmBox().showAlert(
              context, "Impossible d'ajouter cet employé. Réessayer", false);
        } else if (int.parse(value) == -2) {
          ConfirmBox().showAlert(context, "Erreur de connexion", false);
        } else if (int.parse(value) == 0) {
          ConfirmBox().showAlert(context, "Cet employé existe déjà", false);
        }
      }
    });
  }

  void getEmpList() {
    Services.getEmployees('all', '').then((value) {
      if (int.parse(value.map((e) => e.idEmp).toList()[0]) == -1 ||
          int.parse(value.map((e) => e.idEmp).toList()[0]) == -2) {
        setState(() {
          employesList = [];
        });
        ConfirmBox().showAlert(context, "Erreur de connexion", false);
      } else {
        if (int.parse(value.map((e) => e.idEmp).toList()[0]) == 0) {
          setState(() {
            employesList = [];
          });
        } else {
          setState(() {
            _isEmptyProd = false;
            employesList = value;
          });
        }
        setState(() {
          _prodLoading = false;
        });
      }
    });
  }

// salaire
  SingleChildScrollView get _salBody {
    return SingleChildScrollView(
      controller: controler1,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Container(
          child: DataTable(
            columnSpacing: 57,
            headingTextStyle: TextStyle(
              color: Color(0xFF26345d),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            horizontalMargin: 30,

            // ignore: prefer_const_literals_to_create_immutables
            columns: [
              DataColumn(
                label: Container(child: Text("Valeur")),
              ),
              DataColumn(
                label: Text("Action"),
              ),
            ],
            rows: _listsalaire1!
                .map(
                  (e) => DataRow(cells: [
                    DataCell(
                      Text('${e.saVal} Fcfa'),
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
                              selectedSa = e;
                              if (checkSalaire(employesList!, e.saVal)) {
                                ConfirmBox().showAlert(
                                    context,
                                    'Certain employés ont deja ce salaire. veuillez modifier leur salaire d\'abord ',
                                    false);
                              } else {
                                setState(() {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Align(
                                          alignment: Alignment(1, 0),
                                          child: SaUpdateAlert(
                                              selctedSa: selectedSa),
                                        );
                                      }).then((value) {
                                    _getSalaire();
                                    if (int.parse(value) == 1) {
                                      ConfirmBox()
                                          .showAlert(
                                              context,
                                              "Le salaire a été modifié avec success",
                                              true)
                                          .then((value) {
                                        _getSalaire();
                                        getEmpList();
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
                              selectedSa = e;
                              if (checkSalaire(employesList!, e.saVal)) {
                                ConfirmBox().showAlert(
                                    context,
                                    'certain employés ont deja ce salaire. veuillez modifier leur salaire d\'abord ',
                                    false);
                              } else {
                                String content =
                                    "Voulez-vous réellement supprimer cet salaire?";
                                AlertBox()
                                    .showAlertDialod(
                                        context,
                                        int.parse(selectedSa!.saId),
                                        content,
                                        'salaire')
                                    .then((value) {
                                  if (int.parse(value) != 2) {
                                    setState(() {
                                      if (int.parse(value) == 1) {
                                        ConfirmBox()
                                            .showAlert(
                                                context,
                                                "Le salaire a été supprimé avec success",
                                                true)
                                            .then((value) {
                                          _getSalaire();
                                          getEmpList();
                                        });
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

///////////////////////
  ///
  ///

  SingleChildScrollView get _dataBody {
    return SingleChildScrollView(
      controller: controler,
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Container(
          child: DataTable(
            columnSpacing: 15,
            headingTextStyle: TextStyle(
              color: Color(0xFF26345d),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            horizontalMargin: 30,
            // ignore: prefer_const_literals_to_create_immutables
            columns: [
              DataColumn(
                label: Container(child: Text("Nom")),
              ),
              DataColumn(
                label: Text("Sexe"),
              ),
              DataColumn(
                label: Text("Tel"),
              ),
              DataColumn(
                label: Text("Cnib"),
              ),
              DataColumn(
                label: Text("Salaire"),
              ),
              DataColumn(
                label: Text("Date"),
              ),
              DataColumn(
                label: Text("Fonction"),
              ),
              DataColumn(
                label: Text("Action"),
              ),
            ],
            rows: employesList!
                .map(
                  (e) => DataRow(cells: [
                    DataCell(
                      Text(e.nomEmp.toString()),
                    ),
                    DataCell(
                      Text(e.sexe),
                    ),
                    DataCell(
                      Text(e.telEmp),
                    ),
                    DataCell(
                      Text(e.cnibEmp),
                    ),
                    DataCell(
                      Text('${e.salaireEmp.split('-')[0]} Fcfa'),
                    ),
                    DataCell(
                      Text(
                        e.dateUser,
                      ),
                    ),
                    DataCell(
                      Text(
                        e.droitEmp,
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
                              employes = e;

                              setState(() {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return UpdEmployee(
                                          employee: employes!,
                                          listSalary: _listsalaire);
                                    }).then((value) {
                                  setState(() {
                                    getEmpList();
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
                              employes = e;
                              String content =
                                  "Voulez-vous réellement supprimer cet employé?";
                              AlertBox()
                                  .showAlertDialod(
                                      context,
                                      int.parse(employes!.idEmp),
                                      content,
                                      'employee')
                                  .then((value) {
                                if (int.parse(value) == 1) {
                                  setState(() {
                                    getEmpList();
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
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: state.isClosed! ? 0 : 7, top: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              80,
                                      color: Colors.white,
                                      child: SingleChildScrollView(
                                        controller: ScrollController(),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 450,
                                              padding: EdgeInsets.only(top: 9),
                                              child: Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
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
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              5),
                                                                      child: MyFunction().inputFiled(
                                                                          "Nom complet",
                                                                          false,
                                                                          nom!,
                                                                          TextInputType
                                                                              .text,
                                                                          false,
                                                                          1,
                                                                          0,
                                                                          true),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      child: MyFunction().dropdown(
                                                                          'Sexe',
                                                                          sexeListe,
                                                                          sexe!,
                                                                          _isEmptySalary,
                                                                          'upd',
                                                                          sexe!
                                                                              .text),
                                                                    ),
                                                                  ),
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
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              5),
                                                                      child: MyFunction().inputFiled(
                                                                          "Téléphone",
                                                                          false,
                                                                          tel!,
                                                                          TextInputType
                                                                              .text,
                                                                          false,
                                                                          1,
                                                                          0,
                                                                          true),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: MyFunction().inputFiled(
                                                                        "Cnib",
                                                                        false,
                                                                        cnib!,
                                                                        TextInputType
                                                                            .text,
                                                                        false,
                                                                        1,
                                                                        0,
                                                                        true),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              5),
                                                                      child: MyFunction().dropdown(
                                                                          'Fonction',
                                                                          fonctionList,
                                                                          fonction!,
                                                                          _isEmptySalary,
                                                                          'upd',
                                                                          fonction!
                                                                              .text),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      child: MyFunction().dropdown(
                                                                          'Salaire',
                                                                          _listsalaire,
                                                                          salaire!,
                                                                          _isEmptySalary,
                                                                          'ajout',
                                                                          'none'),
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
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 3,
                                                                    left: 3),
                                                            child:
                                                                MaterialButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  sexe!.text
                                                                          .isEmpty
                                                                      ? _isEmptySalary =
                                                                          false
                                                                      : _isEmptySalary =
                                                                          true;
                                                                });

                                                                if (!_formKey!
                                                                    .currentState!
                                                                    .validate()) {
                                                                  return;
                                                                } else {
                                                                  ajoutEmploy();
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
                                                                        .circular(
                                                                            2),
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

                                            // ImprovedScrolling(

                                            SizedBox(
                                              height: 284,
                                              child: !_prodLoading
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
                                                          controler,
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
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              80,
                                      child: SingleChildScrollView(
                                        controller: ScrollController(),
                                        child: Container(
                                          height: 747,
                                          color: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          margin: EdgeInsets.only(
                                            left: 7,
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Form(
                                                  key: _saFormKey,
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    controller: _saName!,
                                                    validator: (String? value) {
                                                      if (value!.isEmpty) {
                                                        return "Veuillez remplire le champ ";
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (String? value) {},
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "Ajouter un salaire",
                                                      suffixIcon:
                                                          MaterialButton(
                                                        onPressed: () {
                                                          if (!_saFormKey!
                                                              .currentState!
                                                              .validate()) {
                                                            return;
                                                          } else {
                                                            _addSalaire();
                                                          }
                                                        },
                                                        height: 60,
                                                        color:
                                                            Color(0xFF26345d),
                                                        elevation: 0,
                                                        child: Text(
                                                          "Ajouter",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      enabledBorder: OutlineInputBorder(
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
                                              Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  height: 660,
                                                  child: !_salLoading
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
                                                              controler1,
                                                          child: _salBody,
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
