// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, non_constant_identifier_names
import 'package:application_principal/Blocks/function.dart';
import 'package:application_principal/database/user.dart';
import 'package:application_principal/database/services.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Connection extends StatefulWidget {
  const Connection({Key? key}) : super(key: key);

  @override
  _ConnectionState createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  var platformName = '';

  TextEditingController? _username;
  TextEditingController? _password;
  GlobalKey<FormState>? _formKey;
  User? _connexion;
  bool? _isVisible;
  int cpt = 0;
  bool _isError = false;
  bool _isLoading = false;
  String _errorMsg = "";

  final IO.Socket _socket = IO.io("http://192.168.1.72:3000",
      IO.OptionBuilder().setTransports(['websocket']).build());

  _connectSocket() {
    // _socket.onConnect((data) => print("Connection established"));

    _socket.onConnectError((data) => print("Connect Error:$data"));
    _socket.onDisconnect((data) => print("Socket.IO server disconnected"));
  }

  String val = "";
  generateNumbers() {
    _socket.on("test", (data) {
      print(data);
      setState(() {
        val = data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _connectSocket();
    generateNumbers();
    _username = TextEditingController();
    _password = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _isVisible = true;
    _isError = false;
    _isLoading = false;

    if (kIsWeb) {
      platformName = "Web";
    } else {
      if (Platform.isAndroid) {
        platformName = "Android";
      } else if (Platform.isIOS) {
        platformName = "IOS";
      } else if (Platform.isFuchsia) {
        platformName = "Fuchsia";
      } else if (Platform.isLinux) {
        platformName = "Linux";
      } else if (Platform.isMacOS) {
        platformName = "MacOS";
      } else if (Platform.isWindows) {
        platformName = "Windows";
      }
    }
    print("platformName :- " + platformName.toString());
  }

  login() {
    Services.connection(_username!.text, _password!.text, "/login")
        .then((log_data) {
      if (log_data['status'] == 200) {
        _connexion = log_data['data'];
        String droit = _connexion!.droit;
        // Adding user infos to redux
        MyFunctions.setUser(context: context, user: _connexion!);
        // getting company data
        Services.getCompayDetail("/company").then((value) {
          print(value);
          // exist data
          if (value['status'] == 200) {
            // add company data to redux
            MyFunctions.setCompany(company: value['data'], context: context);
            // add the dashboard links to redux
            MyFunctions.setSideBareAction(droit: droit, context: context);
            if (droit.toUpperCase() == 'ADMIN') {
              MyFunctions.redirect(context: context, page: "dash");
            } else if (droit.toUpperCase() == 'SECRET1') {
              MyFunctions.redirect(
                  context: context, page: "Secre1comptabilite");
            } else if (droit.toUpperCase() == 'SECRET2') {
              MyFunctions.redirect(context: context, page: "Secre2vente");
            } else if (droit.toUpperCase() == 'MAGASIN') {
              MyFunctions.redirect(context: context, page: "maga_vente");
            } else if (droit.toUpperCase() == 'CAISSE') {
              MyFunctions.redirect(context: context, page: 'Caisse_vente');
            }
            // stop the loader
            setState(() {
              _isError = false;
              _isLoading = false;
            });
          } else {
            setState(() {
              _errorMsg = value['message'];
              _isError = true;
              _isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          _errorMsg = log_data['message'];
          _isError = true;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("lib/src/img/bg-large.jpg"),
                    fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: WindowTitleBarBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MinimizeWindowButton(
                            colors: WindowButtonColors(
                              normal: Color.fromARGB(255, 10, 28, 72),
                              iconNormal: Colors.white,
                              mouseOver: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          CloseWindowButton(
                            colors: WindowButtonColors(
                              normal: Color(0xFFF60B07),
                              iconNormal: Color.fromARGB(255, 255, 255, 255),
                              mouseOver: Color.fromARGB(255, 177, 21, 18),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "lib/src/img/icon_transparent.png"),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(0),
                              child: Text(
                                "Gestionnaire de stock 3.0.0",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF26345d),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(0),
                      child: Center(
                        child: Container(
                          width: 600,
                          height: 450,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          margin: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          decoration: BoxDecoration(
                            // ignore: prefer_const_literals_to_create_immutables
                            color: Color.fromARGB(255, 234, 242, 244),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                  offset: Offset(0, 0))
                            ],
                            border: Border.all(
                              color: Color(0xFFC6C6CE),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Connexion $val",
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF0C024F)),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          _isLoading
                                              ? CircularProgressIndicator(
                                                  color: Colors.red,
                                                )
                                              : _isError
                                                  ? Text(
                                                      _errorMsg,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    )
                                                  : Container(),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                inputFiled(
                                                    "Pseudo", false, _username),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                passwordFiled("Mot de passe",
                                                    _isVisible, _password),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 3, left: 3),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (!_formKey!.currentState!
                                                      .validate()) {
                                                    return;
                                                  } else {
                                                    _formKey!.currentState!
                                                        .save();
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    login();
                                                  }
                                                },
                                                minWidth: double.infinity,
                                                height: 60,
                                                color: Color(0xFF0C024F),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  "Valider",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 20,
                                          // ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.center,
                                          //   children: [
                                          //     Text(""),
                                          //     TextButton(
                                          //       onPressed: () {},
                                          //       child: Text(
                                          //         'Mot de passe oublié',
                                          //         style: TextStyle(
                                          //             color: Colors.red,
                                          //             fontSize: 15),
                                          //       ),
                                          //     )
                                          //   ],
                                          // )
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
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Développé par: ",
                          style: TextStyle(
                              color: Colors.blueGrey[900],
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        SelectableText(
                          "nanajeremie097@gmail.com",
                          style: TextStyle(
                              color: Color.fromARGB(255, 142, 50, 11),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget inputFiled(label, obscueText, name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: (TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0C024F))),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: name,
          validator: (String? value) {
            if (value!.isEmpty) {
              return "${"Le " + label} est obligatoire";
            }
            return null;
          },
          onSaved: (String? value) {},
          obscureText: obscueText,
          decoration: InputDecoration(
            hintText: "Exemple: BF20232251...",
            prefixIcon: Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(right: 10),
              color: Color(0xFF0C024F),
              child: Icon(
                Icons.person,
                color: Color(0xFFFFFFFF),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0C024F))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0C024F))),
          ),
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget passwordFiled(label, isvisible, name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: (TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0C024F))),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: name,
          validator: (String? value) {
            if (value!.isEmpty) {
              return "${"Le" + label} est obligatoire";
            }
            return null;
          },
          onSaved: (String? value) {},
          obscureText: isvisible ? true : false,
          decoration: InputDecoration(
            hintText: '***********************',
            prefixIcon: Container(
              width: 50,
              height: 50,
              color: Color(0xFF0C024F),
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.lock,
                color: Color(0xFFFFFFFF),
              ),
            ),
            suffixIcon: isvisible
                ? IconButton(
                    icon: Icon(
                      Icons.visibility_off,
                      color: Color(0xFF0C024F),
                    ),
                    onPressed: () {
                      setState(() {
                        _isVisible = false;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.visibility,
                      color: Color(0xFF0C024F),
                    ),
                    onPressed: () {
                      setState(() {
                        _isVisible = true;
                      });
                    },
                  ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0C024F))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0C024F))),
          ),
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }
}
