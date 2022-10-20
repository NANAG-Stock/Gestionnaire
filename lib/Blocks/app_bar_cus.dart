// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:application_principal/Blocks/function.dart';
import 'package:application_principal/Blocks/text_input.dart';
import 'package:application_principal/redux/actions.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Screens/connection.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarCus extends StatefulWidget {
  var scafKey;
  bool isDrawer;
  AppBarCus({Key? key, this.scafKey = "", this.isDrawer = false})
      : super(key: key);

  @override
  State<AppBarCus> createState() => _AppBarCusState();
}

class _AppBarCusState extends State<AppBarCus> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {
                                  if (MyFunctions.deviceSize(context)['w']! <=
                                      960) {
                                    widget.scafKey.currentState.openDrawer();
                                  } else {
                                    print("Yest");
                                    print(state.isClosed!);
                                    if (state.isClosed!) {
                                      StoreProvider.of<AppState>(context)
                                          .dispatch(
                                              OpenSideBar(isClosed: false));
                                    } else {
                                      StoreProvider.of<AppState>(context)
                                          .dispatch(
                                              OpenSideBar(isClosed: true));
                                    }
                                  }
                                },
                                icon: widget.isDrawer
                                    ? Icon(
                                        Icons.menu,
                                        color: Colors.white,
                                      )
                                    : state.isClosed!
                                        ? Icon(
                                            Icons.menu,
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.white,
                                          ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Center(
                                child: Text(
                                  state.company!.nom_com.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            state.user!.droit.toString().toUpperCase() ==
                                    "ADMIN"
                                ? "Administrateur"
                                : state.user!.droit.toString().toUpperCase() ==
                                        "SECRET1"
                                    ? "Secrétaire 1"
                                    : state.user!.droit
                                                .toString()
                                                .toUpperCase() ==
                                            "SECRET2"
                                        ? "Secrétaire 2"
                                        : state.user!.droit
                                                    .toString()
                                                    .toUpperCase() ==
                                                "CAISSE"
                                            ? "Caissière"
                                            : "Magasinier",
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Text(
                                  state.user!.nom,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Connection(),
                                        ),
                                      );
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.rightFromBracket,
                                      color: Color.fromARGB(255, 206, 29, 17),
                                    ))
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
                          mouseOver: Color(0xff101c3a)),
                    ),
                    MaximizeWindowButton(
                      colors: WindowButtonColors(
                        iconNormal: Colors.white,
                        mouseOver: Color(0xff101c3a),
                      ),
                    ),
                    CloseWindowButton(
                      colors: WindowButtonColors(
                          iconNormal: Colors.white,
                          mouseOver: Color(0xffff2926)),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}
