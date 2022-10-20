// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unused_field, prefer_final_fields, unused_local_variable

import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/Blocks/app_bar_cus.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/side_bar.dart';
import 'package:application_principal/Blocks/text_input.dart';
import 'package:application_principal/database/company_model.dart';
import 'package:application_principal/database/employee_model.dart';
import 'package:application_principal/database/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Compte extends StatefulWidget {
  const Compte({Key? key}) : super(key: key);

  @override
  _CompteState createState() => _CompteState();
}

class _CompteState extends State<Compte> {
  TextEditingController? user;
  final controler = ScrollController();
  CompanyModel compData = CompanyModel(
      id: '',
      nom_com: '',
      tel_com: '',
      logo_com: '',
      slogan_com: '',
      email_com: '',
      tel2_com: '',
      adress: '',
      tel3_com: '');
  EmployeeModel employes = EmployeeModel(
      nomEmp: '',
      cnibEmp: '',
      telEmp: '',
      motdepassEmp: '',
      idEmp: '',
      codeEmp: '',
      statutEmp: '',
      sexe: '',
      dateUser: '',
      username: '-1',
      droitEmp: '',
      salaireEmp: '');
  TextEditingController? nomComp;
  TextEditingController? emailCom;
  TextEditingController? adressCom;
  TextEditingController? tel1;
  TextEditingController? tel2;
  TextEditingController? tel3;

  TextEditingController? username;
  TextEditingController? oldPass;
  TextEditingController? newPass;
  TextEditingController? confiPass;
  TextEditingController? userCode;

  GlobalKey<FormState>? _formKey;
  List<String> sexeListe = ['M', 'F'];

  ScrollController control = ScrollController();
  bool _prodLoading = true;
  bool _isEmptyProd = true;
  bool _updUsername = false;
  bool _updPassword = false;
  bool _addCode = false;
  bool _updCompany = false;

  @override
  void initState() {
    _prodLoading = true;
    _isEmptyProd = true;
    _updUsername = false;
    _updPassword = false;
    _addCode = false;
    _updCompany = false;

    nomComp = TextEditingController();
    emailCom = TextEditingController();
    adressCom = TextEditingController();
    tel1 = TextEditingController();
    tel2 = TextEditingController();
    tel3 = TextEditingController();

    username = TextEditingController();
    oldPass = TextEditingController();
    newPass = TextEditingController();
    confiPass = TextEditingController();
    userCode = TextEditingController();

    user = TextEditingController();

    _formKey = GlobalKey<FormState>();
    getCompData();

    super.initState();
  }

  void getCompData() {
    Services.getCompayDetail('/company').then((value) {
      if (int.parse(value.id) > 0) {
        setState(() {
          compData = value;
        });
      } else {
        compData = CompanyModel(
            id: '',
            nom_com: '',
            tel_com: '',
            logo_com: '',
            slogan_com: '',
            email_com: '',
            tel2_com: '',
            adress: '',
            tel3_com: '');
      }
    });
  }

  void updComp(String id) {
    AlertBox()
        .showAlertDialod(context, 1, "Voulez-Vous appliquer les modifications?",
            'updCompInfos')
        .then((value) {
      if (int.parse(value) == 1) {
        Services.updCompInfos(nomComp!.text, adressCom!.text, emailCom!.text,
                tel1!.text, tel2!.text, tel3!.text, id)
            .then((value) {
          if (int.parse(value) > 0) {
            ConfirmBox()
                .showAlert(context, "Opération reussi", true)
                .then((value) {});
            setState(() {
              getCompData();
            });
          } else {
            ConfirmBox().showAlert(context, "Echec de modification", false);
          }
        });
      }
    });
  }

