// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables, unused_element, prefer_final_fields, avoid_unnecessary_containers, prefer_is_not_empty, avoid_function_literals_in_foreach_calls, non_constant_identifier_names, unrelated_type_equality_checks, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable

import 'dart:convert';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:application_principal/Blocks/alert_box_3.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/function.dart';
import 'package:application_principal/Blocks/pdf_invoice.dart';
import 'package:application_principal/Blocks/text_input.dart';
import 'package:application_principal/database/clientModel.dart';
import 'package:application_principal/database/company_model.dart';
import 'package:application_principal/database/employee_model.dart';
import 'package:application_principal/database/fourPay.dart';
import 'package:application_principal/database/fournisseurModel.dart';
import 'package:application_principal/database/product.dart';
import 'package:application_principal/database/produit_use_model.dart';
import 'package:application_principal/database/services.dart';
import 'package:application_principal/database/venteInfos.dart';
import 'package:application_principal/database/venteModel.dart';
import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ConfirmBox {
  String numFacture(String dateFact, String idCom) {
    List dateElem = dateFact.split('');
    String numFac =
        dateElem[dateElem.length - 2] + dateElem[dateElem.length - 1] + 'F';
    if (int.parse(idCom) < 10) {
      numFac += '00000$idCom';
    } else if (int.parse(idCom) >= 10 && int.parse(idCom) < 100) {
      numFac += '0000$idCom';
    } else if (int.parse(idCom) >= 100 && int.parse(idCom) < 1000) {
      numFac += '000$idCom';
    } else if (int.parse(idCom) >= 1000 && int.parse(idCom) < 10000) {
      numFac += '00$idCom';
    } else if (int.parse(idCom) >= 10000 && int.parse(idCom) < 100000) {
      numFac += '0$idCom';
    } else if (int.parse(idCom) >= 100000) {
      numFac += idCom;
    }
    return numFac;
  }

  String bonBoutique(String dateFact, String idCom) {
    List dateElem = dateFact.split('');
    String numFac =
        dateElem[dateElem.length - 2] + dateElem[dateElem.length - 1] + 'BB';
    if (int.parse(idCom) < 10) {
      numFac += '000$idCom';
    } else if (int.parse(idCom) >= 10 && int.parse(idCom) < 100) {
      numFac += '00$idCom';
    } else if (int.parse(idCom) >= 100 && int.parse(idCom) < 1000) {
      numFac += '0$idCom';
    } else if (int.parse(idCom) >= 1000) {
      numFac += idCom;
    }
    return numFac;
  }

  String bonClien(String dateFact, String idCom) {
    List dateElem = dateFact.split('');
    String numFac =
        dateElem[dateElem.length - 2] + dateElem[dateElem.length - 1] + 'BC';
    if (int.parse(idCom) < 10) {
      numFac += '000$idCom';
    } else if (int.parse(idCom) >= 10 && int.parse(idCom) < 100) {
      numFac += '00$idCom';
    } else if (int.parse(idCom) >= 100 && int.parse(idCom) < 1000) {
      numFac += '0$idCom';
    } else if (int.parse(idCom) >= 1000) {
      numFac += idCom;
    }
    return numFac;
  }

  Future<String> showAlert(BuildContext context, String txt, bool added) async {
    TextEditingController check = TextEditingController();
    Widget cancelBtn = TextButton(
      onPressed: () {
        Navigator.of(context).pop('1');
      },
      child: Text(
        "OK",
        style: TextStyle(
            color: added ? Colors.green : Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: added ? Colors.green.shade50 : Colors.red.shade50,
      elevation: 90,
      titleTextStyle: TextStyle(
          fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
      content: Container(
        height: 230,
        width: 400,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Image(
                  image: AssetImage(added
                      ? 'lib/src/img/ok_120px.png'
                      : 'lib/src/img/no_entry_120px.png'),
                )),
            Text(
              txt,
              style: TextStyle(
                  color: added ? Colors.green : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [cancelBtn],
    );
    check.text = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext buildcontext) {
          return alert;
        });
    return check.text.toString();
  }
}

class AlertBox {
  Future<String> showAlertDialod(
      BuildContext context, int id, String content, String table) async {
    TextEditingController check = TextEditingController();
    check.text = '2';
    Widget okBtn = TextButton(
      onPressed: () {
        if (table == 'categorie') {
          Services.delCategorie(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('0');
            }
          });
        } else if (table == 'produits') {
          Services.delProd(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('0');
            }
          });
        } else if (table == 'fournisseur') {
          Services.delFour(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('0');
            }
          });
        } else if (table == 'updCompInfos') {
          Navigator.of(context).pop('1');
        } else if (table == 'custome') {
          Navigator.of(context).pop('1');
        } else if (table == 'ValiderRembouser') {
          Navigator.of(context).pop('1');
        } else if (table == 'delCredit') {
          Navigator.of(context).pop('1');
        } else if (table == 'ravitail') {
          Services.delCom(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('0');
            }
          });
        } else if (table == 'valideCom') {
          Services.validateCom(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('0');
            }
          });
        } else if (table == 'client') {
          Services.delClient(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('0');
            }
          });
        } else if (table == 'salaire') {
          Services.delSa(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('0');
            }
          });
        } else if (table == 'employee') {
          Services.delEmp(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('0');
            }
          });
        } else if (table == 'virementbank') {
          Services.delVire(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        } else if (table == 'retraitbank') {
          Services.delRet(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        } else if (table == 'rembousement') {
          Services.delRembourse(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        } else if (table == 'valideLivraison') {
          Services.venteIsdeliver(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        } else if (table == 'vente') {
          Services.deleteVente(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        } else if (table == 'depense') {
          Services.delDep(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        } else if (table == 'validateVer') {
          Services.validateVer(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        } else if (table == 'delver') {
          Services.delVer(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        } else if (table == 'cpt_versement') {
          Services.delComptVer(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        } else if (table == 'end_versement') {
          Services.terminateVers(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        } else if (table == 'appliquerVersement') {
          Services.applyVersement(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        } else if (table == 'validateDep') {
          Services.validateDep(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        } else if (table == 'Boutique') {
          Services.delBoutique(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        } else if (table == 'bonDeSortie') {
          Services.deleteBon(id.toString()).then((value) {
            if (int.parse(value) == 1) {
              Navigator.of(context).pop('1');
            } else {
              Navigator.of(context).pop('-1');
            }
          });
        }
      },
      child: Text(
        "Oui",
        style: TextStyle(
          color: Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    Widget cancelBtn = TextButton(
      onPressed: () {
        Navigator.of(context).pop('0');
      },
      child: Text(
        "Non",
        style: TextStyle(
          color: Color(0xF1FFAE00),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    AlertDialog alert = AlertDialog(
      elevation: 90,
      content: Container(
        height: 200,
        width: 400,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Image(
                image: AssetImage('lib/src/img/shield_120px.png'),
              ),
            ),
            Text(
              content,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [okBtn, cancelBtn],
    );
    check.text = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext buildcontext) {
          return Container(width: 500, child: alert);
        });
    return check.text.toString();
  }
}

//modification d'un employee

class UpdEmployee extends StatefulWidget {
  final EmployeeModel employee;
  final List<String> listSalary;
  UpdEmployee({
    Key? key,
    required this.employee,
    required this.listSalary,
  }) : super(key: key);

  @override
  State<UpdEmployee> createState() => _UpdEmployeeState();
}

class _UpdEmployeeState extends State<UpdEmployee> {
  TextEditingController? nom;
  TextEditingController? sexe;
  TextEditingController? cnib;
  TextEditingController? fonction;
  TextEditingController? tel;
  TextEditingController? salaire;
  List<String> sexeListe = ['M', 'F'];
  List<String> fonctionList = [
    'Admin',
    'Secret1',
    'Secret2',
    'Magasin',
    'Caisse'
  ];

  GlobalKey<FormState>? _formKey;

  @override
  void initState() {
    super.initState();
    nom = TextEditingController();
    nom!.text = widget.employee.nomEmp;
    sexe = TextEditingController();
    sexe!.text = widget.employee.sexe;
    cnib = TextEditingController();
    cnib!.text = widget.employee.cnibEmp;
    fonction = TextEditingController();
    fonction!.text = widget.employee.droitEmp;
    tel = TextEditingController();
    tel!.text = widget.employee.telEmp;
    salaire = TextEditingController();
    salaire!.text = '${widget.employee.salaireEmp.split('-')[1]}=> ${widget.employee.salaireEmp.split('-')[0]} Fcfa';
    _formKey = GlobalKey<FormState>();
  }
  // get salary List

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Container(
        height: 710,
        width: 750,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
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
                          child: Text('Modification des infos d\'un employé',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 177,
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Container(
                  height: 700,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Nom: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.employee.nomEmp,
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Sexe: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.employee.sexe,
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Téléphone: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${widget.employee.telEmp} ",
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "CNIB: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.employee.cnibEmp,
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Fonction: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.employee.droitEmp,
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Date: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.employee.dateUser,
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Salaire: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${widget.employee.salaireEmp
                                                  .split('-')[0]} Fcfa',
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: MyFunction()
                                                          .inputFiled(
                                                              "Nom complet ",
                                                              false,
                                                              nom,
                                                              TextInputType
                                                                  .text,
                                                              false,
                                                              1,
                                                              0,
                                                              true),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: MyFunction()
                                                            .dropdown(
                                                                'Sexe',
                                                                sexeListe,
                                                                sexe!,
                                                                true,
                                                                'upd',
                                                                widget.employee
                                                                    .sexe),
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
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: MyFunction()
                                                            .inputFiled(
                                                                "Téléphone",
                                                                false,
                                                                tel!,
                                                                TextInputType
                                                                    .text,
                                                                true,
                                                                1,
                                                                0,
                                                                false),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: MyFunction()
                                                          .inputFiled(
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
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: MyFunction()
                                                            .dropdown(
                                                                'Fonction',
                                                                fonctionList,
                                                                fonction!,
                                                                true,
                                                                'upd',
                                                                widget.employee
                                                                    .droitEmp),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: MyFunction().dropdown(
                                                            'Salaire',
                                                            widget.listSalary,
                                                            salaire!,
                                                            true,
                                                            'upd',
                                                            '${widget.employee
                                                                        .salaireEmp
                                                                        .split(
                                                                            '-')[
                                                                    1]}=> ${widget.employee
                                                                    .salaireEmp
                                                                    .split(
                                                                        '-')[0]} Fcfa'),
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 3, left: 3),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (!_formKey!.currentState!
                                                      .validate()) {
                                                    return;
                                                  } else {
                                                    Services.updEmp(
                                                            nom!.text,
                                                            cnib!.text,
                                                            tel!.text,
                                                            salaire!.text
                                                                .split('=>')[0],
                                                            fonction!.text,
                                                            sexe!.text,
                                                            widget
                                                                .employee.idEmp)
                                                        .then((value) {
                                                      if (int.parse(value) ==
                                                          1) {
                                                        ConfirmBox()
                                                            .showAlert(
                                                                context,
                                                                "Modification terminée avec success",
                                                                true)
                                                            .then((value) {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      } else if (int.parse(
                                                              value) ==
                                                          0) {
                                                        ConfirmBox().showAlert(
                                                            context,
                                                            "Cet employé existe déjà ",
                                                            false);
                                                      } else {
                                                        ConfirmBox().showAlert(
                                                            context,
                                                            "Erreur de connexion",
                                                            false);
                                                      }
                                                    });
                                                  }
                                                },
                                                minWidth: 200,
                                                height: 60,
                                                color: Color(0xFF26345d),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                                child: Text(
                                                  "Modifier",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
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

class NotifyAlert extends StatefulWidget {
  final Product prod;
  final List<String> listCategorie;
  NotifyAlert({
    Key? key,
    required this.prod,
    required this.listCategorie,
  }) : super(key: key);

  @override
  State<NotifyAlert> createState() => _NotifyAlertState();
}

class _NotifyAlertState extends State<NotifyAlert> {
  TextEditingController? categorie;
  TextEditingController? description;
  TextEditingController? designation;
  TextEditingController? promo;
  TextEditingController? prix;
  List<Product>? productList;
  Product? prod;

  bool _isEmptyCategorie = true;

  GlobalKey<FormState>? _formKey;

  @override
  void initState() {
    super.initState();
    categorie = TextEditingController();
    categorie!.text = widget.prod.id_cat;
    description = TextEditingController();
    description!.text = widget.prod.description;
    designation = TextEditingController();
    designation!.text = widget.prod.designation;
    promo = TextEditingController();
    promo!.text = widget.prod.promo;
    prix = TextEditingController();
    prix!.text = widget.prod.prix;
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Container(
        height: 720,
        width: 750,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
              color: Color(0xFF26345d),
              width: double.infinity,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 167,
              child: SingleChildScrollView(
                child: Container(
                  height: 660,
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Categorie: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.prod.id_cat,
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Designation: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.prod.designation,
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Prix: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${widget.prod.prix} FCFA",
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Reduction: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${widget.prod.promo} FCFA",
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Date: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.prod.prod_date,
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Utilisateur: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.prod.id_user,
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Identifiant: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.prod.id_prod,
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Quatite stock: ",
                                          style: TextStyle(
                                            color: Color(0xFF26345d),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.prod.stock.toString(),
                                          style: TextStyle(
                                            color: double.parse(
                                                        widget.prod.stock) ==
                                                    0
                                                ? Color(0xFFDD0B0B)
                                                : Color(0xFF0FBD26),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: MyFunction().dropdown(
                                                            'Categorie',
                                                            widget
                                                                .listCategorie,
                                                            categorie!,
                                                            _isEmptyCategorie,
                                                            'upd',
                                                            widget.prod.id_cat),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: MyFunction()
                                                          .inputFiled(
                                                              "Designation",
                                                              false,
                                                              designation!,
                                                              TextInputType
                                                                  .text,
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
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: MyFunction()
                                                            .inputFiled(
                                                                "Prix",
                                                                false,
                                                                prix!,
                                                                TextInputType
                                                                    .number,
                                                                true,
                                                                1,
                                                                0,
                                                                true),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: MyFunction()
                                                          .inputFiled(
                                                              "Reduction",
                                                              false,
                                                              promo!,
                                                              TextInputType
                                                                  .number,
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
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: MyFunction()
                                                            .inputFiled(
                                                                "Description",
                                                                false,
                                                                description!,
                                                                TextInputType
                                                                    .text,
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 3, left: 3),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  setState(() {
                                                    categorie!.text.isEmpty
                                                        ? _isEmptyCategorie =
                                                            false
                                                        : _isEmptyCategorie =
                                                            true;
                                                  });

                                                  if (!_formKey!.currentState!
                                                      .validate()) {
                                                    return;
                                                  } else {
                                                    Services.updProd(
                                                            widget.prod.id_prod,
                                                            designation!.text,
                                                            categorie!.text,
                                                            description!.text,
                                                            prix!.text,
                                                            promo!.text)
                                                        .then((value) {
                                                      if (int.parse(value) ==
                                                          1) {
                                                        ConfirmBox()
                                                            .showAlert(
                                                                context,
                                                                "Le produit a ete modifie avec success",
                                                                true)
                                                            .then((value) {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      } else if (int.parse(
                                                              value) ==
                                                          0) {
                                                        ConfirmBox().showAlert(
                                                            context,
                                                            "Cet produit existe deja",
                                                            false);
                                                      } else {
                                                        ConfirmBox().showAlert(
                                                            context,
                                                            "Erreur de connexion",
                                                            false);
                                                      }
                                                    });
                                                  }
                                                },
                                                minWidth: 200,
                                                height: 60,
                                                color: Color(0xFF26345d),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                                child: Text(
                                                  "Modifier",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
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

// ************************ Boxes de fournisseurs **********************//
//
//
//ajout de fournisseur

class AddFourAlert extends StatefulWidget {
  AddFourAlert({Key? key}) : super(key: key);

  @override
  State<AddFourAlert> createState() => _AddFourAlertState();
}

class _AddFourAlertState extends State<AddFourAlert> {
  TextEditingController? nom;
  TextEditingController? type;
  TextEditingController? pays;
  TextEditingController? ville;
  TextEditingController? adress;
  TextEditingController? email;
  TextEditingController? tel;
  TextEditingController? cnib;
  TextEditingController? desc;
  TextEditingController? user;

  GlobalKey<FormState>? _fourFormKey;
  List<String> listType = ['Particulier', 'Société'];
  bool _isFourTypeEmpty = true;

  @override
  void initState() {
    super.initState();
    nom = TextEditingController();
    type = TextEditingController();
    pays = TextEditingController();
    ville = TextEditingController();
    adress = TextEditingController();
    email = TextEditingController();
    tel = TextEditingController();
    cnib = TextEditingController();
    desc = TextEditingController();
    user = TextEditingController();
    _fourFormKey = GlobalKey<FormState>();
    _isFourTypeEmpty = true;
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
              height: 750,
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
                                "Ajouter un fournisseur",
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
                    height: MediaQuery.of(context).size.height - 140,
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Form(
                            key: _fourFormKey!,
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
                                            child: MyFunction().dropdown(
                                                'Statut',
                                                listType,
                                                type!,
                                                _isFourTypeEmpty,
                                                'ajout',
                                                'none'),
                                          ),
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Nom",
                                                false,
                                                nom!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Tel",
                                                false,
                                                tel!,
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
                                                "Addresse",
                                                false,
                                                adress!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
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
                                                "CNIB",
                                                false,
                                                cnib!,
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
                                                "Email",
                                                false,
                                                email!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
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
                                                "Pays",
                                                false,
                                                pays!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
                                          ),
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Ville",
                                                false,
                                                ville!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
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
                                        setState(() {
                                          type!.text.isEmpty
                                              ? _isFourTypeEmpty = false
                                              : _isFourTypeEmpty = true;
                                        });
                                        if (!_fourFormKey!.currentState!
                                            .validate()) {
                                          return;
                                        } else {
                                          if (type!.text.isNotEmpty) {
                                            Services.addFour(
                                                    nom!.text,
                                                    type!.text,
                                                    pays!.text,
                                                    ville!.text,
                                                    adress!.text,
                                                    email!.text,
                                                    tel!.text,
                                                    cnib!.text,
                                                    desc!.text,
                                                    user!.text)
                                                .then((value) {
                                              if (int.parse(value) == 1) {
                                                ConfirmBox()
                                                    .showAlert(
                                                        context,
                                                        "Le Fournisseur a été ajoute avec success",
                                                        true)
                                                    .then((value) {
                                                  nom!.text = "";
                                                  type!.text = "";
                                                  pays!.text = "";
                                                  ville!.text = "";
                                                  adress!.text = "";
                                                  email!.text = "";
                                                  tel!.text = "";
                                                  cnib!.text = "";
                                                  desc!.text = "";
                                                });
                                              } else if (int.parse(value) ==
                                                  0) {
                                                ConfirmBox().showAlert(
                                                    context,
                                                    "Cet fournisseur existe deja",
                                                    false);
                                              } else {
                                                ConfirmBox().showAlert(
                                                    context,
                                                    "Erreur de connexion",
                                                    false);
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
                                        "Ajouter",
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

//gestion de fournisseur

class ManageFourAlert extends StatefulWidget {
  final FournisseurModel selectFour;
  ManageFourAlert({
    Key? key,
    required this.selectFour,
  }) : super(key: key);

  @override
  State<ManageFourAlert> createState() => _ManageFourAlertState();
}

class _ManageFourAlertState extends State<ManageFourAlert> {
  TextEditingController? nom;
  TextEditingController? type;
  TextEditingController? pays;
  TextEditingController? ville;
  TextEditingController? adress;
  TextEditingController? email;
  TextEditingController? tel;
  TextEditingController? cnib;
  TextEditingController? desc;

  GlobalKey<FormState>? _fourFormKey;
  List<String> listType = ['Particulier', 'Societe'];
  bool _isFourTypeEmpty = true;

  @override
  void initState() {
    super.initState();
    nom = TextEditingController();
    nom!.text = widget.selectFour.nomFour;
    type = TextEditingController();
    type!.text = widget.selectFour.typeFour;
    pays = TextEditingController();
    pays!.text = widget.selectFour.paysFour;
    ville = TextEditingController();
    ville!.text = widget.selectFour.villeFour;
    adress = TextEditingController();
    adress!.text = widget.selectFour.addressFour;
    email = TextEditingController();
    email!.text = widget.selectFour.emailFour;
    tel = TextEditingController();
    tel!.text = widget.selectFour.telFour;
    cnib = TextEditingController();
    cnib!.text = widget.selectFour.fourCNIB;
    desc = TextEditingController();
    desc!.text = widget.selectFour.fourDesc;
    _fourFormKey = GlobalKey<FormState>();
    _isFourTypeEmpty = true;
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
                columnSpacing: 105,
                headingTextStyle: TextStyle(
                  color: Color(0xFF26345d),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                horizontalMargin: 30,
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                ),
                columns: [
                  DataColumn(
                    label: Container(child: Text("ID")),
                  ),
                  DataColumn(
                    label: Text("Date"),
                  ),
                  DataColumn(
                    label: Text("Produits"),
                  ),
                  DataColumn(
                    label: Text("Prix"),
                  ),
                  DataColumn(
                    label: Text("Etat"),
                  ),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text(''))
                  ])
                ],
              ),
            ),
          ),
        ],
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
                          "Détail du fournisseur",
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
              height: MediaQuery.of(context).size.height - 110,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                        child: Form(
                          key: _fourFormKey!,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Center(
                                child: Text(
                                  "Modifier les Infos",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().dropdown(
                                                'Statut',
                                                listType,
                                                type!,
                                                _isFourTypeEmpty,
                                                'upd',
                                                widget.selectFour.typeFour),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Nom",
                                                false,
                                                nom!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Tel",
                                                false,
                                                tel!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Adress",
                                                false,
                                                adress!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "CNIB",
                                                false,
                                                cnib!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Email",
                                                false,
                                                email!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Pays",
                                                false,
                                                pays!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Ville",
                                                false,
                                                ville!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
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
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  padding: EdgeInsets.only(top: 3, left: 3),
                                  child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        type!.text.isEmpty
                                            ? _isFourTypeEmpty = false
                                            : _isFourTypeEmpty = true;
                                      });
                                      if (!_fourFormKey!.currentState!
                                          .validate()) {
                                        return;
                                      } else {
                                        Services.updFour(
                                                nom!.text,
                                                type!.text,
                                                pays!.text,
                                                ville!.text,
                                                adress!.text,
                                                email!.text,
                                                tel!.text,
                                                cnib!.text,
                                                desc!.text,
                                                widget.selectFour.idFour)
                                            .then((value) {
                                          if (int.parse(value) == 1) {
                                            ConfirmBox()
                                                .showAlert(
                                                    context,
                                                    "Le Fournisseur a ete modifie avec success",
                                                    true)
                                                .then((value) =>
                                                    Navigator.pop(context));
                                          } else if (int.parse(value) == 0) {
                                            ConfirmBox().showAlert(
                                                context,
                                                "Cet fournisseur existe deja",
                                                false);
                                          } else {
                                            ConfirmBox().showAlert(context,
                                                "Erreur de connexion", false);
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
                                      "Modifier",
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
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  height: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Nom: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget.selectFour.nomFour,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Statut: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget
                                                          .selectFour.typeFour,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Telephone: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget.selectFour.telFour,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Email: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget
                                                          .selectFour.emailFour,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Adresse: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget.selectFour
                                                          .addressFour,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Pays: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget
                                                          .selectFour.paysFour,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Ville: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget
                                                          .selectFour.villeFour,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('CNIB: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget
                                                          .selectFour.fourCNIB,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Date_Ajout: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget
                                                          .selectFour.dateFour,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Utilisateur: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget
                                                          .selectFour.userFour,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Description: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget
                                                          .selectFour.fourDesc,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 500,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        child: Text(
                                          'Achats realisées',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      _fournisseuMove,
                                    ],
                                  ),
                                )
                              ],
                            ),
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

// ************************ Boxes de clients **********************//
//
//
//ajout de client

class AddClientAlert extends StatefulWidget {
  AddClientAlert({Key? key}) : super(key: key);

  @override
  State<AddClientAlert> createState() => _AddClientAlertState();
}

class _AddClientAlertState extends State<AddClientAlert> {
  TextEditingController? nom;
  TextEditingController? type;
  TextEditingController? adress;
  TextEditingController? ville;
  TextEditingController? tel;
  TextEditingController? cnib;
  TextEditingController? desc;
  TextEditingController? user;

  GlobalKey<FormState>? _fourFormKey;
  List<String> listType = ['Simple', 'Grossiste'];
  bool _isFourTypeEmpty = true;

  @override
  void initState() {
    super.initState();
    nom = TextEditingController();
    type = TextEditingController();
    ville = TextEditingController();
    adress = TextEditingController();
    tel = TextEditingController();
    cnib = TextEditingController();
    desc = TextEditingController();
    user = TextEditingController();
    _fourFormKey = GlobalKey<FormState>();
    _isFourTypeEmpty = true;
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
              height: 600,
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
                                "Ajouter un Client",
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
                            key: _fourFormKey!,
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
                                            child: MyFunction().dropdown(
                                                'Statut',
                                                listType,
                                                type!,
                                                _isFourTypeEmpty,
                                                'ajout',
                                                'none'),
                                          ),
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Nom complte",
                                                false,
                                                nom!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
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
                                                false),
                                          ),
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Adresse",
                                                false,
                                                adress!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
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
                                                "CNIB",
                                                false,
                                                cnib!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
                                          ),
                                          Container(
                                            width: 350,
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Ville",
                                                false,
                                                ville!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
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
                                        loader(context);
                                        setState(() {
                                          type!.text.isEmpty
                                              ? _isFourTypeEmpty = false
                                              : _isFourTypeEmpty = true;
                                        });
                                        if (!_fourFormKey!.currentState!
                                            .validate()) {
                                          Loader.hide();
                                          return;
                                        } else {
                                          if (type!.text.isNotEmpty) {
                                            Services.addClient(
                                                    nom!.text,
                                                    type!.text,
                                                    ville!.text,
                                                    adress!.text,
                                                    tel!.text,
                                                    cnib!.text,
                                                    desc!.text,
                                                    user!.text)
                                                .then((value) {
                                              Loader.hide();
                                              if (int.parse(value) == 1) {
                                                ConfirmBox()
                                                    .showAlert(
                                                        context,
                                                        "Le Client a été ajouté avec succès",
                                                        true)
                                                    .then((value) {
                                                  setState(() {
                                                    nom!.text = "";
                                                    type!.text = "";
                                                    ville!.text = "";
                                                    adress!.text = "";
                                                    tel!.text = "";
                                                    cnib!.text = "";
                                                    desc!.text = "";
                                                  });
                                                });
                                              } else if (int.parse(value) ==
                                                  0) {
                                                ConfirmBox().showAlert(
                                                    context,
                                                    "Cet Client existe déjà",
                                                    false);
                                              } else {
                                                ConfirmBox().showAlert(
                                                    context,
                                                    "Erreur de connexion",
                                                    false);
                                              }
                                            });
                                          } else {
                                            Loader.hide();
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
                                        "Ajouter",
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

class ManageClientAlert extends StatefulWidget {
  final ClientModel selectedClient;
  ManageClientAlert({
    Key? key,
    required this.selectedClient,
  }) : super(key: key);

  @override
  State<ManageClientAlert> createState() => _ManageClientAlertState();
}

class _ManageClientAlertState extends State<ManageClientAlert> {
  TextEditingController? nom;
  TextEditingController? type;
  TextEditingController? ville;
  TextEditingController? adress;
  TextEditingController? tel;
  TextEditingController? cnib;
  TextEditingController? desc;

  GlobalKey<FormState>? _fourFormKey;
  List<String> listType = ['Simple', 'Grossiste'];
  bool _isFourTypeEmpty = true;

  @override
  void initState() {
    super.initState();
    nom = TextEditingController();
    nom!.text = widget.selectedClient.nom_complet_client;
    type = TextEditingController();
    type!.text = widget.selectedClient.type_client;
    ville = TextEditingController();
    ville!.text = widget.selectedClient.ville_client;
    adress = TextEditingController();
    adress!.text = widget.selectedClient.adress_client;
    tel = TextEditingController();
    tel!.text = widget.selectedClient.tel_client;
    cnib = TextEditingController();
    cnib!.text = widget.selectedClient.cnib_client;
    desc = TextEditingController();
    desc!.text = widget.selectedClient.desc_client;
    _fourFormKey = GlobalKey<FormState>();
    _isFourTypeEmpty = true;
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
                columnSpacing: 35,
                headingTextStyle: TextStyle(
                  color: Color(0xFF26345d),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                horizontalMargin: 30,
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                ),
                columns: [
                  DataColumn(
                    label: Container(child: Text("ID")),
                  ),
                  DataColumn(
                    label: Text("Date"),
                  ),
                  DataColumn(
                    label: Text("Produits"),
                  ),
                  DataColumn(
                    label: Text("Prix"),
                  ),
                  DataColumn(
                    label: Text("Etat"),
                  ),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text(''))
                  ])
                ],
              ),
            ),
          ),
        ],
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
                          "Détail du Client",
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
              height: MediaQuery.of(context).size.height - 110,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                        child: Form(
                          key: _fourFormKey!,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Center(
                              //   child: Text(
                              //     "Modifier les Infos",
                              //     style: TextStyle(
                              //         fontSize: 18, fontWeight: FontWeight.bold),
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().dropdown(
                                                'Statut',
                                                listType,
                                                type!,
                                                _isFourTypeEmpty,
                                                'upd',
                                                widget.selectedClient
                                                    .type_client),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Nom",
                                                false,
                                                nom!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                true),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Telephone",
                                                false,
                                                tel!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Adresse",
                                                false,
                                                adress!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "CNIB",
                                                false,
                                                cnib!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MyFunction().inputFiled(
                                                "Ville",
                                                false,
                                                ville!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
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
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  padding: EdgeInsets.only(top: 3, left: 3),
                                  child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        type!.text.isEmpty
                                            ? _isFourTypeEmpty = false
                                            : _isFourTypeEmpty = true;
                                      });
                                      if (!_fourFormKey!.currentState!
                                          .validate()) {
                                        return;
                                      } else {
                                        Services.updClient(
                                                nom!.text,
                                                type!.text,
                                                ville!.text,
                                                adress!.text,
                                                tel!.text,
                                                cnib!.text,
                                                desc!.text,
                                                widget.selectedClient.id_client)
                                            .then((value) {
                                          if (int.parse(value) == 1) {
                                            ConfirmBox()
                                                .showAlert(
                                                    context,
                                                    "Le Client a été modifié avec succès",
                                                    true)
                                                .then((value) =>
                                                    Navigator.pop(context));
                                          } else if (int.parse(value) == 0) {
                                            ConfirmBox().showAlert(
                                                context,
                                                "Cet Client existe déjà",
                                                false);
                                          } else {
                                            ConfirmBox().showAlert(context,
                                                "Erreur de connexion", false);
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
                                      "Modifier",
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
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  height: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Nom: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget.selectedClient
                                                          .nom_complet_client,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Statut: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget.selectedClient
                                                          .type_client,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Telephone: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget.selectedClient
                                                          .tel_client,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Ville: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget.selectedClient
                                                          .ville_client,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('CNIB: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget.selectedClient
                                                          .cnib_client,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Date_Ajout: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget.selectedClient
                                                          .date_client,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Adresse: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget.selectedClient
                                                          .adress_client,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Utilisateur: ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xFF26345d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      widget.selectedClient
                                                          .user_client,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  // Text('Description: ',
                                                  //     style: TextStyle(
                                                  //         fontSize: 18,
                                                  //         color: Color(0xFF26345d),
                                                  //         fontWeight:
                                                  //             FontWeight.bold)),
                                                  // Text(
                                                  //     widget.selectedClient
                                                  //         .desc_client,
                                                  //     style: TextStyle(
                                                  //       fontSize: 16,
                                                  //       color: Color(0xFF000000),
                                                  //     )),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 500,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        child: Text(
                                          'Achats realisées',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      _fournisseuMove,
                                    ],
                                  ),
                                )
                              ],
                            ),
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

// creation de commande

class ContenuCom {
  String idRav;
  String idProd;
  String idFour;
  String qtsProd;
  String qtsTotal;
  String prixUnit;
  String prixPromo;
  String designation;

  ContenuCom({
    required this.idRav,
    required this.idProd,
    required this.idFour,
    required this.qtsProd,
    required this.qtsTotal,
    required this.prixUnit,
    required this.prixPromo,
    required this.designation,
  });

  Map<String, dynamic> toMap() {
    return {
      'idProd': idProd.toString(),
      'idFour': idFour.toString(),
      'qtsProd': qtsProd.toString(),
      'prixUnit': prixUnit.toString(),
      'designation': designation.toString(),
    };
  }

  factory ContenuCom.fromJson(Map<String, dynamic> json) {
    return ContenuCom(
      idProd: json['idProd'].toString(),
      idFour: json['idFour'].toString(),
      qtsProd: json['qtsProd'].toString(),
      prixUnit: json['prixUnit'].toString(),
      designation: json['designation'].toString(),
      idRav: json['Id_rav'].toString(),
      qtsTotal: json['qtsTotal'].toString(),
      prixPromo: json['promo'].toString(),
    );
  }
}

// set vente quantity
class SetVenteElem extends StatefulWidget {
  final String qtPrix;
  final String nameProd;
  SetVenteElem({
    Key? key,
    required this.qtPrix,
    required this.nameProd,
  }) : super(key: key);

  @override
  _SetVenteElemState createState() => _SetVenteElemState();
}

class _SetVenteElemState extends State<SetVenteElem> {
  TextEditingController? prix;
  TextEditingController? qts;
  bool _isQtsEmpty = false;
  bool _isPrixEmpty = false;
  bool _modify = false;
  bool _edit = false;

  @override
  void initState() {
    prix = TextEditingController();

    qts = TextEditingController();
    if (widget.qtPrix.toString().split('-').length > 1) {
      prix!.text = widget.qtPrix.split('-')[1];
      qts!.text = widget.qtPrix.split('-')[0];
      _modify = true;
      _edit = true;
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
        height: !_modify ? 290 : 340,
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
                  top: 30,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: !_modify ? 190 : 240,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Quantité totale: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          _modify ? widget.qtPrix.split('-')[2] : widget.qtPrix,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9.]'),
                        )
                      ],
                      controller: qts!,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Donner la quantité";
                        }
                      },
                      onSaved: (String? value) {},
                      decoration: InputDecoration(
                        hintText: "Quantité",
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
                    _modify
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                readOnly: _edit,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: prix!,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Donner le Prix";
                                  }
                                },
                                onSaved: (String? value) {},
                                decoration: InputDecoration(
                                  suffixIcon: Container(
                                    height: 48,
                                    color: Colors.red,
                                    child: MaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          _edit = false;
                                        });
                                      },
                                      child: Text('Changer',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                  hintText: "Prix",
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
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
                              Row(children: [
                                Text('Le prix promo est:'),
                                Text(widget.qtPrix.split('-')[3]),
                              ]),
                            ],
                          )
                        : Text(''),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 40,
                          child: MaterialButton(
                            onPressed: () {
                              if (_modify) {
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
                              } else {
                                if (qts!.text.isEmpty) {
                                  setState(() {
                                    _isQtsEmpty = true;
                                  });
                                } else {
                                  setState(() {
                                    _isQtsEmpty = false;
                                  });
                                  if (double.parse(qts!.text) >
                                      double.parse(widget.qtPrix)) {
                                    ConfirmBox().showAlert(
                                        context,
                                        'Rupture de stock. Vous ne pouvez pas commander plus de ' +
                                            widget.qtPrix +
                                            " ",
                                        false);
                                  } else {
                                    Navigator.of(context).pop(
                                        '${double.parse(qts!.text)}-1');
                                  }
                                }
                              }
                            },
                            color: Color(0xFF1B8D41),
                            child: Text(
                              !_modify ? "Valider" : 'Modifier',
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

//gestion des vente au client
class CreatVente extends StatefulWidget {
  final String clientId;
  final String clientName;
  CreatVente({
    Key? key,
    required this.clientId,
    required this.clientName,
  }) : super(key: key);

  @override
  State<CreatVente> createState() => _CreatVenteState();
}

class _CreatVenteState extends State<CreatVente> {
  List<Product>? productList;
  List<Product>? filterProdList;
  List<VenteInfos>? infoCom;
  Product? prod;
  List<ContenuCom> comList = [];
  TextEditingController nbr = TextEditingController();
  bool isloading = true;
  final controle = ScrollController();
  final controle1 = ScrollController();

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
          getVenteInfos();
        }));
  }

  void getVenteInfos() {
    Services.getVenteInfos(widget.clientId).then((value) {
      if (int.parse(value.map((e) => e.venteId).toList()[0]) > 0) {
        setState(() {
          infoCom = value;
          isloading = false;
        });
      }
    });
  }

  double getProdQts(String key) {
    double qts = 0;
    double prix = 0;
    for (int i = 0; i < comList.length; i++) {
      qts += double.parse(comList[i].qtsProd);
      prix +=
          (int.parse(comList[i].prixUnit) * (double.parse(comList[i].qtsProd)));
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
            columnSpacing: 20,
            headingTextStyle: TextStyle(
              color: Color(0xFF26345d),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            horizontalMargin: 30,
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
                          '${(int.parse(e.prixUnit) * double.parse(e.qtsProd))
                                  .toStringAsFixed(1)} Fcfa')),
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
                                      child: SetVenteElem(
                                        nameProd: e.designation,
                                        qtPrix: '${e.qtsProd}-${e.prixUnit}-${e.qtsTotal}-${e.prixPromo}',
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
          columnSpacing: 20,
          headingTextStyle: TextStyle(
            color: Color(0xFF26345d),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          horizontalMargin: 20,
          columns: [
            DataColumn(
              label: Text("Désignation"),
            ),
            DataColumn(
              label: Text("Catégorie"),
            ),
            DataColumn(
              label: Text("Prix_Unit"),
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
                    DataCell(Text(e.designation)),
                    DataCell(Text(e.id_cat)),
                    DataCell(Text("${e.prix} Fcfa")),
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
                                    child: SetVenteElem(
                                      nameProd: e.designation,
                                      qtPrix: e.stock.toString(),
                                    ),
                                  );
                                }).then((value) {
                              if (value.toString().split('-').length > 1) {
                                String qte = value.toString().split('-')[0];
                                setState(() {
                                  comList.add(ContenuCom(
                                      idProd: e.id_prod,
                                      idFour: widget.clientId,
                                      qtsProd: qte.toString(),
                                      prixUnit: e.prix,
                                      designation: e.designation,
                                      idRav: infoCom!
                                          .map((e) => e.venteId)
                                          .toList()[0],
                                      qtsTotal: e.stock.toString(),
                                      prixPromo: e.promo));
                                });
                              }
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
    return Dialog(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: isloading
            ? Center(
                child: Container(
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
                                "Remplissage du contenu de la vente",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (comList.isEmpty) {
                                  ConfirmBox().showAlert(
                                      context,
                                      "La commande ne peut pas être vide. Ajouter un élément",
                                      false);
                                } else {
                                  // Navigator.pop(context);
                                  ConfirmBox().showAlert(
                                      context,
                                      "Cliquer sur Terminer pour quitter",
                                      false);
                                }
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
                    height: MediaQuery.of(context).size.height - 110,
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
                              height: 715,
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
                                            'Commande(${ConfirmBox().numFacture(infoCom!.map((e) => e.dateVente).toList()[0].split(' ')[0].split('-')[0], infoCom!.map((e) => e.venteId).toList()[0])})/${infoCom!.map((e) => e.dateVente).toList()[0].split(' ')[0]}',
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
                                                Text('Client: ',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                  infoCom!
                                                      .map((e) => e.clientName)
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
                                                      .map((e) => e.dateVente)
                                                      .toList()[0]
                                                      .toString()
                                                      .split(' ')[0],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 430,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.black),
                                        ),
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
                                          !comList.isEmpty
                                              ? Container(
                                                  height: 40,
                                                  width: 100,
                                                  child: MaterialButton(
                                                      onPressed: () {
                                                        for (int i = 0;
                                                            i < comList.length;
                                                            i++) {
                                                          Services
                                                              .sendVenteList(
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
                                                                .toString(),
                                                          ).then((value) {
                                                            return value;
                                                          });
                                                        }
                                                        ConfirmBox()
                                                            .showAlert(
                                                                context,
                                                                'La commande a été validée avec succes',
                                                                true)
                                                            .then((value) {
                                                          if (int.parse(
                                                                  value) ==
                                                              1) {
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        });
                                                      },
                                                      color: Color(0xE0099B6A),
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
                                                      'Clent: ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      infoCom!
                                                          .map((e) =>
                                                              e.clientName)
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
                                                    Text('Quantitée: ',
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
                                                        : '${getProdQts('prix')
                                                                .toStringAsFixed(
                                                                    1)} Fcfa'),
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
                                          bottom: 5,
                                          top: 20,
                                        ),
                                        child: Text('Liste des produits',
                                            style: TextStyle(
                                              fontSize: 25,
                                            )),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 10, left: 5),
                                          width: 400,
                                          child: TextField(
                                            controller: seachInput,
                                            decoration: InputDecoration(
                                                suffixIcon: MaterialButton(
                                                  color: Color(0xFF26345d),
                                                  height: 55,
                                                  onPressed: () {
                                                    if (seachInput
                                                        .text.isEmpty) {
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
                                                contentPadding:
                                                    EdgeInsets.all(10),
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
                                                width: 1, color: Colors.black),
                                          ),
                                          height: 540,
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
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white),
                                                          ),
                                                        )
                                                      ],
                                                    ))
                                              ])
                                            ])
                                      ],
                                    ),
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
// fin gestion de vente au client

//ajout de produits au contenu de la vente apres commande
class AddProdVente extends StatefulWidget {
  final String clientId;
  final String idCom;
  final String comDate;
  final String clientName;
  final List<ContenuCom> existCom;
  final controle = ScrollController();
  final controle1 = ScrollController();

  AddProdVente({
    Key? key,
    required this.clientId,
    required this.idCom,
    required this.comDate,
    required this.clientName,
    required this.existCom,
  }) : super(key: key);

  @override
  State<AddProdVente> createState() => _AddProdVenteState();
}

class _AddProdVenteState extends State<AddProdVente> {
  List<Product>? productList;
  List<Product>? filterProdList;
  List<VenteInfos>? infoCom;
  Product? prod;
  List<ContenuCom> comList = [];
  TextEditingController nbr = TextEditingController();
  bool isloading = true;
  final controle = ScrollController();
  final controle1 = ScrollController();

  @override
  void initState() {
    super.initState();
    nbr = TextEditingController();
    comList = [];
    productList = [];
    filterProdList = [];
    infoCom = [];
    getProdList();
  }
// Liste des produits

  void getProdList() {
    Services.getProdList().then((value) {
      if (int.parse(value.map((e) => e.id_prod).toList()[0]) == -1 ||
          int.parse(value.map((e) => e.id_prod).toList()[0]) == -2) {
        setState(() {
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
            productList = value;
          });
        }
      }
    }).then((value) {
      setState(() {
        filterProdList = productList;
      });
    });
    getVenteInfos();
  }

  void getVenteInfos() {
    Services.getVenteInfos(widget.clientId).then((value) {
      if (int.parse(value.map((e) => e.venteId).toList()[0]) > 0) {
        setState(() {
          infoCom = value;
          isloading = false;
        });
      }
    });
  }

  double getProdQts(String key) {
    double qts = 0;
    double prix = 0;
    for (int i = 0; i < widget.existCom.length; i++) {
      qts += double.parse(widget.existCom[i].qtsProd);
      prix += (int.parse(widget.existCom[i].prixUnit) *
          (double.parse(widget.existCom[i].qtsProd)));
    }
    return key == 'prix' ? prix : qts;
  }

  int checkExitProduc(List<ContenuCom> list, String id) {
    int tem = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].idProd.split('-')[0] == id) {
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
            columnSpacing: 20,
            headingTextStyle: TextStyle(
              color: Color(0xFF26345d),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            horizontalMargin: 30,
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
                label: Text("Action"),
              ),
            ],
            rows: widget.existCom
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.idProd)),
                      DataCell(Text(e.designation)),
                      DataCell(
                          Text(double.parse(e.qtsProd).toStringAsFixed(2))),
                      DataCell(Text('${e.prixUnit} Fcfa')),
                      DataCell(
                        Text('${(int.parse(e.prixUnit) * double.parse(e.qtsProd))
                                .toStringAsFixed(2)} Fcfa'),
                      ),
                      DataCell(
                        e.idProd.split('-').length > 1
                            ? Row(
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
                                              child: SetVenteElem(
                                                nameProd: e.designation,
                                                qtPrix: '${e.qtsProd}-${e.prixUnit}-${e.qtsTotal}-${e.prixPromo}',
                                              ),
                                            );
                                          }).then((value) {
                                        String qte =
                                            value.toString().split('-')[0];
                                        String pri =
                                            value.toString().split('-')[1];
                                        setState(() {
                                          for (int i = 0;
                                              i < comList.length;
                                              i++) {
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
                                            widget.existCom.remove(e);
                                          });
                                        }
                                      });
                                    },
                                  ),
                                ],
                              )
                            : Text(''),
                      )
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
          columnSpacing: 10,
          headingTextStyle: TextStyle(
            color: Color(0xFF26345d),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          horizontalMargin: 30,
          columns: [
            DataColumn(
              label: Text("Désignation"),
            ),
            DataColumn(
              label: Text("Catégorie"),
            ),
            DataColumn(
              label: Text("Prix_Unit"),
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
                    DataCell(Text(e.designation)),
                    DataCell(Text(e.id_cat)),
                    DataCell(Text("${e.prix} Fcfa")),
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

                          if (checkExitProduc(widget.existCom, e.id_prod) ==
                              1) {
                            ConfirmBox().showAlert(context,
                                "Cet produit est déjà selectionné.", false);
                          } else {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Align(
                                    alignment: Alignment(1, 0),
                                    child: SetVenteElem(
                                      nameProd: e.designation,
                                      qtPrix: e.stock.toString(),
                                    ),
                                  );
                                }).then((value) {
                              if (value.toString().split('-').length > 1) {
                                String qte = value.toString().split('-')[0];

                                setState(() {
                                  comList.add(
                                    ContenuCom(
                                        idProd: '${e.id_prod}-1',
                                        idFour: widget.clientId,
                                        qtsProd: double.parse(qte)
                                            .toStringAsFixed(2),
                                        prixUnit: e.prix,
                                        designation: e.designation,
                                        idRav: widget.idCom,
                                        qtsTotal: e.stock.toString(),
                                        prixPromo: e.promo),
                                  );
                                  widget.existCom
                                      .add(comList[comList.length - 1]);
                                });
                              }
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
    return Dialog(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: isloading
            ? Center(
                child: Container(
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
                                "Remplissage du contenu de la vente",
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
                    height: MediaQuery.of(context).size.height - 110,
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
                                            'Commande(${ConfirmBox().numFacture(widget.comDate.split(' ')[0].split('-')[0], widget.idCom)})/${widget.comDate.split(' ')[0]}',
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
                                                Text('Client: ',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                  infoCom!
                                                      .map((e) => e.clientName)
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
                                                      .map((e) => e.dateVente)
                                                      .toList()[0]
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 410,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                        ),
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
                                          !comList.isEmpty
                                              ? Container(
                                                  height: 40,
                                                  width: 100,
                                                  child: MaterialButton(
                                                      onPressed: () {
                                                        for (int i = 0;
                                                            i < comList.length;
                                                            i++) {
                                                          Services.sendVenteList(
                                                                  comList[i]
                                                                          .idProd
                                                                          .toString()
                                                                          .split(
                                                                              '-')[
                                                                      0],
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
                                                              .then((value) {
                                                            return value;
                                                          });
                                                        }
                                                        ConfirmBox()
                                                            .showAlert(
                                                                context,
                                                                'Les produits ont été ajouté à la commande avec succes',
                                                                true)
                                                            .then((value) {
                                                          if (int.parse(
                                                                  value) ==
                                                              1) {
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        });
                                                      },
                                                      color: Color(0xE0099B6A),
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
                                                      'Clent: ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      infoCom!
                                                          .map((e) =>
                                                              e.clientName)
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
                                                    Text(widget.existCom.isEmpty
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
                                                    Text(widget.existCom.isEmpty
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
                                          top: 10,
                                        ),
                                        child: Text('Liste des produits',
                                            style: TextStyle(
                                              fontSize: 25,
                                            )),
                                      ),
                                    ),
                                    Container(
                                      width: 400,
                                      child: TextField(
                                        decoration: InputDecoration(
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
                                    SizedBox(height: 10),
                                    Container(
                                      height: 570,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.black,
                                        ),
                                      ),
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
// fin ajouter produits de vente apres commande

// Voir la vente
class VenteCommande extends StatefulWidget {
  final VenteModel selectCom;
  VenteCommande({
    Key? key,
    required this.selectCom,
  }) : super(key: key);

  @override
  State<VenteCommande> createState() => _VenteCommandeState();
}

class _VenteCommandeState extends State<VenteCommande> {
  List<ContenuCom> comList = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    comList = [];
    isloading = true;
    getVenteCnt();
  }

// recuperation du contenu de la commande
  void getVenteCnt() {
    Services.getVenteContent(widget.selectCom.idCom).then((value) {
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
          isloading = false;
        });
      }
    });
  }

//calcule de la quantite produit de la commande
  double getProdQts(String key) {
    double qts = 0;
    double prix = 0;
    for (int i = 0; i < comList.length; i++) {
      qts += double.parse(comList[i].qtsProd);
      prix +=
          (int.parse(comList[i].prixUnit) * (double.parse(comList[i].qtsProd)));
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
                  columnSpacing: 100,
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
                            DataCell(Text('${int.parse(e.prixUnit) *
                                        double.parse(e.qtsProd)} Fcfa')),
                            DataCell(widget.selectCom.is_print_com == '0'
                                ? Row(
                                    children: [
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
                                            if (int.parse(value) != 0) {
                                              Services.deleteVenteItem(
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
                                                          getVenteCnt());
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
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : Icon(
                                    Icons.check,
                                    color: Colors.green,
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
                          "Détail de la commande",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (comList.isEmpty) {
                            ConfirmBox().showAlert(
                                context,
                                "La commande ne peut pas être vide. Ajouter un élément",
                                false);
                          } else {
                            Navigator.pop(context);
                          }
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
                    height: MediaQuery.of(context).size.height - 110,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Container(
                        height: 680,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Client: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          Text(widget.selectCom.clientName,
                                              style: TextStyle(
                                                fontSize: 16,
                                              )),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 2, right: 2, top: 5),
                                        margin:
                                            EdgeInsets.only(bottom: 5, top: 10),
                                        child: Text(
                                            'Commande(${ConfirmBox().numFacture(widget.selectCom.comDate.split('-')[0], widget.selectCom.idCom)})/${widget.selectCom.comDate}',
                                            style: TextStyle(
                                              fontSize: 25,
                                            )),
                                      ),
                                      Row(
                                        children: [
                                          Text('Date: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text(widget.selectCom.comDate,
                                              style: TextStyle(
                                                fontSize: 16,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Container(
                                    height: 400,
                                    padding: EdgeInsets.only(
                                        left: 2, right: 2, top: 5),
                                    child: _fournisseuMove,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      int.parse(widget
                                                  .selectCom.is_print_com) ==
                                              0
                                          ? CircleAvatar(
                                              backgroundColor:
                                                  Color(0xFF11A75C),
                                              radius: 30,
                                              child: Center(
                                                child: IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AddProdVente(
                                                              clientId: widget
                                                                  .selectCom
                                                                  .idClient,
                                                              idCom: widget
                                                                  .selectCom
                                                                  .idCom,
                                                              comDate: widget
                                                                  .selectCom
                                                                  .comDate,
                                                              clientName: widget
                                                                  .selectCom
                                                                  .clientName,
                                                              existCom:
                                                                  comList);
                                                        }).then((value) {
                                                      setState(() {
                                                        getVenteCnt();
                                                      });
                                                    });
                                                  },
                                                  icon: Icon(Icons.add),
                                                  iconSize: 40,
                                                  color: Colors.white,
                                                ),
                                              ),
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
                                                Text('Quantitée: ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    comList.isEmpty
                                                        ? '0'
                                                        : getProdQts('qts')
                                                            .toStringAsFixed(2),
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
                                                        : '${getProdQts('prix')
                                                                .toStringAsFixed(
                                                                    2)} Fcfa',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
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
// Fin voir vente

// Impression facture pour client

class CreeFacture extends StatefulWidget {
  final VenteModel selectCom;
  CreeFacture({
    Key? key,
    required this.selectCom,
  }) : super(key: key);

  @override
  State<CreeFacture> createState() => _CreeFactureState();
}

class _CreeFactureState extends State<CreeFacture> {
  List<ContenuCom> comList = [];
  List<FourPay>? clientPay;
  List<ClientModel>? clienList;
  List<CommandeContent>? contenu;
  ResumerFacture? resumeFact;
  ClientModel? selectedClient;
  String payTyle = "credit";
  List<String> payTypes = [];
  CommandeDetaile? comDetails;
  LogoCompany? logoComp;
  ClientAdress? clientAdress;
  String user = '';
  List role = ['SECRET1', 'SECRET2'];

  bool isloading = true;

  @override
  void initState() {
    super.initState();
    comList = [];
    clientPay = [];
    contenu = [];
    isloading = true;
    payTyle = "credit";
    getVenteCnt();
    getVentePay();
    getClientList();
  }

// recuperation du contenu de la commande
  void getVenteCnt() {
    Services.getVenteContent(widget.selectCom.idCom).then((value) {
      if (int.parse(value.map((e) => e.idRav).toList()[0]) == 0) {
        ConfirmBox().showAlert(context, "Aucun contenu trouvé", false);
        setState(() {
          comList = [];
          isloading = false;
        });
      } else if (int.parse(value.map((e) => e.idRav).toList()[0]) < 0) {
        setState(() {
          comList = [];
          isloading = true;
        });
        ConfirmBox().showAlert(context, "Erreur de connexion", false);
      } else {
        setState(() {
          comList = value;
          isloading = false;
        });
      }
    });
  }

//calcule de la quantite produit de la commande
  double getProdQts(String key) {
    double qts = 0;
    double prix = 0;
    for (int i = 0; i < comList.length; i++) {
      qts += double.parse(comList[i].qtsProd);
      prix +=
          (int.parse(comList[i].prixUnit) * (double.parse(comList[i].qtsProd)));
    }
    return key == 'prix' ? prix : qts;
  }

  //recuperation des informations de pay d'une vente donnee
  void getVentePay() {
    Services.getVentePay(widget.selectCom.idCom).then((value) {
      if (int.parse(value.map((e) => e.totalPay).toList()[0]) >= 0) {
        clientPay = value;
        payTypes = value.map((e) => e.typePay).toList();
        payTyle = value.map((e) => e.typePay).toList()[0];
        setState(() {
          isloading = false;
        });
      } else {
        ConfirmBox()
            .showAlert(context, 'Erreur de connexion', false)
            .then((val) {});
        setState(() {
          isloading = true;
        });
      }
    });
  }

  // Calcule de somme paye
  int calculateAmountPAy(List<FourPay>? clientPayListe) {
    int total = 0;
    for (int i = 0; i < clientPayListe!.length; i++) {
      total += int.parse(clientPayListe[i].amountPay);
    }
    return total;
  }

  // recuperation des infos des clients
  getClientList() {
    Services.getOneClients(widget.selectCom.idClient).then((value) {
      if (int.parse(value.map((e) => e.id_client).toList()[0]) == 0) {
        ConfirmBox().showAlert(context, 'Aucun client trouvé', false);
        setState(() {
          clienList = [];
          isloading = false;
        });
      } else if (int.parse(value.map((e) => e.id_client).toList()[0]) > 0) {
        setState(() {
          selectedClient = value.map((e) => e).toList()[0];
          isloading = false;
        });
      } else if (int.parse(value.map((e) => e.id_client).toList()[0]) < 0) {
        ConfirmBox().showAlert(context, 'Erreur de connexion', false);
        setState(() {
          isloading = true;
        });
      }
    });
  }

  void imprime(addresse, List<String> payTypes) async {
    comDetails = CommandeDetaile(
        factureNum: ConfirmBox().numFacture(
            widget.selectCom.comDate.split('-')[0], widget.selectCom.idCom),
        factureDate: widget.selectCom.comDate,
        payType: payTypes);
    clientAdress = ClientAdress(
        name: selectedClient!.nom_complet_client,
        adresse: selectedClient!.adress_client);
    resumeFact = ResumerFacture(
        total: getProdQts('prix').toStringAsFixed(2),
        paye: calculateAmountPAy(clientPay).toStringAsFixed(2),
        rest: (getProdQts('prix') - calculateAmountPAy(clientPay))
            .toStringAsFixed(2));
    final pdfFile = await PdfInvoiceApi.generate(
        addresse,
        logoComp!,
        comDetails!,
        clientAdress!,
        selectedClient!.tel_client,
        comList,
        resumeFact!,
        widget.selectCom.user);
    PdfInvoiceApi.onpenFile(pdfFile)
        .then((value) =>
            ConfirmBox().showAlert(context, "Impression en cours", true))
        .then((value) => Navigator.of(context).pop('1'));
  }

  void getAdress() {
    Services.getCompayDetail('/company').then((value) {
      if (int.parse(value.id) > 0) {
        setState(() {
          logoComp = LogoCompany(value.slogan_com, value.nom_com, value.adress);
        });
        return value.adress +
            ' Tel: ' +
            value.tel_com +
            ' / ' +
            value.tel2_com +
            ' / ' +
            value.tel3_com;
      } else if (int.parse(value.id) == 0) {
        ConfirmBox()
            .showAlert(context, "Impossible d'imprimer la facture", false);
        return '0';
      } else if (int.parse(value.id) < 0) {
        ConfirmBox().showAlert(context, 'Erreur de connextion', false);
        return '0';
      }
    }).then((value1) {
      List<String> paymentTypes = [];
      List<String> excepPayType = ['Espèce', "Versement"];
      if (value1 != '0') {
        Services.getpayNumber(widget.selectCom.idCom).then((value) {
          var data = jsonDecode(value)['data'];
          if (data['statut'] >= 0) {
            if (data['statut'] == 1) {
              for (var nume in data['donnee']) {
                for (var type in payTypes) {
                  if (type.split("=>")[1] ==
                      nume['number_num'].toString().split("=>")[1]) {
                    paymentTypes.add("${type.split('=>')[0]}(${nume['number_num'].toString().split("=>")[0]})");
                  }
                }
              }
            }

            for (var elm in payTypes) {
              if (excepPayType.contains(elm.split("=>")[0])) {
                paymentTypes.add(elm.split("=>")[0]);
              }
            }
            Loader.hide();
            imprime(value1, paymentTypes);
          } else {
            ConfirmBox().showAlert(context, 'Erreur de connexion', false);
          }
        });
      }
    });
  }

  final controller = ScrollController();
  SingleChildScrollView get _fournisseuMove {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: DataTable(
            columnSpacing: 100,
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
            ],
            rows: comList
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.idProd)),
                      DataCell(Text(e.designation)),
                      DataCell(Text(double.parse(e.qtsProd).toString())),
                      DataCell(Text('${e.prixUnit} Fcfa')),
                      DataCell(Text(
                          '${(int.parse(e.prixUnit) * double.parse(e.qtsProd))
                                  .toStringAsFixed(2)} Fcfa')),
                    ],
                  ),
                )
                .toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          user = state.user!.nom.toString();
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
                                "Détail de la commande",
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
                          height: MediaQuery.of(context).size.height - 110,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    height: 718,
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 2, right: 2, top: 5),
                                                margin: EdgeInsets.only(
                                                    bottom: 5, top: 10),
                                                child: Row(
                                                  children: [
                                                    Text('Client: ',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(
                                                        widget.selectCom
                                                            .clientName,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 2, right: 2, top: 5),
                                                margin: EdgeInsets.only(
                                                    bottom: 5, top: 10),
                                                child: Text(
                                                    'Commande(${ConfirmBox().numFacture(widget.selectCom.comDate.split(' ')[0].split('-')[0], widget.selectCom.idCom)})/${widget.selectCom.comDate.split(' ')[0]}',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    )),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 2, right: 2, top: 5),
                                                margin: EdgeInsets.only(
                                                    bottom: 5, top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text('Date: ',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(
                                                        widget
                                                            .selectCom.comDate,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider(),
                                        Container(
                                          height: 475,
                                          padding: EdgeInsets.only(
                                              left: 2, right: 2, top: 5),
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
                                            child: Container(
                                              height: 400,
                                              child: _fournisseuMove,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: comList.isEmpty
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            role.contains(state.user!.droit
                                                    .toString()
                                                    .toUpperCase())
                                                ? Text('')
                                                : Container(
                                                    height: 50,
                                                    width: 120,
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: MaterialButton(
                                                        onPressed: () {
                                                          if (getProdQts('prix') -
                                                                      calculateAmountPAy(
                                                                          clientPay) >
                                                                  0 &&
                                                              int.parse(widget
                                                                      .selectCom
                                                                      .is_print_com) ==
                                                                  0) {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    false,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return CreditPrint(
                                                                    qtPrix: getProdQts(
                                                                            'prix')
                                                                        .toString(),
                                                                    reste: '${getProdQts('prix') - calculateAmountPAy(clientPay)}-${clientPay!
                                                                            .map((e) =>
                                                                                e.typePay)
                                                                            .toList()[0]}',
                                                                    idCom: widget
                                                                        .selectCom
                                                                        .idCom,
                                                                  );
                                                                }).then((value) {
                                                              if (int.parse(
                                                                      value) ==
                                                                  1) {
                                                                getAdress();
                                                              }
                                                            });
                                                          } else {
                                                            // getAdress();
                                                            loader(context);
                                                            Services.notifyPrint(
                                                                    widget
                                                                        .selectCom
                                                                        .idCom)
                                                                .then((value) {
                                                              if (int.parse(
                                                                      value) ==
                                                                  0) {
                                                                ConfirmBox()
                                                                    .showAlert(
                                                                        context,
                                                                        "L'impression a échouée. Réessayer encore",
                                                                        false);
                                                              } else if (int.parse(
                                                                      value) ==
                                                                  1) {
                                                                getAdress();
                                                              } else if (int
                                                                      .parse(
                                                                          value) <
                                                                  0) {
                                                                ConfirmBox()
                                                                    .showAlert(
                                                                        context,
                                                                        "Erreur de connexion ",
                                                                        false);
                                                              }
                                                            });
                                                          }
                                                        },
                                                        color:
                                                            Color(0xFF0D8D42),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.print,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                              "Imprimer",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                            (getProdQts('prix') -
                                                        calculateAmountPAy(
                                                            clientPay)) >
                                                    0
                                                ? int.parse(widget.selectCom
                                                            .is_print_com) ==
                                                        0
                                                    ? Container(
                                                        height: 50,
                                                        width: 120,
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        child: MaterialButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Align(
                                                                        alignment: Alignment(
                                                                            1,
                                                                            0),
                                                                        child:
                                                                            PayVente(
                                                                          qtPrix:
                                                                              getProdQts('prix').toString(),
                                                                          reste: '${getProdQts('prix') - calculateAmountPAy(clientPay)}-${clientPay!.map((e) => e.typePay).toList()[0]}',
                                                                          idCom: widget
                                                                              .selectCom
                                                                              .idCom,
                                                                          idClient: widget
                                                                              .selectCom
                                                                              .idClient,
                                                                          agent: state
                                                                              .user!
                                                                              .droit
                                                                              .toString(),
                                                                        ));
                                                                  }).then((value) {
                                                                if (value
                                                                        .toString()
                                                                        .split(
                                                                            '-')
                                                                        .length >
                                                                    1) {
                                                                  Services.clientNewPaiement(
                                                                          value.toString().split('-')[
                                                                              0],
                                                                          value.toString().split('-')[
                                                                              1],
                                                                          getProdQts('prix').toStringAsFixed(
                                                                              2),
                                                                          comList.map((e) => e.idRav).toList()[
                                                                              0],
                                                                          value.toString().split('-')[
                                                                              2],
                                                                          value.toString().split('-')[
                                                                              4])
                                                                      .then(
                                                                          (value) {
                                                                    if (int.parse(
                                                                            value) ==
                                                                        0) {
                                                                      ConfirmBox().showAlert(
                                                                          context,
                                                                          "Paiement echoué",
                                                                          false);
                                                                    } else if (int.parse(
                                                                            value) <
                                                                        0) {
                                                                      ConfirmBox().showAlert(
                                                                          context,
                                                                          "Erreur de connexion",
                                                                          false);
                                                                    } else {
                                                                      ConfirmBox()
                                                                          .showAlert(
                                                                              context,
                                                                              'Paiement effectuée avec success',
                                                                              true)
                                                                          .then(
                                                                              (value) {
                                                                        if (int.parse(value) ==
                                                                            1) {
                                                                          getVentePay();
                                                                        }
                                                                      });
                                                                    }
                                                                  });

                                                                  if (int.parse(value
                                                                          .toString()
                                                                          .split(
                                                                              '-')[3]) !=
                                                                      0) {
                                                                    Services.addPayNumber(
                                                                        widget
                                                                            .selectCom
                                                                            .idCom,
                                                                        value.toString().split('-')[
                                                                            3],
                                                                        state
                                                                            .user!
                                                                            .id
                                                                            .toString());
                                                                  }
                                                                }
                                                              });
                                                            },
                                                            color: Color(
                                                                0xFFE76006),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                    Icons.money,
                                                                    color: Colors
                                                                        .white),
                                                                Text(
                                                                  "Payer",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            )),
                                                      )
                                                    : Text('')
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
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          widget.selectCom.user,
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
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          comList.isEmpty
                                                              ? '0'
                                                              : getProdQts(
                                                                      'qts')
                                                                  .toStringAsFixed(
                                                                      2),
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
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          comList.isEmpty
                                                              ? ' 0 '
                                                              : '${getProdQts(
                                                                          'prix')
                                                                      .toStringAsFixed(
                                                                          2)} Fcfa',
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
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          '${calculateAmountPAy(
                                                                      clientPay)
                                                                  .toStringAsFixed(
                                                                      2)} Fcfa',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .green)),
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
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          '${(getProdQts('prix') -
                                                                      calculateAmountPAy(
                                                                          clientPay))
                                                                  .toStringAsFixed(
                                                                      2)} Fcfa',
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
        });
  }
}
// fin impression facture pour

// Impression a credit
class CreditPrint extends StatefulWidget {
  final String qtPrix;
  final String reste;
  final String idCom;
  CreditPrint({
    Key? key,
    required this.qtPrix,
    required this.reste,
    required this.idCom,
  }) : super(key: key);

  @override
  _CreditPrintState createState() => _CreditPrintState();
}

class _CreditPrintState extends State<CreditPrint> {
  TextEditingController? _finDate;
  bool _isDateSelect = false;
  DateTime _date = DateTime.now();
  @override
  void initState() {
    _finDate = TextEditingController();
    _isDateSelect = false;

    super.initState();
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
        _finDate!.text = date.toString();
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
            child: Container(
              height: 300,
              width: 450,
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
                                "Création de credit",
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "La commande n'est pas entièrement regleé. Elle sera considerée comme credit. Vous devez choisir la date limite de remboursement du credit.",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Text(
                            'Choisir la date limite',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: _handleDate,
                            controller: _finDate,
                            onSaved: (String? value) {},
                            decoration: InputDecoration(
                              hintText: "Choissez la date limite",
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _isDateSelect
                                          ? Color(0xFFDA0F0F)
                                          : Color(0xFF171817),
                                      width: 1)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _isDateSelect
                                          ? Color(0xFFDA0F0F)
                                          : Color(0xFF171817),
                                      width: 1)),
                              suffixIcon: Container(
                                height: 50,
                                child: MaterialButton(
                                  onPressed: () {
                                    if (_finDate!.text.isEmpty) {
                                      setState(() {
                                        _isDateSelect = true;
                                      });
                                    } else {
                                      Services.sendCredit(
                                              widget.reste.split('-')[0],
                                              _finDate!.text,
                                              widget.idCom,
                                              state.user!.id.toString())
                                          .then((value) {
                                        if (int.parse(value) == 1) {
                                          Navigator.of(context).pop('1');
                                        } else if (int.parse(value) == 0) {
                                          ConfirmBox().showAlert(
                                              context,
                                              'Erreur!! Veuillez réessayer',
                                              false);
                                        } else if (int.parse(value) < 0) {
                                          ConfirmBox().showAlert(context,
                                              'Erreur de connexion', false);
                                        }
                                      });
                                    }
                                  },
                                  color: Color(0xFF1B8D41),
                                  child: Text(
                                    "Imprimer",
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
                          _isDateSelect
                              ? Container(
                                  child: Text(
                                    "Veuillez choisir une date",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              : Text(''),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }
}

//ajouter un produit usé

class AddProduitUse extends StatefulWidget {
  ProduitUseModel? produit_use;
  final bool is_add;
  AddProduitUse({Key? key, this.produit_use, required this.is_add})
      : super(key: key);

  @override
  State<AddProduitUse> createState() => _AddProduitUseState();
}

class _AddProduitUseState extends State<AddProduitUse> {
  TextEditingController? designation;
  TextEditingController? prix;
  TextEditingController? desc;
  TextEditingController? user;
  TextEditingController? selected_prod;
  TextEditingController? quantite;
  TextEditingController? id_prod;
  TextEditingController? id_cat;
  TextEditingController? id_prod_use;
  List<String>? productList;

  GlobalKey<FormState>? _fourFormKey;

  @override
  void initState() {
    super.initState();
    productList = [];
    designation = TextEditingController();
    prix = TextEditingController();
    desc = TextEditingController();
    user = TextEditingController();
    selected_prod = TextEditingController();
    id_prod = TextEditingController();
    id_prod_use = TextEditingController();
    id_cat = TextEditingController();
    quantite = TextEditingController();
    if (!widget.is_add) {
      designation!.text = widget.produit_use!.designation;
      prix!.text = widget.produit_use!.prix;
      desc!.text = widget.produit_use!.desc;
      id_prod_use!.text = widget.produit_use!.id;
      id_prod!.text = widget.produit_use!.idProd;
      id_cat!.text = widget.produit_use!.idCat;
      quantite!.text = widget.produit_use!.qts;
    }
    _fourFormKey = GlobalKey<FormState>();
    getProdList();
  }

  void getProdList() {
    Services.getProdList().then((value) {
      if (int.parse(value.map((e) => e.id_prod).toList()[0]) == -1 ||
          int.parse(value.map((e) => e.id_prod).toList()[0]) == -2) {
        setState(() {
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
            productList = value
                .map((e) => '${e.id_prod} => ${e.designation}=>${e.prix}')
                .toList();
          });
        }
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
                          value: selected_prod!.text,
                          required: false,
                          strict: false,
                          labelText: 'Rechercher un produit',
                          items: productList,
                          itemsVisibleInDropdown: 11,
                          onValueChanged: (dynamic newValue) {
                            selected_prod!.text = newValue;
                          }),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(selected_prod!.text);
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
                              selected_prod!.text = "";
                            });
                            Navigator.of(context).pop("0");
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
                                "Ajouter un produit usé",
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
                    child: Row(
                      children: [
                        Form(
                          key: _fourFormKey!,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 233,
                                          padding: EdgeInsets.only(right: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Choisir le produit',
                                                style: (TextStyle(
                                                    fontSize: 17,
                                                    color: Color(0xFF3E413E),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                readOnly: true,
                                                keyboardType:
                                                    TextInputType.text,
                                                maxLines: 1,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                    RegExp(
                                                        r'[0-9A-Za-z-.@éèàêî/ ]'),
                                                  ),
                                                ],
                                                controller: designation!,
                                                validator: (String? value) {
                                                  if (value!.isEmpty) {
                                                    return "Veuillez sélectionner un client ";
                                                  }
                                                },
                                                onTap: () {
                                                  showGlobalDrawer(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder:
                                                              _venteHorizontalDrawerBuilder,
                                                          direction:
                                                              AxisDirection
                                                                  .right)
                                                      .then((value) {
                                                    if (value
                                                            .toString()
                                                            .split("=>")
                                                            .length >
                                                        2) {
                                                      setState(() {
                                                        designation!.text =
                                                            selected_prod!.text
                                                                .split("=>")[1];
                                                        prix!.text =
                                                            selected_prod!.text
                                                                .split("=>")[2];
                                                        id_prod!.text =
                                                            selected_prod!.text
                                                                .split("=>")[0];
                                                      });
                                                    }
                                                  });
                                                },
                                                onSaved: (String? value) {},
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Sélectionner un produit",
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xFF080808),
                                                        width: 1),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xFF080808),
                                                        width: 1),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 233,
                                          padding: EdgeInsets.only(right: 5),
                                          child: MyFunction().inputFiled(
                                              "Prix",
                                              false,
                                              prix!,
                                              TextInputType.text,
                                              true,
                                              1,
                                              0,
                                              true),
                                        ),
                                        Container(
                                          width: 233,
                                          padding: EdgeInsets.only(right: 5),
                                          child: MyFunction().inputFiled(
                                              "Quantitée",
                                              false,
                                              quantite!,
                                              TextInputType.number,
                                              true,
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
                                      if (!_fourFormKey!.currentState!
                                          .validate()) {
                                        return;
                                      } else {
                                        if (widget.is_add) {
                                          Services.addProduitUse(
                                                  id_prod!.text,
                                                  prix!.text,
                                                  quantite!.text,
                                                  desc!.text,
                                                  state.user!.id.toString())
                                              .then((value) {
                                            if (int.parse(value) < 0) {
                                              ConfirmBox().showAlert(context,
                                                  "Erreur de connexion", false);
                                            } else {
                                              if (int.parse(value) == 0) {
                                                ConfirmBox().showAlert(context,
                                                    "Opération echouée", false);
                                              } else {
                                                ConfirmBox()
                                                    .showAlert(
                                                        context,
                                                        "Opération réussi !!",
                                                        true)
                                                    .then((value) {
                                                  setState(() {
                                                    id_prod!.text = "";
                                                    prix!.text = "";
                                                    quantite!.text = "";
                                                    desc!.text = "";
                                                    selected_prod!.text = "";
                                                    designation!.text = "";
                                                  });
                                                });
                                              }
                                            }
                                          });
                                        } else {
                                          Services.modifyProduitUse(
                                                  id_prod!.text,
                                                  prix!.text,
                                                  quantite!.text,
                                                  desc!.text,
                                                  state.user!.id.toString(),
                                                  id_prod_use!.text)
                                              .then((value) {
                                            if (int.parse(value) < 0) {
                                              ConfirmBox().showAlert(context,
                                                  "Erreur de connexion", false);
                                            } else {
                                              if (int.parse(value) == 0) {
                                                ConfirmBox().showAlert(context,
                                                    "Opération echouée", false);
                                              } else {
                                                ConfirmBox().showAlert(
                                                    context,
                                                    "Modification réussi !!",
                                                    true);
                                              }
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
                                      !widget.is_add ? "Modifier" : "Ajouter",
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
                  )
                ],
              ),
            ),
          );
        });
  }
}
