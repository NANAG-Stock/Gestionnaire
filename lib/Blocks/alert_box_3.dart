// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_constructors_in_immutables, unused_field, sized_box_for_whitespace, body_might_complete_normally_nullable, avoid_unnecessary_containers

//Paiement de vente
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/alert_box_2.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/function.dart';
import 'package:application_principal/Blocks/pdf_invoice.dart';
import 'package:application_principal/Blocks/text_input.dart';
import 'package:application_principal/Screens/bon_de_sortie.dart';
import 'package:application_principal/Screens/caisier/caiss_bon_de_sortie.dart';
import 'package:application_principal/Screens/excel.dart';
import 'package:application_principal/Screens/secret2/secret2_bon_de_sortie.dart';
import 'package:application_principal/database/annex_bout_model.dart';
import 'package:application_principal/database/bon_info_model.dart';
import 'package:application_principal/database/bon_sortie_model.dart';
import 'package:application_principal/database/company_model.dart';
import 'package:application_principal/database/compte_versement_model.dart';
import 'package:application_principal/database/contenu_bon.dart';
import 'package:application_principal/database/credit_model.dart';
import 'package:application_principal/database/product.dart';
import 'package:application_principal/database/remboursement_model.dart';
import 'package:application_principal/database/services.dart';
import 'package:application_principal/database/track_cpt_achat.dart';
import 'package:application_principal/database/versement_model.dart';
import 'package:badges/badges.dart';
import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PayVente extends StatefulWidget {
  final String qtPrix;
  final String reste;
  final String idCom;
  final String idClient;
  final String agent;
  PayVente({
    Key? key,
    required this.qtPrix,
    required this.reste,
    required this.idCom,
    required this.idClient,
    required this.agent,
  }) : super(key: key);

  @override
  _PayVenteState createState() => _PayVenteState();
}

class _PayVenteState extends State<PayVente> {
  TextEditingController? payType;
  TextEditingController? numero;
  TextEditingController? amountPayed;
  TextEditingController? user;
  bool _isPaytypeEmpty = true;
  bool _isNumeEmpty = false;
  bool _isamountPayedEmpty = false;
  bool _existVer = false;
  bool numAdded = false;
  String verseVal = '0';
  List<String> payTypes = [
    'Espèce',
    'Chèque',
    'Orange Money',
    'Moov Money',
    'Versement'
  ];
  List droit = ['SECRET1', 'SECRET2'];
  bool dropdownChanged = false;
  bool _isVers = false;

  @override
  void initState() {
    payType = TextEditingController();
    numero = TextEditingController();
    user = TextEditingController();
    // if (widget.reste.split('-')[1] != '0') {
    //   payType!.text = widget.reste.split('-')[1];
    // }
    payType!.text = payTypes[0];
    amountPayed = TextEditingController();
    _isPaytypeEmpty = true;
    _isNumeEmpty = false;
    _isamountPayedEmpty = false;
    _existVer = false;
    _isVers = false;
    numAdded = false;
    getVersement();
    super.initState();
  }

  void getVersement() {
    Services.getSingleVers(widget.idClient).then((value) {
      if (int.parse(value) < 0) {
        ConfirmBox()
            .showAlert(context, 'Erreur de connexion', false)
            .then((value) => Navigator.of(context).pop('1'));
      } else if (int.parse(value) > 0) {
        setState(() {
          _existVer = true;
          _isVers = true;
          verseVal = value;
        });
      }
    });
  }