  void getEmpList(String id) {
    Services.getEmployees('one', id).then((value) {
      if (int.parse(value.map((e) => e.idEmp).toList()[0]) <= 0) {
        ConfirmBox().showAlert(context, "Aucune donnée trouvée", false);
      } else {
        _isEmptyProd = false;
        employes = value[0];
      }
      _prodLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          user!.text = state.user!.id.toString();

          nomComp!.text = compData.nom_com.toString();
          emailCom!.text = compData.email_com.toString();
          adressCom!.text = compData.adress.toString();
          tel1!.text = compData.tel_com.toString();
          tel2!.text = compData.tel2_com.toString();
          tel3!.text = compData.tel3_com.toString();
          username!.text = state.user!.username.toString();

          getEmpList(state.user!.id.toString());

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
                              child: AppBarCus(),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  left: state.isClosed! ? 0 : 7, top: 8),
                              child: Container(
                                color: Colors.white,
                                child: ListView(
                                  controller: control,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      padding: EdgeInsets.only(top: 9),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Information de l'entréprise",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          "Modifier les informations",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.red)),
                                                      Checkbox(
                                                          value: _updCompany,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              _updCompany =
                                                                  val!;
                                                            });
                                                          }),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Divider(),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: !_updCompany
                                                      ? Container(
                                                          width: 580,
                                                          decoration: BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.4),
                                                                    spreadRadius:
                                                                        2,
                                                                    blurRadius:
                                                                        7,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            3))
                                                              ],
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey),
                                                              color: Color(
                                                                  0xDA0D7736),
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10))),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10),
                                                          height: 230,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 20),
                                                            color: Colors.white,
                                                            child: Column(
                                                                children: [
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                            'Nom: '),
                                                                        Text(compData
                                                                            .nom_com
                                                                            .toString())
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                            'Adresse: '),
                                                                        Text(compData
                                                                            .adress
                                                                            .toString())
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                            'E-mail: '),
                                                                        Text(compData
                                                                            .email_com
                                                                            .toString())
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                            'Téléphone 1: '),
                                                                        Text(compData
                                                                            .tel_com
                                                                            .toString())
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                            'Téléphone 2: '),
                                                                        Text(compData
                                                                            .tel2_com
                                                                            .toString())
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                            'Téléphone 3: '),
                                                                        Text(compData
                                                                            .tel3_com
                                                                            .toString())
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ]),
                                                          ),
                                                        )
                                                      : Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
                                                                    child: MyFunction().inputFiled(
                                                                        "Nom",
                                                                        false,
                                                                        nomComp!,
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
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
                                                                    child: MyFunction().inputFiled(
                                                                        "Adresse",
                                                                        false,
                                                                        adressCom!,
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
                                                                      "Email",
                                                                      false,
                                                                      emailCom!,
                                                                      TextInputType
                                                                          .text,
                                                                      false,
                                                                      1,
                                                                      0,
                                                                      false),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
                                                                    child: MyFunction().inputFiled(
                                                                        "Téléphone 1",
                                                                        false,
                                                                        tel1!,
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
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
                                                                    child: MyFunction().inputFiled(
                                                                        "Téléphone 2",
                                                                        false,
                                                                        tel2!,
                                                                        TextInputType
                                                                            .text,
                                                                        false,
                                                                        1,
                                                                        0,
                                                                        false),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: MyFunction().inputFiled(
                                                                      "Téléphone 3",
                                                                      false,
                                                                      tel3!,
                                                                      TextInputType
                                                                          .text,
                                                                      false,
                                                                      1,
                                                                      0,
                                                                      false),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 16,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          20),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  MaterialButton(
                                                                    onPressed:
                                                                        () {
                                                                      if (!_formKey!
                                                                          .currentState!
                                                                          .validate()) {
                                                                        return;
                                                                      } else {
                                                                        updComp(state
                                                                            .company!
                                                                            .id
                                                                            .toString());
                                                                      }
                                                                    },
                                                                    minWidth:
                                                                        150,
                                                                    height: 60,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            17,
                                                                            136,
                                                                            47),
                                                                    elevation:
                                                                        0,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              2),
                                                                    ),
                                                                    child: Text(
                                                                      "Modifier",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      padding: EdgeInsets.only(top: 9),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 0),
                                            child: Text(
                                              "Information personnelle",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          Divider(),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.4),
                                                                spreadRadius: 2,
                                                                blurRadius: 7,
                                                                offset: Offset(
                                                                    0, 3))
                                                          ],
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  Colors.grey),
                                                          color:
                                                              Color(0xDA0484DA),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                        ),
                                                        margin: EdgeInsets.only(
                                                            right: 10),
                                                        height: 230,
                                                        child: Container(
                                                          color: Colors.white,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 20),
                                                          child:
                                                              Column(children: [
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Text('Nom: '),
                                                                  Text(employes
                                                                      .nomEmp)
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      'Sexe: '),
                                                                  Text(employes
                                                                              .sexe ==
                                                                          'M'
                                                                      ? 'Masculin'
                                                                      : 'Feminin')
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      'Téléphone: '),
                                                                  Text(employes
                                                                      .telEmp),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      'CNIB: '),
                                                                  Text(employes
                                                                      .cnibEmp)
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      'Date de naissance: '),
                                                                  Text(employes
                                                                      .dateUser)
                                                                ],
                                                              ),
                                                            ),
                                                          ]),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          updTitles(context),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          _addCode
                                                              ? addCode(
                                                                  userCode!,
                                                                  state.user!.id
                                                                      .toString())
                                                              : _updPassword
                                                                  ? upDPassWord(
                                                                      oldPass!,
                                                                      newPass!,
                                                                      confiPass!,
                                                                      state
                                                                          .user!
                                                                          .id
                                                                          .toString())
                                                                  : _updUsername
                                                                      ? updUserName(
                                                                          username!,
                                                                          state
                                                                              .user!
                                                                              .id
                                                                              .toString())
                                                                      : Text(
                                                                          ''),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ));
        });
  }

  Widget upDPassWord(
      TextEditingController oldPass,
      TextEditingController newPass,
      TextEditingController confirmPass,
      String id) {
    GlobalKey<FormState> passKey = GlobalKey();
    return Form(
      key: passKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 5),
                  child: MyFunction().inputFiled("Ancien mot de passe", false,
                      oldPass, TextInputType.text, false, 1, 0, true),
                ),
              ),
              Expanded(
                child: MyFunction().inputFiled("Nouveau mot de passe", false,
                    newPass, TextInputType.text, false, 1, 0, true),
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
                  padding: EdgeInsets.only(right: 5),
                  child: MyFunction().inputFiled(
                      "Confirmer le mot de passe",
                      false,
                      confirmPass,
                      TextInputType.text,
                      false,
                      1,
                      0,
                      true),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 100,
                      child: MaterialButton(
                        onPressed: () {
                          if (!passKey.currentState!.validate()) {
                            return;
                          } else {
                            if (newPass.text != confirmPass.text) {
                              ConfirmBox().showAlert(
                                  context,
                                  'Veuillez confirmer votre nouveau mot de passe',
                                  false);
                            } else {
                              Services.updPassword(
                                      id, oldPass.text, newPass.text)
                                  .then((value) {
                                if (int.parse(value) == 1) {
                                  ConfirmBox()
                                      .showAlert(
                                          context,
                                          'Mot de passe modifier avec succès. Veuillez vous reconnecter',
                                          true)
                                      .then((value) {
                                    Navigator.pushNamed(context, 'login');
                                  });
                                } else {
                                  ConfirmBox().showAlert(context,
                                      'Ancien mot de passe incorrect', false);
                                }
                              });
                            }
                          }
                        },
                        minWidth: 100,
                        height: 60,
                        color: Colors.red,
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
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget updUserName(TextEditingController username, String id) {
    GlobalKey<FormState> userKey = GlobalKey();
    return Form(
      key: userKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 5),
                  child: MyFunction().sufixinputFiled(
                      "Nom d'utilisateur",
                      false,
                      username,
                      TextInputType.text,
                      false,
                      1,
                      0,
                      true,
                      Colors.blueAccent, (() {
                    if (!userKey.currentState!.validate()) {
                      return;
                    } else {
                      Services.updUserName(id, username.text).then((value) {
                        if (int.parse(value) == 1) {
                          ConfirmBox()
                              .showAlert(
                                  context,
                                  'Modification réussi. Veuillez vous reconnecter...',
                                  true)
                              .then((value) {
                            Navigator.pushNamed(context, 'login');
                          });
                        } else {
                          ConfirmBox().showAlert(context,
                              'Echec!! Impossible de modifier.', false);
                        }
                      });
                    }
                  })),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget addCode(TextEditingController code, String id) {
    GlobalKey<FormState> codeKey = GlobalKey();
    return Form(
      key: codeKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 5),
                  child: MyFunction().sufixinputFiled(
                      "Code secret",
                      false,
                      code,
                      TextInputType.text,
                      false,
                      1,
                      0,
                      true,
                      Colors.green, (() {
                    if (!codeKey.currentState!.validate()) {
                      return;
                    } else {
                      Services.addCode(id, code.text).then((value) {
                        if (int.parse(value) == 1) {
                          ConfirmBox()
                              .showAlert(context,
                                  'Votre code a été modifié avec succès', true)
                              .then((value) {
                            code.text = '';
                          });
                        } else {
                          ConfirmBox()
                              .showAlert(context, 'Opération échoué', true);
                        }
                      });
                    }
                  })),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget updTitles(context) {
    double deviceWidth = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    return deviceWidth < 1910
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _updPassword = false;
                        _updUsername = true;
                        _addCode = false;
                      });
                    },
                    child: Text(
                      "Modifier le nom d'utilisateur",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _updPassword = true;
                        _updUsername = false;
                        _addCode = false;
                      });
                    },
                    child: Text(
                      "Modifier le mot de passe",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _updPassword = false;
                    _updUsername = false;
                    _addCode = true;
                  });
                },
                child: Text(
                  "Code secret",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _updPassword = false;
                    _updUsername = true;
                    _addCode = false;
                  });
                },
                child: Text(
                  "Modifier le nom d'utilisateur",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _updPassword = true;
                    _updUsername = false;
                    _addCode = false;
                  });
                },
                child: Text(
                  "Modifier le mot de passe",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _updPassword = false;
                    _updUsername = false;
                    _addCode = true;
                  });
                },
                child: Text(
                  "Code secret",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
  }
}
