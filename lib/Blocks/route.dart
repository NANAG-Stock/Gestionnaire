// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

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
          color: isClicked ? Colors.amber : Color(0xFFd9ddde),
        ),
        title: Text(
          name,
          style: TextStyle(
            color: isClicked ? Colors.amber : Color(0xFFd9ddde),
          ),
        ),
        onTap: redirect,
      ),
    );
  }
}