  void setval(String droits) {
    if (widget.reste.split('-')[1] == '0') {
      if (!dropdownChanged) {
        if (droit.contains(droits.toUpperCase())) {
          payType!.text = 'Chèque';
          numAdded = true;
        } else {
          payType!.text = payTypes[0];
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          user!.text = state.user!.id.toString();
          setval(user!.text);
          return Dialog(
            elevation: 20,
            child: Container(
              height: widget.reste.split('-')[1] == '0' ? 470 : 450,
              width: 450,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                "Paiement de la commande",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop('1');
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
                            Text(
                                '${double.parse(widget.qtPrix).toStringAsFixed(2)} Fcfa',
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
                            Text(
                                '${double.parse(widget.reste.split('-')[0])
                                        .toStringAsFixed(2)} Fcfa',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ))
                          ],
                        ),
                        SizedBox(height: 30),
                        Column(
                          children: [
                            DropdownButtonFormField(
                                value: droit.contains(state.user!.droit
                                        .toString()
                                        .toUpperCase())
                                    ? 'Chèque'
                                    : 'Espèce',
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: _isPaytypeEmpty
                                              ? Color(0xFF0D8D42)
                                              : Color(0xFFE70C0C),
                                          width: 1)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isPaytypeEmpty
                                            ? Color(0xFF0D8D42)
                                            : Color(0xFFE70C0C),
                                        width: 1),
                                  ),
                                ),
                                hint: Text(
                                  'Choisir un moyen de paiement',
                                  style: TextStyle(color: Color(0xFF3E413E)),
                                ),
                                onChanged: (dynamic value) {
                                  setState(() {
                                    dropdownChanged = true;
                                    payType!.text = value;
                                    if (value == 'Orange Money' ||
                                        value == 'Moov Money' ||
                                        value == 'Chèque' ||
                                        value == 'Versement') {
                                      if (value == 'Versement') {
                                        _isVers = true;
                                      } else {
                                        _isVers = false;
                                      }
                                      numAdded = true;
                                    } else {
                                      _isVers = false;
                                      numAdded = false;
                                      numero!.text = '';
                                    }
                                  });
                                },
                                items: droit.contains(state.user!.droit
                                        .toString()
                                        .toUpperCase())
                                    ? ['Chèque', 'Orange Money', 'Moov Money']
                                        .map((String? e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(e!,
                                              style: TextStyle(
                                                  color: Color(0xFF3E413E))),
                                        );
                                      }).toList()
                                    : state.user!.droit
                                                .toString()
                                                .toUpperCase() ==
                                            'CAISSE'
                                        ? [
                                            'Espèce',
                                            'Versement',
                                          ].map((String? e) {
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e!,
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFF3E413E))),
                                            );
                                          }).toList()
                                        : [
                                            'Espèce',
                                            'Versement',
                                            'Chèque',
                                            'Orange Money',
                                            'Moov Money'
                                          ].map((String? e) {
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e!,
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFF3E413E))),
                                            );
                                          }).toList()),
                            SizedBox(
                              height: 10,
                            ),
                            !numAdded
                                ? Text('')
                                : Column(
                                    children: [
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'),
                                          ),
                                        ],
                                        controller: numero!,
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return _isVers
                                                ? "Entrer le numéro du compte de versemente"
                                                : "Entrer le numéro de transfert";
                                          }
                                        },
                                        onSaved: (String? value) {},
                                        decoration: InputDecoration(
                                          hintText: _isVers
                                              ? "Numéro du compte de versement"
                                              : "Numéro de transfert",
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: _isNumeEmpty
                                                      ? Color(0xFFDA0F0F)
                                                      : Color(0xFF171817),
                                                  width: 1)),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: _isNumeEmpty
                                                      ? Color(0xFFDA0F0F)
                                                      : Color(0xFF171817),
                                                  width: 1)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )
                          ],
                        ),
                        Text(
                          'Somme à payer',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: amountPayed!,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Donner une somme ";
                            }
                          },
                          onSaved: (String? value) {},
                          decoration: InputDecoration(
                            hintText: "Somme à payer",
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
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
                                  if (numAdded) {
                                    if (amountPayed!.text.isEmpty &&
                                        numero!.text.isEmpty) {
                                      setState(() {
                                        _isamountPayedEmpty = true;
                                        _isNumeEmpty = true;
                                      });
                                    } else if (amountPayed!.text.isNotEmpty &&
                                        numero!.text.isEmpty) {
                                      setState(() {
                                        _isamountPayedEmpty = false;
                                        _isNumeEmpty = true;
                                      });
                                    } else if (amountPayed!.text.isEmpty &&
                                        numero!.text.isNotEmpty) {
                                      setState(() {
                                        _isamountPayedEmpty = true;
                                        _isNumeEmpty = false;
                                      });
                                    } else {
                                      if (int.parse(amountPayed!.text) >
                                          double.parse(
                                              widget.reste.split('-')[0])) {
                                        ConfirmBox().showAlert(
                                            context,
                                            "La somme saissie depasse le reste à payer",
                                            false);
                                      } else {
                                        String mode = '0';
                                        if (_isVers) {
                                          Services.checkVersement(
                                                  numero!.text,
                                                  amountPayed!.text,
                                                  widget.idCom,
                                                  user!.text)
                                              .then((value) {
                                            if (int.parse(value) == 1) {
                                              mode = '1';
                                              Navigator.of(context).pop(
                                                  '${amountPayed!.text}-${payType!.text}-${user!.text}-${numero!.text}-$mode');
                                            } else {
                                              ConfirmBox().showAlert(
                                                  context,
                                                  int.parse(value) == 404
                                                      ? "Le numéro du compte est invalide"
                                                      : int.parse(value) == 400
                                                          ? "Pas assez d'argent dans le compte"
                                                          : "Paiement echoué",
                                                  false);
                                            }
                                          });
                                        } else {
                                          Navigator.of(context).pop(
                                              '${amountPayed!.text}-${payType!.text}-${user!.text}-${numero!.text}-$mode');
                                        }
                                      }
                                      setState(() {
                                        _isamountPayedEmpty = false;
                                      });
                                    }
                                  } else {
                                    if (amountPayed!.text.isEmpty) {
                                      setState(() {
                                        _isamountPayedEmpty = true;
                                      });
                                    } else {
                                      if (int.parse(amountPayed!.text) >
                                          double.parse(
                                              widget.reste.split('-')[0])) {
                                        ConfirmBox().showAlert(
                                            context,
                                            "La somme saisie depasse le reste à payer",
                                            false);
                                      } else {
                                        String mode = '0';
                                        if (_isVers) {
                                          Services.checkVersement(
                                                  numero!.text,
                                                  amountPayed!.text,
                                                  widget.idCom,
                                                  user!.text)
                                              .then((value) {
                                            if (int.parse(value) == 1) {
                                              mode = '1';
                                              Navigator.of(context).pop(
                                                  '${amountPayed!.text}-${payType!.text}-${user!.text}-${numero!.text}-$mode');
                                            } else {
                                              ConfirmBox().showAlert(
                                                  context,
                                                  int.parse(value) == 404
                                                      ? "Le numéro du compte est invalide"
                                                      : int.parse(value) == 400
                                                          ? "Pas assez d'argent dans le compte"
                                                          : "Paiement echoué",
                                                  false);
                                            }
                                          });
                                        } else {
                                          Navigator.of(context).pop(
                                              '${amountPayed!.text}-${payType!.text}-${user!.text}-0-$mode');
                                        }
                                      }
                                      setState(() {
                                        _isamountPayedEmpty = false;
                                      });
                                    }
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
                              // : MaterialButton(
                              //     onPressed: () {
                              //       if (numAdded) {
                              //         if (amountPayed!.text.isEmpty &&
                              //             numero!.text.isEmpty) {
                              //           setState(() {
                              //             _isamountPayedEmpty = true;
                              //             _isNumeEmpty = true;
                              //           });
                              //         } else if (amountPayed!
                              //                 .text.isNotEmpty &&
                              //             numero!.text.isEmpty) {
                              //           setState(() {
                              //             _isamountPayedEmpty = false;
                              //             _isNumeEmpty = true;
                              //           });
                              //         } else if (amountPayed!
                              //                 .text.isEmpty &&
                              //             numero!.text.isNotEmpty) {
                              //           setState(() {
                              //             _isamountPayedEmpty = true;
                              //             _isNumeEmpty = false;
                              //           });
                              //         } else {
                              //           if (int.parse(amountPayed!.text) >
                              //               double.parse(widget.reste
                              //                   .split('-')[0])) {
                              //             ConfirmBox().showAlert(
                              //                 context,
                              //                 "La somme saissie depasse le reste à payer",
                              //                 false);
                              //           } else {
                              //             String mode = '0';
                              //             if (_isVers) {
                              //               Services.checkVersement(
                              //                       numero!.text,
                              //                       amountPayed!.text,
                              //                       widget.idCom,
                              //                       user!.text)
                              //                   .then((value) {
                              //                 if (int.parse(value) == 1) {
                              //                   mode = '1';
                              //                   Navigator.of(context).pop(
                              //                       amountPayed!.text +
                              //                           '-' +
                              //                           payType!.text +
                              //                           '-' +
                              //                           user!.text +
                              //                           '-' +
                              //                           numero!.text +
                              //                           '-' +
                              //                           mode);

                              //                 } else {
                              //                   ConfirmBox().showAlert(
                              //                       context,
                              //                       int.parse(value) == 404
                              //                           ? "Le numéro du compte est invalide"
                              //                           : int.parse(value) ==
                              //                                   400
                              //                               ? "Pas assez d'argent dans le compte"
                              //                               : "Paiement echoué",
                              //                       false);
                              //                 }
                              //               });
                              //             } else {
                              //               Navigator.of(context).pop(
                              //                   amountPayed!.text +
                              //                       '-' +
                              //                       payType!.text +
                              //                       '-' +
                              //                       user!.text +
                              //                       '-' +
                              //                       numero!.text +
                              //                       '-' +
                              //                       mode);
                              //             }
                              //           }
                              //           setState(() {
                              //             _isamountPayedEmpty = false;
                              //           });
                              //         }
                              //       } else {
                              //         if (amountPayed!.text.isEmpty) {
                              //           setState(() {
                              //             _isamountPayedEmpty = true;
                              //           });
                              //         } else {
                              //           if (int.parse(amountPayed!.text) >
                              //               double.parse(widget.reste
                              //                   .split('-')[0])) {
                              //             ConfirmBox().showAlert(
                              //                 context,
                              //                 "La somme saisie depasse le reste à payer",
                              //                 false);
                              //           } else {
                              //             String mode = '0';
                              //             if (_isVers) {
                              //               Services.checkVersement(
                              //                       numero!.text,
                              //                       amountPayed!.text,
                              //                       widget.idCom,
                              //                       user!.text)
                              //                   .then((value) {
                              //                 if (int.parse(value) == 1) {
                              //                   mode = '1';
                              //                   Navigator.of(context).pop(
                              //                       amountPayed!.text +
                              //                           '-' +
                              //                           payType!.text +
                              //                           '-' +
                              //                           user!.text +
                              //                           '-0' +
                              //                           '-' +
                              //                           mode);
                              //                 } else {
                              //                   ConfirmBox().showAlert(
                              //                       context,
                              //                       int.parse(value) == 404
                              //                           ? "Le numéro du compte est invalide"
                              //                           : int.parse(value) ==
                              //                                   400
                              //                               ? "Pas assez d'argent dans le compte"
                              //                               : "Paiement echoué",
                              //                       false);
                              //                 }
                              //               });
                              //             } else {
                              //               Navigator.of(context).pop(
                              //                   amountPayed!.text +
                              //                       '-' +
                              //                       payType!.text +
                              //                       '-' +
                              //                       user!.text +
                              //                       '-0' +
                              //                       '-' +
                              //                       mode);
                              //             }
                              //           }
                              //           setState(() {
                              //             _isamountPayedEmpty = false;
                              //           });
                              //         }
                              //       }
                              //     },
                              //     color: Color(0xFF1B8D41),
                              //     child: Text(
                              //       "Payer",
                              //       style: TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 18,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ),
                            ),
                          ),
                          onChanged: (string) {
                            setState(() {
                              if (amountPayed!.text.isEmpty) {
                                setState(() {
                                  _isamountPayedEmpty = true;
                                });
                              } else {
                                setState(() {
                                  _isamountPayedEmpty = false;
                                });
                              }
                            });
                          },
                        ),
                        _isamountPayedEmpty
                            ? Container(
                                child: Text(
                                  "Veuillez entrer une somme",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            : Text(''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
// fin paiement par le client

// Voir Liste des versements
class ListVersement extends StatefulWidget {
  ListVersement({
    Key? key,
  }) : super(key: key);

  @override
  State<ListVersement> createState() => _ListVersementState();
}

class _ListVersementState extends State<ListVersement> {
  List<CompteVersementModel>? versementList;
  List<CompteVersementModel>? copyversementList;
  List<CompteVersementModel>? dayVersList;
  List<TrackCpt>? trackVersement;
  List<VersementModel>? retraiList;
  List<VersementModel>? detailVersList;
  LogoCompany? logoComp;
  ResumerFacture? resumeFact;
  bool clienSearch = true;
  bool dateSearch = false;
  bool is_emptyClient = true;

  TextEditingController? client;
  TextEditingController? user;
  List<String> listClient = [];

  TextEditingController end = TextEditingController();
  TextEditingController seach = TextEditingController();
  TextEditingController seachInput = TextEditingController();
  bool endPred = false;
  bool endSuiv = false;
  bool is_loading = true;
  bool is_empty = false;

  @override
  void initState() {
    super.initState();
    clienSearch = true;
    dateSearch = false;
    versementList = [];
    copyversementList = [];
    dayVersList = [];
    detailVersList = [];

    is_emptyClient = true;
    listClient = [];
    user = TextEditingController();
    client = TextEditingController();
    getClientList();
    seach.text = '';
    end.text = "0";
    getverss(end.text, seach.text, true, true);
    getDayverss();
  }

// Liste de clients
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

  //recuperation de versement
  getverss(String ends, String cherche, bool isfront, bool same) {
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

    Services.getlisteVersementCounLimit(limit, cherche).then((value) {
      setState(() {
        is_loading = false;
      });
      if (int.parse(value.map((e) => e.id_cpt).toList()[0]) <= 0) {
        setState(() {
          is_empty = true;
        });
        if (int.parse(value.map((e) => e.id_cpt).toList()[0]) < 0) {
          ConfirmBox().showAlert(context, 'Erreur de connexion', false);
        }
      } else if (int.parse(value.map((e) => e.id_cpt).toList()[0]) > 0) {
        setState(() {
          versementList = value;
          copyversementList = value;
        });
      }
    });
  }

  //recuperation de versement du jours
  getDayverss() {
    Services.getDaylistVersementCount('', '').then((value) {
      if (int.parse(value.map((e) => e.id_cpt).toList()[0]) < 0) {
        ConfirmBox().showAlert(context, 'Erreur de connexion', false);
      } else if (int.parse(value.map((e) => e.id_cpt).toList()[0]) > 0) {
        setState(() {
          dayVersList = value;
        });
      }
    });
  }

  String getDayTotal(List<CompteVersementModel> dayList) {
    int total = 0;
    for (int i = 0; i < dayList.length; i++) {
      total += int.parse(dayList[i].somme_cpt);
    }
    return total.toString();
  }

  // imppression du resume de versement
  void imprime(List<VersementModel> detailVersList, String client) async {
    final pdfFile =
        await PdfVersementResumeApi.generate(logoComp!, client, detailVersList);
    PdfInvoiceApi.onpenFile(pdfFile)
        .then((value) =>
            ConfirmBox().showAlert(context, "Impression en cours", true))
        .then((value) => Navigator.of(context).pop('1'));
  }

  // imppression de releve de compte de versement
  void imprimeReleveCompte(List<TrackCpt> trackVersement,
      List<VersementModel> retraiList, String client) async {
    final pdfFile = await PdfReleveComptApi.generate(
        logoComp!, client, trackVersement, retraiList);
    PdfInvoiceApi.onpenFile(pdfFile).then((value) =>
        ConfirmBox().showAlert(context, "Impression en cours", true));
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
                      padding: EdgeInsets.all(0),
                      width: 390,
                      height: 710,
                      child: DropDownField(
                          value: client!.text,
                          required: false,
                          strict: false,
                          labelText: 'Rechercher un client',
                          items: listClient,
                          itemsVisibleInDropdown: 13,
                          onValueChanged: (dynamic newValue) {
                            client!.text = newValue;
                          }),
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (client!.text.isEmpty) {
                          ConfirmBox().showAlert(
                              context, "Veuillez choisir un client", false);
                          setState(() {
                            is_emptyClient = false;
                          });
                        } else {
                          Navigator.of(context).pop(client!.text);
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
                        padding: EdgeInsets.all(0),
                        height: 60,
                        width: 100,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              client!.text = "";
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
                        padding: EdgeInsets.all(0),
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

  SingleChildScrollView _fournisseuMove(user) {
    return SingleChildScrollView(
      controller: ScrollController(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SingleChildScrollView(
            controller: ScrollController(),
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.all(0),
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
                      label: Text("ID"),
                    ),
                    DataColumn(
                      label: Row(
                        children: [
                          Text("Client"),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  copyversementList = versementList;
                                  clienSearch = true;
                                  dateSearch = false;
                                });
                              },
                              icon: Icon(
                                Icons.filter_list_alt,
                                size: 20,
                                color:
                                    clienSearch ? Colors.green : Colors.black,
                              ))
                        ],
                      ),
                    ),
                    DataColumn(
                      label: Text("Agent"),
                    ),
                    DataColumn(
                      label: Text("Telephone"),
                    ),
                    DataColumn(
                      label: Text("Montant"),
                    ),
                    DataColumn(
                      label: Row(
                        children: [
                          Text("Date"),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  copyversementList = versementList;
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
                      label: Text("Etat"),
                    ),
                    DataColumn(
                      label: Text("Action"),
                    ),
                  ],
                  rows: copyversementList!
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(Text(e.id_cpt)),
                            DataCell(Text(e.client_cpt)),
                            DataCell(
                                Text(e.agent_cpt.split('-')[0].toString())),
                            DataCell(Text(e.tel_cpt)),
                            DataCell(Text('${e.somme_cpt} Fcfa')),
                            DataCell(Text(e.date_cpt)),
                            DataCell(Text(
                                int.parse(e.etat_cpt) == 0
                                    ? 'En cours...'
                                    : 'Fermé...',
                                style: TextStyle(
                                    color: int.parse(e.etat_cpt) == 0
                                        ? Colors.blue
                                        : Colors.red))),
                            DataCell(
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MaterialButton(
                                    child:
                                        int.parse(e.agent_cpt.split('-')[1]) <=
                                                0
                                            ? Icon(
                                                Icons.visibility,
                                                color: Color(0xCC0AC529),
                                              )
                                            : Badge(
                                                badgeContent: Text(
                                                    e.agent_cpt
                                                        .split('-')[1]
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                child: Icon(
                                                  Icons.visibility,
                                                  color: Color(0xCC0AC529),
                                                ),
                                              ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return DetailVersement(
                                              client: e.client_cpt,
                                              montant: e.somme_cpt,
                                              id_cpt: e.id_cpt,
                                            );
                                          }).then((value) {
                                        setState(() {
                                          getverss(
                                              end.text, seach.text, true, true);
                                          getDayverss();
                                        });
                                      });
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  user == "CAISSE"
                                      ? Text('')
                                      : int.parse(e.etat_cpt) == 0
                                          ? Row(
                                              children: [
                                                MaterialButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Versement(
                                                              id_cpt: e.id_cpt,
                                                            );
                                                          }).then((value) {
                                                        setState(() {
                                                          getverss(
                                                              end.text,
                                                              seach.text,
                                                              true,
                                                              true);
                                                          getDayverss();
                                                        });
                                                      });
                                                    },
                                                    color: Colors.orange,
                                                    child: Text("Ajouter",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16))),
                                                SizedBox(width: 10),
                                                MaterialButton(
                                                  onPressed: () {
                                                    void getAdress(
                                                        List<VersementModel>
                                                            detailVersList) {
                                                      Services.getCompayDetail(
                                                              '/company')
                                                          .then((value) {
                                                        if (int.parse(
                                                                value.id) >
                                                            0) {
                                                          setState(() {
                                                            logoComp = LogoCompany(
                                                                value
                                                                    .slogan_com,
                                                                value.nom_com,
                                                                value.adress);
                                                          });
                                                          imprime(
                                                              detailVersList,
                                                              e.client_cpt);
                                                        } else if (int.parse(
                                                                value.id) ==
                                                            0) {
                                                          ConfirmBox().showAlert(
                                                              context,
                                                              "Impossible d'imprimer la facture",
                                                              false);
                                                          return '0';
                                                        } else if (int.parse(
                                                                value.id) <
                                                            0) {
                                                          ConfirmBox().showAlert(
                                                              context,
                                                              'Erreur de connextion',
                                                              false);
                                                          return '0';
                                                        }
                                                      }).then((value) {
                                                        if (value != '0') {}
                                                      });
                                                    }

                                                    AlertBox()
                                                        .showAlertDialod(
                                                            context,
                                                            int.parse(e.id_cpt),
                                                            "Voulez vous mettre fin à cet versement?",
                                                            'end_versement')
                                                        .then((value) {
                                                      if (int.parse(value) ==
                                                          -1) {
                                                        ConfirmBox().showAlert(
                                                            context,
                                                            'Erreur. Réessayer encore',
                                                            false);
                                                      } else if (int.parse(
                                                              value) ==
                                                          1) {
                                                        ConfirmBox()
                                                            .showAlert(
                                                                context,
                                                                'Versement terminé reussi',
                                                                true)
                                                            .then((value) {
                                                          setState(() {
                                                            Services.getversement(
                                                                    e.id_cpt)
                                                                .then((value) {
                                                              if (int.parse(value
                                                                      .map((e) =>
                                                                          e.id_vers)
                                                                      .toList()[0]) <
                                                                  0) {
                                                                ConfirmBox()
                                                                    .showAlert(
                                                                        context,
                                                                        'Erreur de connexion',
                                                                        false);
                                                              } else if (int.parse(value
                                                                      .map((e) =>
                                                                          e.id_vers)
                                                                      .toList()[0]) >
                                                                  0) {
                                                                setState(() {
                                                                  detailVersList =
                                                                      value;
                                                                  getAdress(
                                                                      detailVersList!);
                                                                });
                                                              }
                                                            }).then(
                                                              (value) =>
                                                                  getverss(
                                                                      end.text,
                                                                      seach
                                                                          .text,
                                                                      true,
                                                                      true),
                                                            );
                                                          });
                                                        });
                                                      }
                                                    });
                                                  },
                                                  color: Colors.green,
                                                  child: Text(
                                                    "Terminer",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 25,
                                                  ),
                                                  onPressed: () {
                                                    AlertBox()
                                                        .showAlertDialod(
                                                            context,
                                                            int.parse(e.id_cpt),
                                                            "Voulez vous supprimer cet versement?",
                                                            'cpt_versement')
                                                        .then((value) {
                                                      if (int.parse(value) ==
                                                          -1) {
                                                        ConfirmBox().showAlert(
                                                            context,
                                                            'Impossible de supprimer. Réessayer encore',
                                                            false);
                                                      } else if (int.parse(
                                                              value) ==
                                                          1) {
                                                        ConfirmBox()
                                                            .showAlert(
                                                                context,
                                                                'Suppression reussi',
                                                                true)
                                                            .then((value) {
                                                          setState(() {
                                                            getverss(
                                                                end.text,
                                                                seach.text,
                                                                true,
                                                                true);
                                                          });
                                                        });
                                                      }
                                                    });
                                                  },
                                                ),
                                              ],
                                            )
                                          : Text(''),
                                  SizedBox(width: 10),
                                  MaterialButton(
                                    child:
                                        int.parse(e.agent_cpt.split('-')[2]) <=
                                                0
                                            ? Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              )
                                            : Badge(
                                                badgeContent: Text(
                                                    e.agent_cpt
                                                        .split('-')[2]
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return TrackVersementAchat(
                                              client: e.client_cpt,
                                              montant: e.somme_cpt,
                                              id_cpt: e.id_cpt,
                                            );
                                          }).then((value) {
                                        setState(() {
                                          getverss(
                                              end.text, seach.text, true, true);
                                          getDayverss();
                                        });
                                      });
                                    },
                                  ),
                                  MaterialButton(
                                    child: Icon(
                                      Icons.library_books_rounded,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      loader(context);
                                      //recuperation de versement
                                      setState(() {
                                        retraiList = [];
                                      });
                                      Services.getversement(e.id_cpt)
                                          .then((value) {
                                        if (int.parse(value
                                                .map((e) => e.id_vers)
                                                .toList()[0]) <=
                                            0) {
                                          setState(() {
                                            retraiList = [];
                                          });
                                        } else if (int.parse(value
                                                .map((e) => e.id_vers)
                                                .toList()[0]) >
                                            0) {
                                          setState(() {
                                            for (int i = 0;
                                                i < value.length;
                                                i++) {
                                              if (int.parse(value[i]
                                                      .is_active_vers) ==
                                                  1) {
                                                retraiList!.add(value[i]);
                                              }
                                            }
                                          });
                                        }
                                      }).then((value) {
                                        setState(() {
                                          trackVersement = [];
                                        });
                                        //recuperation de la liste des retraits versement
                                        Services.getTrackVersement(e.id_cpt)
                                            .then((value) {
                                          if (int.parse(value
                                                  .map((e) => e.idCom)
                                                  .toList()[0]) <=
                                              0) {
                                            setState(() {
                                              trackVersement = [];
                                            });
                                          } else if (int.parse(value
                                                  .map((e) => e.idCom)
                                                  .toList()[0]) >
                                              0) {
                                            setState(() {
                                              trackVersement = value;
                                            });
                                          }
                                        }).then((value) {
                                          Services.getCompayDetail('/company')
                                              .then((value) {
                                            Loader.hide();
                                            if (int.parse(value.id) > 0) {
                                              setState(() {
                                                logoComp = LogoCompany(
                                                    value.slogan_com,
                                                    value.nom_com,
                                                    value.adress);
                                              });
                                              imprimeReleveCompte(
                                                  trackVersement!,
                                                  retraiList!,
                                                  e.client_cpt);
                                            } else if (int.parse(value.id) ==
                                                0) {
                                              ConfirmBox().showAlert(
                                                  context,
                                                  "Impossible d'imprimer la facture",
                                                  false);
                                              return '0';
                                            } else if (int.parse(value.id) <
                                                0) {
                                              ConfirmBox().showAlert(
                                                  context,
                                                  'Erreur de connextion',
                                                  false);
                                              return '0';
                                            }
                                          }).then((value) {
                                            if (value != '0') {}
                                          });
                                        });
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
                                "Liste des versements",
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
                          height: MediaQuery.of(context).size.height - 156,
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
                                                  if (clienSearch) {
                                                    if (mounted) {
                                                      setState(() {
                                                        seach.text =
                                                            "AND cl.nom_complet_client LIKE '%${seachInput
                                                                    .text}%'";
                                                      });
                                                    }
                                                  } else {
                                                    if (mounted) {
                                                      setState(() {
                                                        seach.text =
                                                            "AND c.date_cpt LIKE '%${seachInput
                                                                    .text}%'";
                                                      });
                                                    }
                                                  }
                                                }
                                                getverss(end.text, seach.text,
                                                    true, true);
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
                                            hintText: clienSearch
                                                ? "Rechercher par client..."
                                                : "Rechercher par date..."),
                                        onChanged: (seach) {
                                          setState(() {
                                            if (clienSearch) {
                                              copyversementList = versementList!
                                                  .where((element) => (element
                                                      .client_cpt
                                                      .toLowerCase()
                                                      .contains(
                                                          seach.toLowerCase())))
                                                  .toList();
                                            } else {
                                              copyversementList = versementList!
                                                  .where((element) => (element
                                                      .date_cpt
                                                      .toLowerCase()
                                                      .contains(
                                                          seach.toLowerCase())))
                                                  .toList();
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Row(children: [
                                      Text('Versement du jour: ',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.red)),
                                      Text('${getDayTotal(dayVersList!)} FCFA',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                                    state.user!.droit
                                                .toString()
                                                .toUpperCase() ==
                                            "CAISSE"
                                        ? Text('')
                                        : Container(
                                            child: Builder(builder: (context) {
                                              return MaterialButton(
                                                color: Colors.green,
                                                height: 50,
                                                onPressed: () {
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
                                                            .split('=>')
                                                            .length >
                                                        1) {
                                                      Services.compteVersement(
                                                        state.user!.id
                                                            .toString(),
                                                        client!.text
                                                            .split('=>')[0],
                                                      ).then((value) {
                                                        setState(() {
                                                          client!.text = "";
                                                        });
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
                                                              'Cet client a déjà un versement en cours',
                                                              false);
                                                        } else if (int.parse(
                                                                value) ==
                                                            1) {
                                                          ConfirmBox()
                                                              .showAlert(
                                                                  context,
                                                                  'Versement crée avec succès.',
                                                                  true)
                                                              .then((value) {
                                                            setState(() {
                                                              getverss(
                                                                  end.text,
                                                                  seach.text,
                                                                  true,
                                                                  true);
                                                            });
                                                          });
                                                        }
                                                      });
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  'Nouveau versement',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              );
                                            }),
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
                                height: 600,
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
                                    : _fournisseuMove(state.user!.droit
                                        .toString()
                                        .toUpperCase()),
                              ),
                            ]),
                          ),
                        ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                        width: 300,
                        child: BootstrapContainer(
                            fluid: true,
                            padding: EdgeInsets.only(top: 15),
                            children: [
                              BootstrapRow(children: [
                                BootstrapCol(
                                    sizes: 'col-12',
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        MaterialButton(
                                          height: 40,
                                          color: endPred
                                              ? Colors.grey
                                              : Colors.red,
                                          onPressed: () {
                                            endPred
                                                ? null
                                                : getverss(end.text, seach.text,
                                                    false, false);
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
                                                : getverss(end.text, seach.text,
                                                    true, false);
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
                            ]))
                  ])
                ],
              ),
            ),
          );
        });
  }
}

