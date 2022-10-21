// ignore_for_file: prefer_const_constructors

import 'package:application_principal/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Links extends StatelessWidget {
  final IconData icone;
  final String name;
  final Function() redirect;
  final bool isClicked;

  // ignore: prefer_const_constructors_in_immutables
  Links({
    Key? key,
    required this.icone,
    required this.name,
    required this.redirect,
    this.isClicked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Container(
            // decoration: BoxDecoration(
            //   border: Border(
            //     left: BorderSide(color: Colors.yellowAccent, width: 1),
            //   ),
            // ),
            margin: EdgeInsets.only(left: 5.0),
            child: ListTile(
              leading: Icon(
                icone,
                color: isClicked
                    ? state.fullThemes!.sideBarTheme.foccusColor
                    : state.fullThemes!.sideBarTheme.secondaryColor,
              ),
              title: Text(
                name,
                style: TextStyle(
                  color: isClicked
                      ? state.fullThemes!.sideBarTheme.foccusColor
                      : state.fullThemes!.sideBarTheme.secondaryColor,
                ),
              ),
              onTap: redirect,
            ),
          );
        });
  }
}