// Track achat avec versement
class TrackVersementAchat extends StatefulWidget {
  final String id_cpt;
  final String montant;
  final String client;
  TrackVersementAchat({
    Key? key,
    required this.id_cpt,
    required this.montant,
    required this.client,
  }) : super(key: key);

  @override
  State<TrackVersementAchat> createState() => _TrackVersementAchatState();
}

class _TrackVersementAchatState extends State<TrackVersementAchat> {
  List<TrackCpt>? trackVersement;
  @override
  void initState() {
    super.initState();
    trackVersement = [];
    getAchatvers();
  }

  //recuperation de versement
  getAchatvers() {
    Services.getTrackVersement(widget.id_cpt).then((value) {
      if (int.parse(value.map((e) => e.idCom).toList()[0]) < 0) {
        ConfirmBox().showAlert(context, 'Erreur de connexion', false);
      } else if (int.parse(value.map((e) => e.idCom).toList()[0]) > 0) {
        setState(() {
          trackVersement = value;
        });
      }
    });
  }

  SingleChildScrollView _fournisseuMove(user, userDroit) {
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
                  columns: const [
                    DataColumn(
                      label: Text("Facture"),
                    ),
                    DataColumn(
                      label: Text("Montant"),
                    ),
                    DataColumn(
                      label: Text("Agent"),
                    ),
                    DataColumn(
                      label: Text("Date"),
                    ),
                    DataColumn(
                      label: Text("Action"),
                    ),
                  ],
                  rows: trackVersement!
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(Text(ConfirmBox().numFacture(
                                e.dateCom.split(" ")[0].split('-')[0],
                                e.idCom))),
                            DataCell(Text("${e.somme} FCFA")),
                            DataCell(Text(e.agent)),
                            DataCell(Text(e.dateCom)),
                            DataCell(Text('')),
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
                                "Détail Achat avec compte",
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
                            flex: 7,
                            child: Container(
                              height: 710,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  Container(
                                    height: 710,
                                    padding: EdgeInsets.only(
                                        left: 2, right: 2, top: 5),
                                    child: _fournisseuMove(
                                        state.user!.nom.toString(),
                                        state.user!.droit
                                            .toString()
                                            .toUpperCase()),
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
          );
        });
  }
}

// Voir detail de chaque versement
class DetailVersement extends StatefulWidget {
  final String id_cpt;
  final String montant;
  final String client;
  DetailVersement({
    Key? key,
    required this.id_cpt,
    required this.montant,
    required this.client,
  }) : super(key: key);

  @override
  State<DetailVersement> createState() => _DetailVersementState();
}

class _DetailVersementState extends State<DetailVersement> {
  List<VersementModel>? retraiList;
  List acces = ['CAISSE', 'ADMIN'];
  LogoCompany? logoComp;
  ResumerFacture? resumeFact;
  @override
  void initState() {
    super.initState();
    retraiList = [];
    getvers();
  }

  //recuperation de versement
  getvers() {
    Services.getversement(widget.id_cpt).then((value) {
      if (int.parse(value.map((e) => e.id_vers).toList()[0]) < 0) {
        ConfirmBox().showAlert(context, 'Erreur de connexion', false);
      } else if (int.parse(value.map((e) => e.id_vers).toList()[0]) > 0) {
        setState(() {
          retraiList = value;
        });
      }
    });
  }

  // imppression de bon de sortie
  void imprime(String deposant, String payee, String date, String user) async {
    resumeFact = ResumerFacture(total: widget.montant, paye: payee, rest: date);
    final pdfFile = await PdfVersementApi.generate(
      logoComp!,
      widget.client,
      deposant,
      resumeFact!,
      user,
    );
    PdfInvoiceApi.onpenFile(pdfFile)
        .then((value) =>
            ConfirmBox().showAlert(context, "Impression en cours", true))
        .then((value) => Navigator.of(context).pop('1'));
  }

  SingleChildScrollView _fournisseuMove(user, userDroit) {
    return SingleChildScrollView(
      controller: ScrollController(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SingleChildScrollView(
            controller: ScrollController(),
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.all(0),
              child: DataTable(
                  columnSpacing: 30,
                  headingTextStyle: TextStyle(
                    color: Color(0xFF26345d),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  horizontalMargin: 30,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white)),
                  // ignore: prefer_const_literals_to_create_immutables
                  columns: [
                    DataColumn(
                      label: Text("Déposant"),
                    ),
                    DataColumn(
                      label: Text("Agent"),
                    ),
                    DataColumn(
                      label: Text("CNIB"),
                    ),
                    DataColumn(
                      label: Text("Téléphone"),
                    ),
                    DataColumn(
                      label: Text("Montant"),
                    ),
                    DataColumn(
                      label: Text("Date"),
                    ),
                    DataColumn(
                      label: Text("Action"),
                    ),
                  ],
                  rows: retraiList!
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(Text(e.nom_vers)),
                            DataCell(Text(e.user_vers)),
                            DataCell(Text(e.cnib_vers)),
                            DataCell(Text(e.tel_vers)),
                            DataCell(Text('${e.somme_vers} Fcfa')),
                            DataCell(Text(e.date_vers)),
                            DataCell(
                              int.parse(e.is_active_vers) == 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        acces.contains(userDroit)
                                            ? Row(
                                                children: [
                                                  MaterialButton(
                                                    onPressed: () {
                                                      void getAdress() {
                                                        Services.getCompayDetail(
                                                                '/company')
                                                            .then((value) {
                                                          if (int.parse(
                                                                  value.id) >
                                                              0) {
                                                            setState(() {
                                                              logoComp = LogoCompany(
                                                                  value.slogan_com[
                                                                      0],
                                                                  value.nom_com[
                                                                      0],
                                                                  value.adress);
                                                            });
                                                            imprime(
                                                                e.nom_vers,
                                                                e.somme_vers,
                                                                e.date_vers,
                                                                user);
                                                          } else if (int.parse(
                                                                  value
                                                                      .id[0]) ==
                                                              0) {
                                                            ConfirmBox().showAlert(
                                                                context,
                                                                "Impossible d'imprimer la facture",
                                                                false);
                                                            return '0';
                                                          } else if (int.parse(
                                                                  value.id) <
                                                              0) {
                                                            ConfirmBox().showAlert(
                                                                context,
                                                                'Erreur de connextion',
                                                                false);
                                                            return '0';
                                                          }
                                                        }).then((value) {
                                                          if (value != '0') {}
                                                        });
                                                      }

                                                      AlertBox()
                                                          .showAlertDialod(
                                                              context,
                                                              int.parse(
                                                                  e.id_vers),
                                                              "Voulez-vous valider cet versement?",
                                                              'validateVer')
                                                          .then((value) {
                                                        if (int.parse(value) ==
                                                            1) {
                                                          ConfirmBox()
                                                              .showAlert(
                                                                  context,
                                                                  "Dépense validée avec succès",
                                                                  true)
                                                              .then((value) {
                                                            getvers();
                                                            getAdress();
                                                          });
                                                        } else {
                                                          ConfirmBox().showAlert(
                                                              context,
                                                              "Versement annulé avec succès",
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
                                                  ),
                                                ],
                                              )
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  AlertBox()
                                                      .showAlertDialod(
                                                          context,
                                                          int.parse(e.id_vers),
                                                          'Voulez-vous supprimer cet paiement?',
                                                          'delver')
                                                      .then((value) {
                                                    if (int.parse(value) ==
                                                        -1) {
                                                      ConfirmBox().showAlert(
                                                          context,
                                                          'Impossible de supprimer. Réessayer encore',
                                                          false);
                                                    } else if (int.parse(
                                                            value) ==
                                                        1) {
                                                      ConfirmBox()
                                                          .showAlert(
                                                              context,
                                                              'Suppression reussi',
                                                              true)
                                                          .then((value) {
                                                        setState(() {
                                                          getvers();
                                                        });
                                                      });
                                                    }
                                                  });
                                                },
                                              ),
                                      ],
                                    )
                                  : Icon(Icons.check, color: Colors.green),
                            ),
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
                                "Détail de Versement",
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
                    height: MediaQuery.of(context).size.height - 110,
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Container(
                              height: 710,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  Container(
                                    height: 710,
                                    padding: EdgeInsets.only(
                                        left: 2, right: 2, top: 5),
                                    child: _fournisseuMove(
                                        state.user!.nom.toString(),
                                        state.user!.droit
                                            .toString()
                                            .toUpperCase()),
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
          );
        });
  }
}

// Voir tous les credits
class AllCredit extends StatefulWidget {
  AllCredit({
    Key? key,
  }) : super(key: key);

  @override
  State<AllCredit> createState() => _AllCreditState();
}

class _AllCreditState extends State<AllCredit> {
  List<CreditModel>? listCredit;
  List<CreditModel>? copyListCredit;
  bool is_loading = true;
  bool is_empty = false;
  bool reduire = true;
  bool idSearch = false;
  bool nomSearch = false;
  bool dateSearch = true;
  final controller = ScrollController();
  String nbr = '0';

  TextEditingController end = TextEditingController();
  TextEditingController seach = TextEditingController();
  TextEditingController seachInput = TextEditingController();
  bool endPred = false;
  bool endSuiv = false;
  @override
  void initState() {
    listCredit = [];
    copyListCredit = [];
    seach.text = '';
    end.text = "0";
    getAllCredit(end.text, seach.text, true, true);
    super.initState();
  }

// recuperation de credit
  getAllCredit(String ends, String cherche, bool isfront, bool same) {
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

    Services.allCreditLimit(limit, cherche).then((value) {
      setState(() {
        is_loading = false;
      });
      if (int.parse(value.map((e) => e.idCre).toList()[0]) <= 0) {
        setState(() {
          listCredit = [];
          copyListCredit = [];
          if (int.parse(value.map((e) => e.idCre).toList()[0]) == 0) {
            setState(() {
              is_empty = true;
            });
          } else {
            ConfirmBox().showAlert(context, "Erreur de connexion", false);
          }
        });
      } else {
        setState(() {
          listCredit = value;
          copyListCredit = value;
          value.length < 12 ? endSuiv = true : endSuiv = false;
          is_empty = false;
        });
      }
    });
  }

  SingleChildScrollView _fournisseuMove(String droit) {
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
                    Text("Numéro_Com"),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          copyListCredit = listCredit;
                          idSearch = true;
                          nomSearch = false;
                          dateSearch = false;
                        });
                      },
                      icon: Icon(
                        Icons.filter_list_alt,
                        size: 20,
                        color: idSearch ? Colors.green : Colors.black,
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
                          copyListCredit = listCredit;
                          idSearch = false;
                          nomSearch = true;
                          dateSearch = false;
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
                label: Text("Total facture"),
              ),
              DataColumn(
                label: Text("Total crédit"),
              ),
              DataColumn(
                label: Text("crédit payée"),
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
                          copyListCredit = listCredit;
                          idSearch = false;
                          nomSearch = false;
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
                ),
              ),
              DataColumn(
                label: Text("Date_rembour"),
              ),
              DataColumn(
                label: Text("Action"),
              ),
            ],
            rows: copyListCredit!.map((e) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      int.parse(e.is_manual) == 1
                          ? e.fact_num
                          : ConfirmBox()
                              .numFacture(e.dateCred.split('-')[0], e.nume),
                      style: TextStyle(
                          color: int.parse(e.is_manual) == 1
                              ? Colors.red
                              : Colors.black),
                    ),
                  ),
                  DataCell(Text(e.nom.split('-=/')[0])),
                  DataCell(Text('${e.total_com} Fcfa')),
                  DataCell(Text(
                      '${int.parse(e.paye) + int.parse(e.reste)} Fcfa')),
                  DataCell(
                    Text('${e.paye} Fcfa',
                        style: TextStyle(color: Colors.green)),
                  ),
                  DataCell(Text('${e.reste} Fcfa',
                      style: TextStyle(color: Colors.red))),
                  DataCell(Text(e.dateCred)),
                  DataCell(Text(e.dateRem)),
                  DataCell(
                    Row(
                      children: [
                        MaterialButton(
                          child: e.nom.split('-=/')[1] == '0'
                              ? Icon(
                                  Icons.visibility,
                                  color: Color(0xCC0AC529),
                                )
                              : Badge(
                                  badgeContent: Text(
                                      e.nom.split('-=/')[1].toString(),
                                      style: TextStyle(color: Colors.white)),
                                  child: Icon(
                                    Icons.visibility,
                                    color: Color(0xCC0AC529),
                                  ),
                                ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return ListRembourse(
                                    idCred: e.idCre,
                                    credit: e,
                                  );
                                }).then((value) {
                              setState(() {
                                getAllCredit(end.text, seach.text, true, true);
                              });
                            });
                          },
                        ),
                        droit != "CAISSE"
                            ? int.parse(e.reste) > 0
                                ? MaterialButton(
                                    color: Colors.orange,
                                    child: Text('Payer',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return PayeCredit(
                                              idCred: e.idCre,
                                              reste: e.reste.toString(),
                                            );
                                          }).then((value) {
                                        setState(() {
                                          getAllCredit(
                                              end.text, seach.text, true, true);
                                        });
                                      });
                                    },
                                  )
                                : Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                            : Text(''),
                        int.parse(e.is_manual) == 1 && droit == "ADMIN"
                            ? MaterialButton(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  AlertBox()
                                      .showAlertDialod(
                                          context,
                                          int.parse(e.idCre),
                                          'Voulez-vous supprimer cet crédit?',
                                          'delCredit')
                                      .then((value) {
                                    if (value == "1") {
                                      Services.delCredit(e.idCre)
                                          .then((values) {
                                        if (int.parse(values) == 1) {
                                          ConfirmBox()
                                              .showAlert(
                                                  context,
                                                  'Crédit supprimée avec succès',
                                                  true)
                                              .then((val) {
                                            setState(() {
                                              getAllCredit(end.text, seach.text,
                                                  true, true);
                                            });
                                          });
                                        } else if (int.parse(values) == 0) {
                                          ConfirmBox().showAlert(context,
                                              'Suppression echouée', false);
                                        } else if (int.parse(values) < 0) {
                                          ConfirmBox().showAlert(context,
                                              'Erreur de connexion', false);
                                        }
                                      });
                                    }
                                  });
                                },
                              )
                            : Text(''),
                      ],
                    ),
                  ),
                ],
              );
            }).toList()),
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
                                "Liste des crédits",
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
                                    height: 715,
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                          if (idSearch) {
                                                            if (mounted) {
                                                              setState(() {
                                                                seach.text =
                                                                    "AND cr.Id_com LIKE '%${seachInput
                                                                            .text}%'";
                                                              });
                                                            }
                                                          } else {
                                                            if (dateSearch) {
                                                              if (mounted) {
                                                                setState(() {
                                                                  seach.text =
                                                                      "AND cr.Date_cre LIKE '%${seachInput
                                                                              .text}%'";
                                                                });
                                                              }
                                                            } else {
                                                              if (mounted) {
                                                                setState(() {
                                                                  seach.text =
                                                                      "AND cl.nom_complet_client LIKE '%${seachInput
                                                                              .text}%'";
                                                                });
                                                              }
                                                            }
                                                          }
                                                        }
                                                        getAllCredit(
                                                            end.text,
                                                            seach.text,
                                                            true,
                                                            true);
                                                      },
                                                      child: Text(
                                                        'OK',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText: idSearch
                                                        ? "Rechercher par numéro de facture..."
                                                        : dateSearch
                                                            ? "Rechercher par date..."
                                                            : "Rechercher par client..."),
                                                onChanged: (seach) {
                                                  setState(() {
                                                    if (idSearch) {
                                                      copyListCredit = listCredit!
                                                          .where((element) =>
                                                              (element.nume
                                                                  .toLowerCase()
                                                                  .contains(seach
                                                                      .toLowerCase())))
                                                          .toList();
                                                    } else {
                                                      if (dateSearch) {
                                                        copyListCredit = listCredit!
                                                            .where((element) => (element
                                                                .dateCred
                                                                .toLowerCase()
                                                                .contains(seach
                                                                    .toLowerCase())))
                                                            .toList();
                                                      } else {
                                                        copyListCredit = listCredit!
                                                            .where((element) => (element
                                                                .nom
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
                                              width: 400,
                                              padding: EdgeInsets.all(0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Services.allCreditLimit(
                                                              '',
                                                              " AND (cr.Prix_cre-cr.amount_pay)")
                                                          .then((value) {
                                                        if (int.parse(value
                                                                .map((e) =>
                                                                    e.idCre)
                                                                .toList()[0]) <=
                                                            0) {
                                                          if (int.parse(value
                                                                  .map((e) =>
                                                                      e.idCre)
                                                                  .toList()[0]) ==
                                                              0) {
                                                            ConfirmBox().showAlert(
                                                                context,
                                                                "Aucune donnée disponible",
                                                                false);
                                                          } else {
                                                            ConfirmBox().showAlert(
                                                                context,
                                                                "Erreur de connexion",
                                                                false);
                                                          }
                                                        } else {
                                                          setState(() {
                                                            ExportExcell
                                                                .exportAllCreditExcel(
                                                                    creditList:
                                                                        value,
                                                                    title:
                                                                        "Crédit Non Payée");
                                                          });
                                                        }
                                                      });
                                                    },
                                                    child: Row(
                                                      children: const [
                                                        Icon(Icons.print,
                                                            color: Colors.red),
                                                        Text(
                                                          "Crédit Non Payée",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Services.allCreditLimit(
                                                              '', "")
                                                          .then((value) {
                                                        if (int.parse(value
                                                                .map((e) =>
                                                                    e.idCre)
                                                                .toList()[0]) <=
                                                            0) {
                                                          if (int.parse(value
                                                                  .map((e) =>
                                                                      e.idCre)
                                                                  .toList()[0]) ==
                                                              0) {
                                                            ConfirmBox().showAlert(
                                                                context,
                                                                "Aucune donnée disponible",
                                                                false);
                                                          } else {
                                                            ConfirmBox().showAlert(
                                                                context,
                                                                "Erreur de connexion",
                                                                false);
                                                          }
                                                        } else {
                                                          setState(() {
                                                            ExportExcell
                                                                .exportAllCreditExcel(
                                                                    creditList:
                                                                        value,
                                                                    title:
                                                                        "Tous les crédits");
                                                          });
                                                        }
                                                      });
                                                    },
                                                    child: Row(
                                                      children: const [
                                                        Icon(Icons.print),
                                                        Text(
                                                            "Exporter tous les crédits")
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1, color: Colors.black),
                                          ),
                                          height: 590,
                                          padding: EdgeInsets.only(
                                              left: 2, right: 2, top: 5),
                                          child: is_empty
                                              ? Center(
                                                  child: Text(
                                                    'Aucune donnée trouvée',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                                )
                                              : ImprovedScrolling(
                                                  enableCustomMouseWheelScrolling:
                                                      true,
                                                  enableKeyboardScrolling: true,
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
                                                  scrollController: controller,
                                                  child: _fournisseuMove(state
                                                      .user!.droit
                                                      .toString()
                                                      .toUpperCase())),
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MaterialButton(
                                                height: 48,
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AddCredit();
                                                      }).then((value) {
                                                    setState(() {
                                                      getAllCredit(
                                                          '0', '', true, true);
                                                    });
                                                  });
                                                },
                                                color: Colors.blue,
                                                child: Text(
                                                  'Ajouter un crédit',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                  width: 300,
                                                  child: BootstrapContainer(
                                                      fluid: true,
                                                      padding: EdgeInsets.only(
                                                          top: 20),
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
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .red,
                                                                    onPressed:
                                                                        () {
                                                                      endPred
                                                                          ? null
                                                                          : getAllCredit(
                                                                              end.text,
                                                                              seach.text,
                                                                              false,
                                                                              false);
                                                                    },
                                                                    child: Text(
                                                                        "Précédent",
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
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .green,
                                                                    onPressed:
                                                                        () {
                                                                      endSuiv
                                                                          ? null
                                                                          : getAllCredit(
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
                                                      ]))
                                            ]),
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

// enregistrer une boutique annexe
class AddBoutique extends StatefulWidget {
  final AnnexeBoutModel? annexBou;
  final int? mode;
  AddBoutique({
    Key? key,
    this.annexBou,
    this.mode,
  }) : super(key: key);
  @override
  State<AddBoutique> createState() => _AddBoutiqueState();
}

class _AddBoutiqueState extends State<AddBoutique> {
  TextEditingController? nom;
  TextEditingController? tel;
  TextEditingController? ville;
  TextEditingController? desc;
  TextEditingController? user;
  GlobalKey<FormState>? _formKey;
  @override
  void initState() {
    super.initState();
    nom = TextEditingController();
    tel = TextEditingController();
    ville = TextEditingController();
    desc = TextEditingController();
    user = TextEditingController();
    if (widget.mode == 1) {
      nom!.text = widget.annexBou!.nom_bout;
      tel!.text = widget.annexBou!.tel_bout;
      ville!.text = widget.annexBou!.ville_bout;
      desc!.text = widget.annexBou!.desc_bout;
    }
    _formKey = GlobalKey<FormState>();
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
              height: 430,
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
                                "Enregistrement de boutique annexe",
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
                    height: 360,
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Form(
                            key: _formKey,
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
                                                "Nom de boutique",
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
                                                "Téléphone",
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
                                                "Ville",
                                                false,
                                                ville!,
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
                                                "Description",
                                                false,
                                                desc!,
                                                TextInputType.text,
                                                false,
                                                1,
                                                0,
                                                false),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 26,
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
                                        if (!_formKey!.currentState!
                                            .validate()) {
                                          return;
                                        } else {
                                          widget.mode == 0
                                              ? Services.addBoutique(
                                                      nom!.text,
                                                      tel!.text,
                                                      ville!.text,
                                                      desc!.text,
                                                      user!.text)
                                                  .then((value) {
                                                  if (int.parse(value) == 0) {
                                                    ConfirmBox().showAlert(
                                                        context,
                                                        'Impossible d\'enregistrer. réessayer.',
                                                        false);
                                                  } else if (int.parse(value) ==
                                                      97) {
                                                    ConfirmBox().showAlert(
                                                        context,
                                                        'Cette boutique existe déjà.',
                                                        false);
                                                  } else if (int.parse(value) <
                                                      0) {
                                                    ConfirmBox().showAlert(
                                                        context,
                                                        'Erreur de connexion',
                                                        false);
                                                  }
                                                  if (int.parse(value) == 1) {
                                                    ConfirmBox()
                                                        .showAlert(
                                                            context,
                                                            'Operation effecutée avec succès.',
                                                            true)
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                    });
                                                  }
                                                })
                                              : Services.updBoutique(
                                                      nom!.text,
                                                      tel!.text,
                                                      ville!.text,
                                                      desc!.text,
                                                      widget.annexBou!.id_bout)
                                                  .then((value) {
                                                  if (int.parse(value) == 0) {
                                                    ConfirmBox().showAlert(
                                                        context,
                                                        'Impossible d\'enregistrer. réessayer.',
                                                        false);
                                                  } else if (int.parse(value) ==
                                                      97) {
                                                    ConfirmBox().showAlert(
                                                        context,
                                                        'Cette boutique existe déjà.',
                                                        false);
                                                  } else if (int.parse(value) <
                                                      0) {
                                                    ConfirmBox().showAlert(
                                                        context,
                                                        'Erreur de connexion',
                                                        false);
                                                  }
                                                  if (int.parse(value) == 1) {
                                                    ConfirmBox()
                                                        .showAlert(
                                                            context,
                                                            'Operation effecutée avec succès.',
                                                            true)
                                                        .then((value) {
                                                      Navigator.pop(context);
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

// liste des boutiques annexe
class ListBoutique extends StatefulWidget {
  ListBoutique({
    Key? key,
  }) : super(key: key);

  @override
  State<ListBoutique> createState() => _ListBoutiqueState();
}

class _ListBoutiqueState extends State<ListBoutique> {
  List<AnnexeBoutModel>? listBout;
  List<AnnexeBoutModel>? copyListBout;
  TextEditingController? boutId;
  TextEditingController? user;
  bool clickCom = false;
  bool idSearch = false;
  bool nomSearch = false;
  bool dateSearch = true;
  bool checkEmpty = true;
  GlobalKey<FormState>? _venteKey;
  List<String> dropdowList = [];
  @override
  void initState() {
    listBout = [];
    copyListBout = [];
    dropdowList = [];
    _venteKey = GlobalKey();
    boutId = TextEditingController();
    user = TextEditingController();
    getListBout();
    super.initState();
  }

// recuperation des boutiques annexe
  getListBout() {
    Services.getAnnexBou().then((value) {
      setState(() {
        listBout = value;
        copyListBout = value;
        dropdowList = value.map((e) => '${e.id_bout}=>${e.nom_bout}').toList();
      });
    });
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
                  columnSpacing: 40,
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
                          Text("Numéro d'ordre"),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                copyListBout = listBout;
                                idSearch = true;
                                nomSearch = false;
                                dateSearch = false;
                              });
                            },
                            icon: Icon(
                              Icons.filter_list_alt,
                              size: 20,
                              color: idSearch ? Colors.green : Colors.black,
                            ),
                          )
                        ],
                      )),
                    ),
                    DataColumn(
                      label: Row(
                        children: [
                          Text("Nom boutique"),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                copyListBout = listBout;
                                idSearch = false;
                                nomSearch = true;
                                dateSearch = false;
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
                      label: Text("Téléphone"),
                    ),
                    DataColumn(
                      label: Text("Ville"),
                    ),
                    DataColumn(
                      label: Row(
                        children: [
                          Text("Date"),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                copyListBout = listBout;
                                idSearch = false;
                                nomSearch = false;
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
                      ),
                    ),
                    DataColumn(
                      label: Text("Description"),
                    ),
                    DataColumn(
                      label: Text("Agent"),
                    ),
                    DataColumn(
                      label: Text("Action"),
                    ),
                  ],
                  rows: copyListBout!
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(Text(e.id_bout)),
                            DataCell(Text(e.nom_bout)),
                            DataCell(Text(e.tel_bout)),
                            DataCell(Text(e.ville_bout)),
                            DataCell(Text(e.date_bout)),
                            DataCell(Text(e.desc_bout)),
                            DataCell(Text(e.agent_bout)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit_location_alt,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AddBoutique(
                                              mode: 1,
                                              annexBou: e,
                                            );
                                          }).then((value) {
                                        getListBout();
                                      });
                                    },
                                  ),
                                  MaterialButton(
                                    color: Colors.red,
                                    child: Text('Suprimmer',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      String content =
                                          "Voulez-vous réellement supprimer cette boutique?";
                                      AlertBox()
                                          .showAlertDialod(
                                              context,
                                              int.parse(e.id_bout),
                                              content,
                                              'Boutique')
                                          .then((value) {
                                        if (int.parse(value) == 1) {
                                          setState(() {
                                            getListBout();
                                            ConfirmBox().showAlert(
                                                context,
                                                "La boutique a été supprimé avec succès",
                                                true);
                                          });
                                        }
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
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
          user!.text = state.user!.id.toString();
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
                                "Détail de crédits",
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  idSearch
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              bottom: 10, left: 5),
                                          width: 350,
                                          child: TextField(
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                hintText:
                                                    "Rechercher par numéro d'ordre..."),
                                            onChanged: (seach) {
                                              setState(() {
                                                copyListBout = listBout!
                                                    .where((element) => (element
                                                        .id_bout
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
                                              width: 350,
                                              child: TextField(
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText:
                                                        "Rechercher par date..."),
                                                onChanged: (seach) {
                                                  setState(() {
                                                    copyListBout = listBout!
                                                        .where((element) => (element
                                                            .date_bout
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
                                              width: 350,
                                              child: TextField(
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText:
                                                        "Rechercher par nom de boutique..."),
                                                onChanged: (seach) {
                                                  setState(() {
                                                    copyListBout = listBout!
                                                        .where((element) => (element
                                                            .nom_bout
                                                            .toLowerCase()
                                                            .contains(seach
                                                                .toLowerCase())))
                                                        .toList();
                                                  });
                                                },
                                              ),
                                            ),
                                  Container(
                                    height: 570,
                                    padding: EdgeInsets.only(
                                        left: 2, right: 2, top: 5),
                                    child: _fournisseuMove,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 40),
                                        height: 70,
                                        width: 300,
                                        child: !clickCom
                                            ? MaterialButton(
                                                onPressed: () {
                                                  setState(() {
                                                    clickCom = true;
                                                  });
                                                },
                                                color: Color(0xFF26345d),
                                                child: Text(
                                                  "Nouveau bon",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  MaterialButton(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 30),
                                                    height: 55,
                                                    onPressed: () {
                                                      setState(() {
                                                        clickCom = false;
                                                      });
                                                    },
                                                    color: Color(0xFFDF0303),
                                                    child: Text(
                                                      "Annuler",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  MaterialButton(
                                                    height: 55,
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AddBoutique(
                                                              mode: 0,
                                                            );
                                                          }).then((value) {
                                                        getListBout();
                                                      });
                                                    },
                                                    color: Color(0xFFDF5B03),
                                                    child: Text(
                                                      "Nouvelle boutique",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                      Container(
                                        width: 350,
                                        child: Form(
                                          key: _venteKey,
                                          child: clickCom
                                              ? DropdownButtonFormField(
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: checkEmpty
                                                                ? Color(
                                                                    0xFF0D8D42)
                                                                : Color(
                                                                    0xFFE70C0C),
                                                            width: 1)),
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: checkEmpty
                                                              ? Color(
                                                                  0xFF0D8D42)
                                                              : Color(
                                                                  0xFFE70C0C),
                                                          width: 1),
                                                    ),
                                                    suffixIcon: MaterialButton(
                                                      onPressed: () {
                                                        if (!_venteKey!
                                                            .currentState!
                                                            .validate()) {
                                                          return;
                                                        } else {
                                                          if (boutId!
                                                              .text.isEmpty) {
                                                            setState(() {
                                                              checkEmpty =
                                                                  false;
                                                            });
                                                          } else {
                                                            Services.createBon(
                                                                    boutId!.text
                                                                        .split(
                                                                            '=>')[0],
                                                                    '0',
                                                                    user!.text)
                                                                .then((value) {
                                                              if (int.parse(
                                                                      value) ==
                                                                  1) {
                                                                Services.getClientIdBon(
                                                                        boutId!
                                                                            .text
                                                                            .split('=>')[0],
                                                                        'boutique')
                                                                    .then((valu) {
                                                                  if (int.parse(
                                                                          valu) !=
                                                                      -1) {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return BonSortieCtn(
                                                                            bonId:
                                                                                valu,
                                                                            nomBout:
                                                                                boutId!.text.split('=>')[1],
                                                                          );
                                                                        }).then((value) {
                                                                      setState(
                                                                          () {
                                                                        getListBout();
                                                                      });
                                                                    });
                                                                  } else {
                                                                    ConfirmBox().showAlert(
                                                                        context,
                                                                        'Erreur de connexion',
                                                                        false);
                                                                  }
                                                                });
                                                              } else if (int.parse(
                                                                      value) ==
                                                                  0) {
                                                                ConfirmBox()
                                                                    .showAlert(
                                                                        context,
                                                                        'Impossible de créer la vente',
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
                                                        }
                                                      },
                                                      height: 60,
                                                      color: Color(0xFF0D8D42),
                                                      elevation: 0,
                                                      child: Text(
                                                        "Valider",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  hint: Text(
                                                    'Choisir une boutique',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF3E413E)),
                                                  ),
                                                  onChanged: (dynamic value) {
                                                    setState(() {
                                                      boutId!.text = value;
                                                    });
                                                  },
                                                  items: dropdowList
                                                      .map((String? e) {
                                                    return DropdownMenuItem(
                                                      value: e,
                                                      child: Text(e!,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF3E413E))),
                                                    );
                                                  }).toList(),
                                                )
                                              : Text(''),
                                        ),
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
                  )
                ],
              ),
            ),
          );
        });
  }
}

// modification de la quantite du produit pour bon de sortie vers boutique annexe
class UpdBonElem extends StatefulWidget {
  final String qtPrix;
  final String qtActu;
  final String nameProd;
  UpdBonElem({
    Key? key,
    required this.qtPrix,
    required this.qtActu,
    required this.nameProd,
  }) : super(key: key);

  @override
  _UpdBonElemState createState() => _UpdBonElemState();
}

class _UpdBonElemState extends State<UpdBonElem> {
  TextEditingController? prix;
  TextEditingController? qts;
  bool _isQtsEmpty = false;

  @override
  void initState() {
    prix = TextEditingController();

    qts = TextEditingController();
    qts!.text = widget.qtActu;
    _isQtsEmpty = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      child: Container(
        height: 290,
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
                height: 190,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Quantité totale: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          widget.qtPrix,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9.]'),
                        ),
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
                                  Navigator.of(context)
                                      .pop('${qts!.text}-1');
                                }
                              }
                            },
                            color: Color(0xFF1B8D41),
                            child: Text(
                              'Modifier',
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

// Voir bon de sortie
class VoirBon extends StatefulWidget {
  final BonSortieModel selectCom;
  final String type;
  VoirBon({
    Key? key,
    required this.selectCom,
    required this.type,
  }) : super(key: key);

  @override
  State<VoirBon> createState() => _VoirBonState();
}

class _VoirBonState extends State<VoirBon> {
  List<ContenuBon> bonList = [];
  bool isloading = true;
  CommandeDetaile? comDetails;
  ClientAdress? clientAdress;
  ResumerFacture? resumeFact;
  LogoCompany? logoComp;
  TextEditingController? user;
  String type = '';
  String sommePay = '0';
  List listdroit = ['ADMIN', 'CAISSE'];

  @override
  void initState() {
    super.initState();
    bonList = [];
    user = TextEditingController();
    isloading = true;
    getBonCnt();
    getBonClientPay();
  }

// recuperation du contenu de la commande
  void getBonCnt() {
    Services.getBonContent(widget.selectCom.id_bon, widget.type).then((value) {
      if (int.parse(value.map((e) => e.id_bon_ctn).toList()[0]) == 0) {
        ConfirmBox().showAlert(context, "Aucun contenu trouvé", false);
        setState(() {
          bonList = [];
          isloading = false;
        });
      } else if (int.parse(value.map((e) => e.id_bon_ctn).toList()[0]) < 0) {
        setState(() {
          bonList = [];
        });
        ConfirmBox().showAlert(context, "Erreur de connexion", false);
      } else {
        setState(() {
          bonList = value;
          isloading = false;
        });
      }
    });
  }

  // recuperer la somme ajouter pour un bon de sortie cote client
  getBonClientPay() {
    Services.getBonClientPay(widget.selectCom.id_bon).then((value) {
      if (int.parse(value) != -1) {
        setState(() {
          sommePay = value;
        });
      } else {
        setState(() {
          sommePay = '0';
        });
      }
    });
  }

//calcule de la quantite produit de la commande
  double getProdQts() {
    double qts = 0;
    for (int i = 0; i < bonList.length; i++) {
      qts += double.parse(bonList[i].qts_ctn);
    }
    return qts;
  }

// imppression de bon de sortie
  void imprime(addresse, String livraire, String somme) async {
    comDetails = CommandeDetaile(
        factureNum: widget.type == 'boutique'
            ? ConfirmBox().bonBoutique(widget.selectCom.date_bon.split('-')[0],
                widget.selectCom.id_bon)
            : ConfirmBox().bonClien(widget.selectCom.date_bon.split('-')[0],
                widget.selectCom.id_bon),
        factureDate: widget.selectCom.date_bon,
        payType: []);
    clientAdress = ClientAdress(name: widget.selectCom.nom_bon, adresse: '');
    resumeFact = ResumerFacture(total: somme, paye: '', rest: '');

    final pdfFile = await PdfBonApi.generate(
        addresse,
        logoComp!,
        comDetails!,
        clientAdress!,
        bonList,
        resumeFact!,
        widget.selectCom.agent_bon,
        livraire,
        widget.type == 'boutique' ? 'Boutique' : 'Client');
    PdfInvoiceApi.onpenFile(pdfFile)
        .then((value) =>
            ConfirmBox().showAlert(context, "Impression en cours", true))
        .then((value) => Navigator.of(context).pop('1'));
  }

  void getAdress(String livraire, String somme) {
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
    }).then((value) {
      if (value != '0') {
        imprime(value, livraire, somme);
      }
    });
  }

  SingleChildScrollView _fournisseuMove(String user) {
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
                      label: Text("Quantiteé"),
                    ),
                    DataColumn(
                      label: widget.selectCom.is_print_bon == '0'
                          ? Text("Action")
                          : Text("Etat"),
                    ),
                  ],
                  rows: bonList
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(Text(e.id_prod_ctn)),
                            DataCell(Text(e.prod_nom_bon_ctn)),
                            DataCell(Text(e.qts_ctn)),
                            DataCell(user == 'CAISSE'
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : widget.selectCom.is_print_bon == '0'
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
                                                  Services.deleteBonItem(
                                                          e.id_prod_ctn,
                                                          widget
                                                              .selectCom.id_bon,
                                                          e.qts_ctn)
                                                      .then((value) {
                                                    if (int.parse(value) == 1) {
                                                      ConfirmBox()
                                                          .showAlert(
                                                              context,
                                                              "Le produit a été supprimé avec success",
                                                              true)
                                                          .then((value) =>
                                                              getBonCnt());
                                                    } else if (int.parse(
                                                            value) ==
                                                        0) {
                                                      ConfirmBox().showAlert(
                                                          context,
                                                          "Impossible de supprimer cet produit",
                                                          false);
                                                    } else if (int.parse(
                                                            value) <
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
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          user!.text = state.user!.nom.toString();
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
                                "Détail du Bon de sortie",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (bonList.isEmpty) {
                                  ConfirmBox().showAlert(
                                      context,
                                      "Le bon de sortie ne peut pas être vide. Ajouter un élément",
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
                  Container(
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
                              height: 710,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: isloading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF26345d),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    widget.type == 'boutique'
                                                        ? 'Boutique: '
                                                        : 'Client: ',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(widget.selectCom.nom_bon,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    )),
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 2, right: 2, top: 5),
                                              margin: EdgeInsets.only(
                                                  bottom: 5, top: 10),
                                              child: Text(
                                                  'Bon de Sortie(${widget.type == 'boutique' ? ConfirmBox().bonBoutique(widget.selectCom.date_bon.split('-')[0], widget.selectCom.id_bon) : ConfirmBox().bonClien(widget.selectCom.date_bon.split('-')[0], widget.selectCom.id_bon)})/${widget.selectCom.date_bon}',
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
                                                Text(widget.selectCom.date_bon,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Container(
                                          height: 480,
                                          padding: EdgeInsets.only(
                                              left: 2, right: 2, top: 5),
                                          child: _fournisseuMove(state
                                              .user!.droit
                                              .toString()
                                              .toUpperCase()),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            state.user!.droit
                                                        .toString()
                                                        .toUpperCase() ==
                                                    "CAISSE"
                                                ? Text('')
                                                : int.parse(widget.selectCom
                                                            .is_print_bon) ==
                                                        0
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            Color(0xFF11A75C),
                                                        radius: 30,
                                                        child: Center(
                                                          child: IconButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AddProdBon(
                                                                      boutId: widget
                                                                          .selectCom
                                                                          .id_bout_bon,
                                                                      idBon: widget
                                                                          .selectCom
                                                                          .id_bon,
                                                                      bonDate: widget
                                                                          .selectCom
                                                                          .date_bon,
                                                                      boutName: widget
                                                                          .selectCom
                                                                          .nom_bon,
                                                                      existBon:
                                                                          bonList,
                                                                      type: widget
                                                                          .type,
                                                                    );
                                                                  }).then((value) {
                                                                setState(() {
                                                                  getBonCnt();
                                                                });
                                                              });
                                                            },
                                                            icon:
                                                                Icon(Icons.add),
                                                            iconSize: 40,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                    : Row(
                                                        children: [
                                                          Text('Livraire: ',
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(
                                                              widget.selectCom
                                                                  .livraire_bon,
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))
                                                        ],
                                                      ),
                                            !listdroit.contains(state
                                                    .user!.droit
                                                    .toString()
                                                    .toUpperCase())
                                                ? Text('')
                                                : int.parse(widget.selectCom
                                                            .is_print_bon) ==
                                                        0
                                                    ? MaterialButton(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return SetBonName(
                                                                  type: widget
                                                                      .type,
                                                                  bonId: widget
                                                                      .selectCom
                                                                      .id_bon,
                                                                );
                                                              }).then((value) {
                                                            if (value !=
                                                                '**0**') {
                                                              String livre =
                                                                  value;
                                                              Services.noticeBonPrint(
                                                                      widget
                                                                          .selectCom
                                                                          .id_bon,
                                                                      widget.type ==
                                                                              'boutique'
                                                                          ? livre
                                                                          : livre.split('-')[
                                                                              0])
                                                                  .then(
                                                                      (value) {
                                                                if (int.parse(
                                                                        value) <=
                                                                    0) {
                                                                  ConfirmBox()
                                                                      .showAlert(
                                                                          context,
                                                                          'Impossible d\'imprimer',
                                                                          false);
                                                                } else {
                                                                  getAdress(
                                                                      widget.type ==
                                                                              'boutique'
                                                                          ? livre
                                                                          : livre.split('-')[
                                                                              0],
                                                                      widget.type ==
                                                                              'boutique'
                                                                          ? ''
                                                                          : livre
                                                                              .split('-')[1]);
                                                                }
                                                              });
                                                            }
                                                          });
                                                        },
                                                        color:
                                                            Color(0xff008bff),
                                                        height: 55,
                                                        child: Text('Imprimer',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)))
                                                    : Text(''),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              padding: EdgeInsets.all(2),
                                              width: 280,
                                              height: 125,
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
                                                          widget.selectCom
                                                              .agent_bon,
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
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          bonList.isEmpty
                                                              ? '0'
                                                              : getProdQts()
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
                                                  widget.type != 'boutique'
                                                      ? widget.selectCom
                                                                  .is_print_bon ==
                                                              '1'
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    'Somme ajoutée: ',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Text(
                                                                    '$sommePay Fcfa',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    )),
                                                              ],
                                                            )
                                                          : Text('')
                                                      : Text(''),
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
// Fin voir bon de sortie

//remplissage du contenu de bon de sortie
class BonSortieCtn extends StatefulWidget {
  final String bonId;
  final String nomBout;
  BonSortieCtn({
    Key? key,
    required this.bonId,
    required this.nomBout,
  }) : super(key: key);

  @override
  State<BonSortieCtn> createState() => _BonSortieCtnState();
}

class _BonSortieCtnState extends State<BonSortieCtn> {
  List<Product>? productList;
  List<Product>? filterProdList;
  List<BonInfoModel>? infoBon;
  Product? prod;
  List<ContenuBon> comList = [];
  TextEditingController nbr = TextEditingController();
  bool isloading = true;
  final controller = ScrollController();
  final controller1 = ScrollController();

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
    infoBon = [];
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
          getBonInfos();
        }));
  }

  void getBonInfos() {
    Services.getBonSortieInfos(widget.bonId, 'boutique').then((value) {
      if (int.parse(value.map((e) => e.bon_id).toList()[0]) > 0) {
        setState(() {
          infoBon = value;
          isloading = false;
        });
      }
    });
  }

  double getProdQts() {
    double qts = 0;
    for (int i = 0; i < comList.length; i++) {
      qts += double.parse(comList[i].qts_ctn);
    }
    return qts;
  }

  int checkExitProduc(List<ContenuBon> list, String id) {
    int tem = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].id_prod_ctn == id) {
        tem = 1;
        break;
      }
    }
    return tem;
  }

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
            columns: const [
              DataColumn(
                label: Text("Désignation"),
              ),
              DataColumn(
                label: Text("Quantitée"),
              ),
              DataColumn(
                label: Text("Action"),
              ),
            ],
            rows: comList
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.prod_nom_bon_ctn)),
                      DataCell(Text(double.parse(e.qts_ctn).toString())),
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
                                      child: UpdBonElem(
                                        nameProd: e.prod_nom_bon_ctn,
                                        qtPrix: e.qts_total_ctn,
                                        qtActu: e.qts_ctn,
                                      ),
                                    );
                                  }).then((value) {
                                String qte = value.toString().split('-')[0];
                                value.toString().split('-')[1];
                                setState(() {
                                  for (int i = 0; i < comList.length; i++) {
                                    if (comList[i].id_prod_ctn ==
                                            e.id_prod_ctn &&
                                        comList[i].id_bon_ctn == e.id_bon_ctn) {
                                      comList[i].qts_ctn = qte;
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
      controller: controller1,
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
          columns: const [
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
                        e.stock.toString(),
                        style: TextStyle(
                            color: double.parse(e.stock) == 0
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
                                  comList.add(ContenuBon(
                                      qts_ctn: qte,
                                      id_prod_ctn: e.id_prod,
                                      id_bon_ctn: infoBon!
                                          .map((e) => e.bon_id)
                                          .toList()[0],
                                      prod_nom_bon_ctn: e.designation,
                                      qts_total_ctn: e.stock.toString(),
                                      id_bout_ctn: '',
                                      idClient: ''));
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
                                "Remplissage du contenu du bon de sortie",
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: isloading
                                ? Center(
                                    child: Container(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF26345d),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 716,
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
                                                  'Commande(${ConfirmBox().bonBoutique(infoBon!.map((e) => e.date_bon).toList()[0].split('-')[0], infoBon!.map((e) => e.bon_id).toList()[0])})/${infoBon!.map((e) => e.date_bon).toList()[0]}',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  )),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 2, right: 2, top: 5),
                                              margin:
                                                  EdgeInsets.only(bottom: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text('Client: ',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                        infoBon!
                                                            .map((e) =>
                                                                e.bout_nom)
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
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                        infoBon!
                                                            .map((e) =>
                                                                e.date_bon)
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
                                                    width: 1,
                                                    color: Colors.black),
                                              ),
                                              height: 435,
                                              width: 800,
                                              padding: EdgeInsets.only(
                                                  left: 2, right: 2, top: 5),
                                              child: ImprovedScrolling(
                                                enableCustomMouseWheelScrolling:
                                                    true,
                                                enableKeyboardScrolling: true,
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
                                                scrollController: controller,
                                                child: _fournisseuMove,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: comList.isEmpty
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                comList.isNotEmpty
                                                    ? Container(
                                                        height: 40,
                                                        width: 100,
                                                        child: MaterialButton(
                                                            onPressed: () {
                                                              for (int i = 0;
                                                                  i <
                                                                      comList
                                                                          .length;
                                                                  i++) {
                                                                Services
                                                                    .sendBonList(
                                                                  comList[i]
                                                                      .id_prod_ctn
                                                                      .toString(),
                                                                  comList[i]
                                                                      .qts_ctn
                                                                      .toString(),
                                                                  comList[i]
                                                                      .id_bon_ctn
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
                                                                  .then(
                                                                      (value) {
                                                                if (int.parse(
                                                                        value) ==
                                                                    1) {
                                                                  Navigator
                                                                      .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => state.user!.droit.toString().toUpperCase() ==
                                                                                'ADMIN'
                                                                            ? BonDeSortie()
                                                                            : state.user!.droit.toString().toUpperCase() == 'SECRET2'
                                                                                ? Secret2BonDeSortie()
                                                                                : state.user!.droit.toString().toUpperCase() == 'CAISSE'
                                                                                    ? CaisseBonDeSortie()
                                                                                    : CaisseBonDeSortie()),
                                                                  );
                                                                }
                                                              });
                                                            },
                                                            color: Color(
                                                                0xE0099B6A),
                                                            child: Text(
                                                              "Terminer",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                      )
                                                    : Text(''),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 15),
                                                  padding: EdgeInsets.all(7),
                                                  width: 400,
                                                  height: 100,
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
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Client: ',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            infoBon!
                                                                .map((e) =>
                                                                    e.bout_nom)
                                                                .toList()[0]
                                                                .toString(),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
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
                                                              : getProdQts()
                                                                  .toStringAsFixed(
                                                                      2)),
                                                        ],
                                                      ),
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
                                          bottom: 10,
                                          top: 10,
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
                                            width: 1, color: Colors.black),
                                      ),
                                      height: 540,
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
                                          scrollController: controller1,
                                          child: _comProdTable),
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
        });
  }
}

//ajout de produits au contenu du bon apres validation
class AddProdBon extends StatefulWidget {
  final String boutId;
  final String idBon;
  final String bonDate;
  final String boutName;
  final String type;
  final List<ContenuBon> existBon;

  AddProdBon({
    Key? key,
    required this.boutId,
    required this.idBon,
    required this.bonDate,
    required this.boutName,
    required this.type,
    required this.existBon,
  }) : super(key: key);

  @override
  State<AddProdBon> createState() => _AddProdBonState();
}

class _AddProdBonState extends State<AddProdBon> {
  List<Product>? productList;
  List<Product>? filterProdList;
  List<BonInfoModel>? infoBon;
  Product? prod;
  List<ContenuBon> bonList = [];
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
    bonList = [];
    productList = [];
    filterProdList = [];
    infoBon = [];
    seach.text = '';
    end.text = "0";
    getProdList(end.text, seach.text, true, true);
  }

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
            value.length < 12 ? endSuiv = true : endSuiv = false;
          });
        }
      }
    }).then((value) {
      setState(() {
        filterProdList = productList;
      });
    });
    getBonInfos();
  }

  void getBonInfos() {
    Services.getBonSortieInfos(widget.idBon, widget.type).then((value) {
      if (int.parse(value.map((e) => e.bon_id).toList()[0]) > 0) {
        setState(() {
          infoBon = value;
          isloading = false;
        });
      }
    });
  }

  double getProdQts() {
    double qts = 0;
    for (int i = 0; i < widget.existBon.length; i++) {
      qts += double.parse(widget.existBon[i].qts_ctn);
    }
    return qts;
  }

  int checkExitProduc(List<ContenuBon> list, String id) {
    int tem = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].id_prod_ctn == id) {
        tem = 1;
        break;
      }
    }
    return tem;
  }

  SingleChildScrollView get _fournisseuMove {
    return SingleChildScrollView(
      controller: ScrollController(),
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columnSpacing: 50,
            headingTextStyle: TextStyle(
              color: Color(0xFF26345d),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            horizontalMargin: 30,
            columns: const [
              DataColumn(
                label: Text("Désignation"),
              ),
              DataColumn(
                label: Text("Quantitée"),
              ),
              DataColumn(
                label: Text("Action"),
              ),
            ],
            rows: widget.existBon
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.prod_nom_bon_ctn)),
                      DataCell(Text(double.parse(e.qts_ctn).toString())),
                      DataCell(
                        e.id_prod_ctn.split('-').length > 1
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
                                                  nameProd: e.prod_nom_bon_ctn,
                                                  qtPrix: e.qts_total_ctn),
                                            );
                                          }).then((value) {
                                        String qte =
                                            value.toString().split('-')[0];
                                        setState(() {
                                          for (int i = 0;
                                              i < bonList.length;
                                              i++) {
                                            if (bonList[i].id_prod_ctn ==
                                                    e.id_prod_ctn &&
                                                bonList[i].id_bon_ctn ==
                                                    e.id_bon_ctn) {
                                              bonList[i].qts_ctn = qte;
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
                                            bonList.remove(e);
                                            widget.existBon.remove(e);
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

  final controlle = ScrollController();
  // Table des produits
  SingleChildScrollView get _comProdTable {
    return SingleChildScrollView(
      controller: controlle,
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
          columns: const [
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

                          if ((e.id_prod.split('-').length < 2 &&
                                  checkExitProduc(widget.existBon, e.id_prod) ==
                                      1) ||
                              (widget.existBon
                                  .map((e) => e.id_prod_ctn.split('-')[0])
                                  .toList()
                                  .contains(e.id_prod))) {
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
                                  bonList.add(
                                    ContenuBon(
                                      qts_ctn: qte,
                                      qts_total_ctn: e.stock.toString(),
                                      id_prod_ctn: '${e.id_prod}-1',
                                      id_bout_ctn: widget.boutId,
                                      id_bon_ctn: infoBon!
                                          .map((e) => e.bon_id)
                                          .toList()[0],
                                      prod_nom_bon_ctn: e.designation,
                                      idClient: '',
                                    ),
                                  );
                                  widget.existBon
                                      .add(bonList[bonList.length - 1]);
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
            isloading
                ? Expanded(
                    child: Center(
                      child: Container(
                        child: CircularProgressIndicator(
                          color: Color(0xFF26345d),
                        ),
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
                                            'Bon de Sortie(${widget.type == 'boutique' ? ConfirmBox().bonBoutique(widget.bonDate.split('-')[0], widget.idBon) : ConfirmBox().bonClien(widget.bonDate.split('-')[0], widget.idBon)})/${widget.bonDate}',
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
                                                  infoBon!
                                                      .map((e) => e.bout_nom)
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
                                                  infoBon!
                                                      .map((e) => e.date_bon)
                                                      .toList()[0]
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 400,
                                        padding: EdgeInsets.only(
                                            left: 2, right: 2, top: 5),
                                        child: _fournisseuMove,
                                      ),
                                      Row(
                                        mainAxisAlignment: bonList.isEmpty
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          bonList.isNotEmpty
                                              ? Container(
                                                  height: 40,
                                                  width: 100,
                                                  child: MaterialButton(
                                                      onPressed: () {
                                                        for (int i = 0;
                                                            i < bonList.length;
                                                            i++) {
                                                          Services.sendBonList(
                                                                  bonList[i]
                                                                          .id_prod_ctn
                                                                          .toString()
                                                                          .split(
                                                                              '-')[
                                                                      0],
                                                                  bonList[i]
                                                                      .qts_ctn
                                                                      .toString(),
                                                                  bonList[i]
                                                                      .id_bon_ctn
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
                                                      infoBon!
                                                          .map(
                                                              (e) => e.bout_nom)
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
                                                    Text(widget.existBon.isEmpty
                                                        ? '0'
                                                        : getProdQts()
                                                            .toStringAsFixed(
                                                                2)),
                                                  ],
                                                ),
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
                                            width: 1, color: Colors.black),
                                      ),
                                      height: 500,
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
                                          scrollController: controlle,
                                          child: _comProdTable),
                                    ),
                                    Container(
                                      width: 300,
                                      child: BootstrapContainer(
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
                                                                  ? Colors.black
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

// set bon Name
class SetBonName extends StatefulWidget {
  final String type;
  final String bonId;
  SetBonName({
    Key? key,
    required this.type,
    required this.bonId,
  }) : super(key: key);

  @override
  _SetBonNameState createState() => _SetBonNameState();
}

class _SetBonNameState extends State<SetBonName> {
  TextEditingController? nom;
  TextEditingController? somme;
  GlobalKey<FormState>? bonFormKey;
  bool _isNomEmpty = false;
  bool _isSommeEmpty = false;

  @override
  void initState() {
    nom = TextEditingController();
    somme = TextEditingController();
    bonFormKey = GlobalKey();
    _isNomEmpty = false;
    _isSommeEmpty = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      child: Container(
        height: widget.type != 'boutique' ? 330 : 290,
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
                          'Impression de bon de sortie',
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop('**0**');
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
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: nom!,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Entre le nom du livraire";
                        }
                      },
                      onSaved: (String? value) {},
                      decoration: InputDecoration(
                        hintText: "Nom du Client",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _isNomEmpty
                                    ? Color(0xFFDA0F0F)
                                    : Color(0xFF171817),
                                width: 1)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: _isNomEmpty
                                    ? Color(0xFFDA0F0F)
                                    : Color(0xFF171817),
                                width: 1)),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    widget.type != 'boutique'
                        ? TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: somme!,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Entre la somme";
                              }
                            },
                            onSaved: (String? value) {},
                            decoration: InputDecoration(
                              hintText: "Somme",
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _isSommeEmpty
                                          ? Color(0xFFDA0F0F)
                                          : Color(0xFF171817),
                                      width: 1)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _isSommeEmpty
                                          ? Color(0xFFDA0F0F)
                                          : Color(0xFF171817),
                                      width: 1)),
                            ),
                          )
                        : Text(''),
                    widget.type == ''
                        ? SizedBox(
                            height: 25,
                          )
                        : Text(''),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 40,
                          child: MaterialButton(
                            onPressed: () {
                              if (widget.type != 'boutique') {
                                if (nom!.text.isEmpty && somme!.text.isEmpty) {
                                  setState(() {
                                    _isNomEmpty = true;
                                    _isSommeEmpty = true;
                                  });
                                } else if (nom!.text.isNotEmpty &&
                                    somme!.text.isEmpty) {
                                  setState(() {
                                    _isNomEmpty = false;
                                    _isSommeEmpty = true;
                                  });
                                } else if (nom!.text.isEmpty &&
                                    somme!.text.isNotEmpty) {
                                  setState(() {
                                    _isNomEmpty = true;
                                    _isSommeEmpty = false;
                                  });
                                } else {
                                  Services.updBonClientPay(
                                          widget.bonId, somme!.text)
                                      .then((value) {
                                    if (int.parse(value) <= 0) {
                                      ConfirmBox().showAlert(context,
                                          'Erreur de connexion', false);
                                    } else {
                                      Navigator.of(context)
                                          .pop('${nom!.text}-${somme!.text}');
                                    }
                                  });
                                }
                              } else {
                                if (nom!.text.isEmpty) {
                                  setState(() {
                                    _isNomEmpty = true;
                                  });
                                } else {
                                  setState(() {
                                    _isNomEmpty = false;
                                    Navigator.of(context).pop(nom!.text);
                                  });
                                }
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

// saisi nom de facture pour bon de livraison cote client
class ClientFactureName extends StatefulWidget {
  ClientFactureName({
    Key? key,
  }) : super(key: key);

  @override
  _ClientFactureNameState createState() => _ClientFactureNameState();
}

class _ClientFactureNameState extends State<ClientFactureName> {
  TextEditingController? nom;
  bool _isNomEmpty = false;

  @override
  void initState() {
    nom = TextEditingController();
    _isNomEmpty = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Dialog(
            elevation: 20,
            child: Container(
              height: 290,
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
                                'Numéro de facture',
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop('**0**');
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
                      height: 190,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: nom!,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Entre le numéro de facture";
                              }
                            },
                            onSaved: (String? value) {},
                            decoration: InputDecoration(
                              hintText: "Numéro de facture",
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _isNomEmpty
                                          ? Color(0xFFDA0F0F)
                                          : Color(0xFF171817),
                                      width: 1)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: _isNomEmpty
                                          ? Color(0xFFDA0F0F)
                                          : Color(0xFF171817),
                                      width: 1)),
                            ),
                          ),
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
                                    if (nom!.text.isEmpty) {
                                      setState(() {
                                        _isNomEmpty = true;
                                      });
                                    } else {
                                      setState(() {
                                        _isNomEmpty = false;
                                      });
                                      int comId = 0;
                                      if (nom!.text.split("").length == 9 &&
                                          nom!.text.split("")[2] == 'F') {
                                        comId =
                                            int.parse(nom!.text.split("F")[1]);
                                      }

                                      Services.getVenteInfosForBon(
                                              comId.toString())
                                          .then((value) {
                                        if (int.parse(value
                                                .map((e) => e.venteId)
                                                .toList()[0]) ==
                                            0) {
                                          ConfirmBox().showAlert(
                                              context,
                                              'Le numero de facture est incorrect',
                                              false);
                                        } else if (int.parse(value
                                                .map((e) => e.venteId)
                                                .toList()[0]) <
                                            0) {
                                          ConfirmBox().showAlert(context,
                                              'Erreur de connexion', false);
                                        } else {
                                          String retour = value
                                              .map((e) =>
                                                  '${e.clientName}*${e.dateVente}*$comId')
                                              .toList()[0];
                                          Services.createBon(
                                                  '0',
                                                  value
                                                      .map((e) => e.clientName)
                                                      .toList()[0]
                                                      .split('-')[1],
                                                  state.user!.id.toString())
                                              .then((value) {
                                            Navigator.of(context).pop(retour);
                                          });
                                        }
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
                          )
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }
}

// ajouter un credit manuellement
class AddCredit extends StatefulWidget {
  AddCredit({
    Key? key,
  }) : super(key: key);
  @override
  State<AddCredit> createState() => _AddCreditState();
}

class _AddCreditState extends State<AddCredit> {
  TextEditingController? fact_num;
  TextEditingController? nom_client;
  TextEditingController? select_client;
  TextEditingController? total_fact;
  TextEditingController? total_cred;
  TextEditingController? user;
  TextEditingController? total_paye;
  TextEditingController? error_msg;
  TextEditingController? date_cred;
  GlobalKey<FormState>? _formKey;
  bool _existErro = false;
  List<String> payTypes = ['Espèce', 'Chèque', 'Orange Money', 'Moov Money'];
  List<String>? clientList;
  DateTime _date = DateTime.now();
  @override
  void initState() {
    super.initState();
    fact_num = TextEditingController();
    nom_client = TextEditingController();
    select_client = TextEditingController();
    total_fact = TextEditingController();
    total_cred = TextEditingController();
    error_msg = TextEditingController();
    total_paye = TextEditingController();
    date_cred = TextEditingController();
    user = TextEditingController();
    _formKey = GlobalKey<FormState>();
    clientList = [];
    getClientList();
  }

  _handleDate() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100));

    if (date != _date) {
      setState(() {
        _date = date!;
        date_cred!.text = date.toString().split(" ")[0];
      });
    }
  }

  // add credit
  addCredit() {
    Services.addCredit(
            select_client!.text.split('=>')[0],
            fact_num!.text,
            total_fact!.text,
            total_cred!.text,
            total_paye!.text,
            date_cred!.text,
            user!.text)
        .then((value) {
      if (int.parse(value) == 1) {
        ConfirmBox()
            .showAlert(context, "Crédit ajouté avec succès", true)
            .then((value) {
          setState(() {
            select_client!.text = '';
            fact_num!.text = '';
            total_fact!.text = '';
            total_cred!.text = '';
            total_paye!.text = '';
            date_cred!.text = '';
          });
        });
      } else if (int.parse(value) == 0) {
        ConfirmBox().showAlert(context, "Ajout de crédit echoué", false);
      } else if (int.parse(value) < 0) {
        ConfirmBox().showAlert(context, "Erreur de connexion", false);
      }
    });
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
                          value: select_client!.text,
                          required: false,
                          strict: false,
                          labelText: 'Rechercher un client',
                          items: clientList,
                          itemsVisibleInDropdown: 13,
                          onValueChanged: (dynamic newValue) {
                            select_client!.text = newValue;
                          }),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(select_client!.text);
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
                              select_client!.text = "";
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        user!.text = state.user!.id.toString();
        return Dialog(
          elevation: 20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          child: Container(
            height: 610,
            width: 755,
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
                              "Ajouter un crédit",
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
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  height: 530,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Row(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              !_existErro
                                  ? Text('')
                                  : Container(
                                      margin: EdgeInsets.all(10),
                                      child: Center(
                                        child: Text(
                                          error_msg!.text,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 350,
                                          padding: EdgeInsets.only(right: 5),
                                          child: MyFunction().inputFiled(
                                              "Numéro de facture",
                                              false,
                                              fact_num!,
                                              TextInputType.text,
                                              false,
                                              1,
                                              0,
                                              true),
                                        ),
                                        Container(
                                          width: 350,
                                          padding: EdgeInsets.only(right: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Nom Client',
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
                                                controller: nom_client!,
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
                                                    setState(() {
                                                      nom_client!.text =
                                                          select_client!.text
                                                              .split("=>")[1];
                                                    });
                                                  });
                                                },
                                                onSaved: (String? value) {},
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Sélectionner un client",
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
                                              "Total facture",
                                              false,
                                              total_fact!,
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
                                              "Total crédit",
                                              false,
                                              total_cred!,
                                              TextInputType.number,
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
                                              "Total payée",
                                              false,
                                              total_paye!,
                                              TextInputType.number,
                                              true,
                                              1,
                                              0,
                                              true),
                                        ),
                                        Container(
                                          width: 350,
                                          padding: EdgeInsets.only(right: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Date crédit',
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
                                                controller: date_cred!,
                                                validator: (String? value) {
                                                  if (value!.isEmpty) {
                                                    return "Veuillez sélectionner la date crédit ";
                                                  }
                                                },
                                                onTap: _handleDate,
                                                onSaved: (String? value) {},
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  hintText: "Date crédit",
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 90),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                  padding: EdgeInsets.only(top: 3, left: 3),
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (!_formKey!.currentState!.validate()) {
                                        return;
                                      } else {
                                        if (int.parse(total_fact!.text) <
                                            int.parse(total_cred!.text)) {
                                          setState(() {
                                            _existErro = true;
                                            error_msg!.text =
                                                "La somme du crédit ne doit pas être supperieur à la somme de la facture";
                                          });
                                        } else {
                                          if (int.parse(total_paye!.text) >
                                              int.parse(total_cred!.text)) {
                                            setState(() {
                                              _existErro = true;
                                              error_msg!.text =
                                                  "La somme payée ne doit pas être supperieur à la somme du crédit";
                                            });
                                          } else {
                                            setState(() {
                                              _existErro = false;
                                              error_msg!.text = "";
                                            });
                                            addCredit();
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
      },
    );
  }
}

// payer credit
class PayeCredit extends StatefulWidget {
  final String idCred;
  final String reste;
  PayeCredit({
    Key? key,
    required this.idCred,
    required this.reste,
  }) : super(key: key);
  @override
  State<PayeCredit> createState() => _PayeCreditState();
}

class _PayeCreditState extends State<PayeCredit> {
  TextEditingController? nom;
  TextEditingController? tel;
  TextEditingController? cnib;
  TextEditingController? somme;
  TextEditingController? user;
  TextEditingController? payType;
  TextEditingController? numero;
  GlobalKey<FormState>? _formKey;
  bool _numAdded = false;
  bool _isNumeEmpty = false;
  bool _isPaytypeEmpty = true;
  List<String> payTypes = ['Espèce', 'Chèque', 'Orange Money', 'Moov Money'];
  @override
  void initState() {
    super.initState();
    payType = TextEditingController();
    payType!.text = payTypes[0];
    numero = TextEditingController();
    nom = TextEditingController();
    tel = TextEditingController();
    cnib = TextEditingController();
    somme = TextEditingController();
    user = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _numAdded = false;
    _isNumeEmpty = false;
    _isPaytypeEmpty = true;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        user!.text = state.user!.id.toString();
        return Dialog(
          elevation: 20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          child: Container(
            height: 630,
            width: 755,
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
                              "Paiement de crédit",
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
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Text('Reste: ',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          '${widget.reste} Fcfa',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Container(
                                        width: 350,
                                        padding: EdgeInsets.only(right: 5),
                                        child: MyFunction().inputFiled(
                                            "Déponsant",
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
                                            "Téléphone",
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
                                            true),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 26,
                                  ),
                                  Text('Moyen de paiement',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Color(0xFF3E413E))),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                        width: 350,
                                        padding: EdgeInsets.only(right: 5),
                                        child: DropdownButtonFormField(
                                          value: payTypes[0],
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: _isPaytypeEmpty
                                                        ? Color(0xFF080808)
                                                        : Color(0xFFE70C0C),
                                                    width: 1)),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: _isPaytypeEmpty
                                                      ? Color(0xFF080808)
                                                      : Color(0xFFE70C0C),
                                                  width: 1),
                                            ),
                                          ),
                                          hint: Text(
                                            'Choisir un moyen de paiement',
                                            style: TextStyle(
                                                color: Color(0xFF3E413E)),
                                          ),
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              payType!.text = value;
                                              if (value == 'Orange Money' ||
                                                  value == 'Moov Money' ||
                                                  value == 'Chèque') {
                                                _numAdded = true;
                                              } else {
                                                _numAdded = false;
                                                numero!.text = '======';
                                              }
                                            });
                                          },
                                          items: payTypes.map((String? e) {
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e!,
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFF3E413E))),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      _numAdded
                                          ? Container(
                                              width: 350,
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                    RegExp(r'[0-9]'),
                                                  ),
                                                ],
                                                controller: numero!,
                                                validator: (String? value) {
                                                  if (value!.isEmpty) {
                                                    return "Entrer le numéro de transfert/compte";
                                                  }
                                                },
                                                onSaved: (String? value) {},
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Numéro de transfert/compte",
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: _isNumeEmpty
                                                              ? Color(
                                                                  0xFFDA0F0F)
                                                              : Color(
                                                                  0xFF171817),
                                                          width: 1)),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: _isNumeEmpty
                                                              ? Color(
                                                                  0xFFDA0F0F)
                                                              : Color(
                                                                  0xFF171817),
                                                          width: 1)),
                                                ),
                                              ),
                                            )
                                          : Text(''),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 90),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Container(
                                padding: EdgeInsets.only(top: 3, left: 3),
                                child: MaterialButton(
                                  onPressed: () {
                                    if (!_formKey!.currentState!.validate()) {
                                      return;
                                    } else {
                                      if (int.parse(widget.reste) <
                                          int.parse(somme!.text)) {
                                        ConfirmBox().showAlert(
                                            context,
                                            "Le montant ne doit pas depasser le reste",
                                            false);
                                      } else {
                                        loader(context);
                                        Services.rembourseCred(
                                          nom!.text,
                                          tel!.text,
                                          cnib!.text,
                                          somme!.text,
                                          widget.idCred,
                                          user!.text,
                                          numero!.text,
                                          payType!.text,
                                        ).then((value) {
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
                                                    'Operation effecutée avec succès.',
                                                    true)
                                                .then((value) =>
                                                    Navigator.of(context)
                                                        .pop());
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
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// detail de remboursement
class ListRembourse extends StatefulWidget {
  final String idCred;
  final CreditModel credit;
  ListRembourse({
    Key? key,
    required this.idCred,
    required this.credit,
  }) : super(key: key);

  @override
  State<ListRembourse> createState() => _ListRembourseState();
}

class _ListRembourseState extends State<ListRembourse> {
  List<RembourModel>? rembouList;
  final controller = ScrollController();
  LogoCompany? logoComp;
  ResumerFacture? resumeFact;
  List access = ['CAISSE', 'ADMIN'];
  @override
  void initState() {
    super.initState();
    rembouList = [];
    getRemboursListe();
  }

  //recuperation de virement
  getRemboursListe() {
    Services.getRemboursList(widget.idCred).then((value) {
      if (int.parse(value.map((e) => e.id_rem).toList()[0]) <= 0) {
        setState(() {
          rembouList = [];
        });
        if (int.parse(value.map((e) => e.id_rem).toList()[0]) < 0) {
          ConfirmBox().showAlert(context, 'Erreur de connexion', false);
        }
      } else if (int.parse(value.map((e) => e.id_rem).toList()[0]) > 0) {
        setState(() {
          rembouList = value;
        });
      }
    });
  }

  // imppression de facture de credit
  void imprime(String deposant, String payee, String date, String user) async {
    resumeFact =
        ResumerFacture(total: widget.credit.total_com, paye: payee, rest: date);
    final pdfFile = await PdfCreditApi.generate(
      logoComp!,
      widget.credit.nom.split("-=/")[0],
      deposant,
      widget.credit.paye,
      widget.credit.reste,
      int.parse(widget.credit.is_manual) == 1
          ? widget.credit.fact_num
          : ConfirmBox().numFacture(date.split('-')[0], widget.credit.nume),
      resumeFact!,
      user,
    );
    PdfInvoiceApi.onpenFile(pdfFile)
        .then((value) =>
            ConfirmBox().showAlert(context, "Impression en cours", true))
        .then((value) => Navigator.of(context).pop('1'));
  }

  SingleChildScrollView _fournisseuMove(String droit) {
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
                label: Container(child: Text("Déposant")),
              ),
              DataColumn(
                label: Text("Cnib"),
              ),
              DataColumn(
                label: Text("Tel"),
              ),
              DataColumn(
                label: Text("Somme"),
              ),
              DataColumn(
                label: Text("Moyen de paiement"),
              ),
              DataColumn(
                label: Text("Numéro de transfert"),
              ),
              DataColumn(
                label: Text("Date"),
              ),
              DataColumn(
                label: Text("Agent"),
              ),
              DataColumn(
                label: Text("Action"),
              ),
            ],
            rows: rembouList!
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.nom_rem)),
                      DataCell(Text(e.card_id_rem)),
                      DataCell(Text(e.tel_rem)),
                      DataCell(Text('${e.montant_pay_rem} F')),
                      DataCell(Text(e.pay_type)),
                      DataCell(Text(e.numero)),
                      DataCell(Text(e.date_rem)),
                      DataCell(Text(e.id_user_rem)),
                      DataCell(
                        int.parse(e.is_valid) == 0
                            ? Row(
                                children: [
                                  access.contains(droit)
                                      ? MaterialButton(
                                          onPressed: () {
                                            void getAdress() {
                                              Services.getCompayDetail(
                                                      '/company')
                                                  .then((value) {
                                                if (int.parse(value.id) > 0) {
                                                  setState(() {
                                                    logoComp = LogoCompany(
                                                        value.slogan_com,
                                                        value.nom_com,
                                                        value.adress);
                                                  });
                                                  imprime(
                                                      e.nom_rem,
                                                      e.montant_pay_rem,
                                                      e.date_rem,
                                                      e.id_user_rem);
                                                } else if (int.parse(
                                                        value.id) ==
                                                    0) {
                                                  ConfirmBox().showAlert(
                                                      context,
                                                      "Impossible d'imprimer la facture",
                                                      false);
                                                  return '0';
                                                } else if (int.parse(value.id) <
                                                    0) {
                                                  ConfirmBox().showAlert(
                                                      context,
                                                      'Erreur de connextion',
                                                      false);
                                                  return '0';
                                                }
                                              }).then((value) {
                                                if (value != '0') {}
                                              });
                                            }

                                            AlertBox()
                                                .showAlertDialod(
                                                    context,
                                                    int.parse(e.id_rem),
                                                    'Voulez-vous Valider cet paiement?',
                                                    'ValiderRembouser')
                                                .then((value) {
                                              if (int.parse(value) == 1) {
                                                Services.valideRembourse(
                                                        e.id_rem,
                                                        e.montant_pay_rem)
                                                    .then((value) {
                                                  if (int.parse(value) <= 0) {
                                                    ConfirmBox().showAlert(
                                                        context,
                                                        'Impossible de valider. Réessayer !',
                                                        false);
                                                  } else {
                                                    ConfirmBox()
                                                        .showAlert(
                                                            context,
                                                            'Validation réussi',
                                                            true)
                                                        .then((value) {
                                                      setState(() {
                                                        getRemboursListe();
                                                        getAdress();
                                                      });
                                                    });
                                                  }
                                                });
                                              }
                                            });
                                          },
                                          color: Colors.green,
                                          child: Text('Valider',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white)))
                                      : Text(''),
                                  droit == "CAISSE"
                                      ? Text('')
                                      : IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            AlertBox()
                                                .showAlertDialod(
                                                    context,
                                                    int.parse(e.id_rem),
                                                    'Voulez-vous supprimer cet paiement?',
                                                    'rembousement')
                                                .then((value) {
                                              if (int.parse(value) == -1) {
                                                ConfirmBox().showAlert(
                                                    context,
                                                    'Impossible de supprimer. Réessayer !',
                                                    false);
                                              } else if (int.parse(value) ==
                                                  1) {
                                                ConfirmBox()
                                                    .showAlert(
                                                        context,
                                                        'Suppression réussi',
                                                        true)
                                                    .then((value) {
                                                  setState(() {
                                                    getRemboursListe();
                                                  });
                                                });
                                              }
                                            });
                                          },
                                        ),
                                ],
                              )
                            : Icon(Icons.check, color: Colors.green),
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
                                "Détail de paiement",
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
                            flex: 7,
                            child: Container(
                              height: 700,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  Container(
                                    height: 700,
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
                                        scrollController: controller,
                                        child: _fournisseuMove(state.user!.droit
                                            .toString()
                                            .toUpperCase())),
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
          );
        });
  }
}

//gestion des vente au client
class CreateBonClient extends StatefulWidget {
  final String clientId;
  final String clientName;
  final String idCom;
  CreateBonClient({
    Key? key,
    required this.clientId,
    required this.clientName,
    required this.idCom,
  }) : super(key: key);
  @override
  State<CreateBonClient> createState() => _CreateBonClientState();
}

class _CreateBonClientState extends State<CreateBonClient> {
  List<Product>? productList;
  List<Product>? filterProdList;
  List<BonInfoModel>? infoBon;
  Product? prod;
  List<ContenuCom> comList = [];
  TextEditingController nbr = TextEditingController();
  bool isloading = true;
  final controller = ScrollController();
  final controller1 = ScrollController();

  TextEditingController seach = TextEditingController();
  TextEditingController seachInput = TextEditingController();

  TextEditingController end = TextEditingController();
  bool endPred = false;
  bool endSuiv = false;

  @override
  void initState() {
    super.initState();
    nbr = TextEditingController();
    comList = [];
    productList = [];
    filterProdList = [];
    infoBon = [];
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
          getBonInfos();
        }));
  }

  void getBonInfos() {
    Services.getBonSortieInfos(widget.clientId, '').then((value) {
      if (int.parse(value.map((e) => e.bon_id).toList()[0]) > 0) {
        setState(() {
          infoBon = value;
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
            columns: [
              DataColumn(
                label: Container(child: Text("ID")),
              ),
              DataColumn(
                label: Text("Désignation"),
              ),
              DataColumn(
                label: Text("Quantité"),
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
                      DataCell(
                          Text(double.parse(e.qtsProd).toStringAsFixed(2))),
                      DataCell(Text('${e.prixUnit} Fcfa')),
                      DataCell(Text(
                          '${(int.parse(e.prixUnit) * double.parse(e.qtsProd))
                                  .toStringAsFixed(2)} Fcfa')),
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
      controller: controller1,
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
          columns: const [
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
                                      qtPrix: double.parse(e.stock).toString(),
                                    ),
                                  );
                                }).then((value) {
                              if (value.toString().split('-').length > 1) {
                                String qte = value.toString().split('-')[0];
                                setState(() {
                                  comList.add(ContenuCom(
                                      idProd: e.id_prod,
                                      idFour: widget.clientId,
                                      qtsProd: qte,
                                      prixUnit: e.prix,
                                      designation: e.designation,
                                      idRav: infoBon!
                                          .map((e) => e.bon_id)
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
                                "Remplissage du contenu du bon de sortie",
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              height: 714,
                              margin: EdgeInsets.only(left: 10),
                              child: ListView(
                                children: [
                                  isloading
                                      ? Center(
                                          child: Container(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF26345d),
                                            ),
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 2, right: 2, top: 5),
                                              margin: EdgeInsets.only(
                                                  bottom: 15, top: 20),
                                              child: Text(
                                                  'Commande(${ConfirmBox().bonClien(infoBon!.map((e) => e.date_bon).toList()[0].split('-')[0], infoBon!.map((e) => e.bon_id).toList()[0])})/${infoBon!.map((e) => e.date_bon).toList()[0]}',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  )),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 2, right: 2, top: 5),
                                              margin:
                                                  EdgeInsets.only(bottom: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text('Client: ',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                        infoBon!
                                                            .map((e) =>
                                                                e.bout_nom)
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
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                        infoBon!
                                                            .map((e) =>
                                                                e.date_bon)
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
                                                    width: 1,
                                                    color: Colors.black),
                                              ),
                                              height: 430,
                                              padding: EdgeInsets.only(
                                                  left: 2, right: 2, top: 5),
                                              child: ImprovedScrolling(
                                                enableCustomMouseWheelScrolling:
                                                    true,
                                                enableKeyboardScrolling: true,
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
                                                scrollController: controller,
                                                child: _fournisseuMove,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: comList.isEmpty
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                comList.isNotEmpty
                                                    ? Container(
                                                        height: 40,
                                                        width: 100,
                                                        child: MaterialButton(
                                                            onPressed: () {
                                                              Services.addBonClientPay(
                                                                      widget
                                                                          .idCom,
                                                                      infoBon!.map((e) => e.bon_id).toList()[
                                                                          0],
                                                                      '0',
                                                                      state
                                                                          .user!
                                                                          .id
                                                                          .toString())
                                                                  .then(
                                                                      (value) {
                                                                if (int.parse(
                                                                        value) <=
                                                                    0) {
                                                                  ConfirmBox()
                                                                      .showAlert(
                                                                          context,
                                                                          'Erreur de connexion',
                                                                          false);
                                                                } else {
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          comList
                                                                              .length;
                                                                      i++) {
                                                                    Services
                                                                        .sendBonList(
                                                                      comList[i]
                                                                          .idProd,
                                                                      comList[i]
                                                                          .qtsProd,
                                                                      comList[i]
                                                                          .idRav,
                                                                    ).then(
                                                                        (value) {
                                                                      return value;
                                                                    });
                                                                  }
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
                                                                }
                                                              });
                                                            },
                                                            color: Color(
                                                                0xE0099B6A),
                                                            child: Text(
                                                              "Terminer",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                      )
                                                    : Text(''),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 15),
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
                                                                  FontWeight
                                                                      .bold),
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
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            infoBon!
                                                                .map((e) =>
                                                                    e.bout_nom)
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
                                                              : getProdQts(
                                                                      'qts')
                                                                  .toStringAsFixed(
                                                                      2)),
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
                                                              : '${getProdQts(
                                                                          'prix')
                                                                      .toStringAsFixed(
                                                                          2)} Fcfa'),
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
                                          bottom: 10,
                                          top: 10,
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
                                            width: 1, color: Colors.black),
                                      ),
                                      height: 547,
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
                                        scrollController: controller1,
                                        child: _comProdTable,
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      child: BootstrapContainer(
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
                                                                  ? Colors.black
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
        });
  }
}
