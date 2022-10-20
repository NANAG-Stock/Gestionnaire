// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyFunction {
  Widget inputFiled(label, obscueText, name, TextInputType type, bool isNum,
      int lines, double width, bool validate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: (TextStyle(
              fontSize: 17,
              color: Color(0xFF3E413E),
              fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          keyboardType: type,
          maxLines: lines,
          inputFormatters: [
            isNum
                ? FilteringTextInputFormatter.digitsOnly
                : FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9A-Za-z-.@éèàêî/ ]'),
                  ),
          ],
          controller: name!,
          validator: (String? value) {
            if (validate) {
              if (value!.isEmpty) {
                return "Veuillez remplire " + label;
              }
            }
            return null;
          },
          onSaved: (String? value) {},
          obscureText: obscueText,
          decoration: InputDecoration(
            hintText: label,
            contentPadding:
                EdgeInsets.symmetric(vertical: width, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF080808), width: 1),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF080808), width: 1),
            ),
          ),
        )
      ],
    );
  }

  Widget sufixinputFiled(
      label,
      obscueText,
      name,
      TextInputType type,
      bool isNum,
      int lines,
      double width,
      bool validate,
      Color sufixColor,
      Function() fonc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: (TextStyle(
              fontSize: 17,
              color: Color(0xFF3E413E),
              fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          keyboardType: type,
          maxLines: lines,
          inputFormatters: [
            isNum
                ? FilteringTextInputFormatter.digitsOnly
                : FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9A-Za-z-.@ ]'),
                  ),
          ],
          controller: name!,
          validator: (String? value) {
            if (validate) {
              if (value!.isEmpty) {
                return "Veuillez remplire " + label;
              }
            }
            return null;
          },
          onSaved: (String? value) {},
          obscureText: obscueText,
          decoration: InputDecoration(
            suffixIcon: MaterialButton(
              onPressed: fonc,
              minWidth: 100,
              height: 60,
              color: sufixColor,
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
            hintText: label,
            contentPadding:
                EdgeInsets.symmetric(vertical: width, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF080808), width: 1),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF080808), width: 1),
            ),
          ),
        )
      ],
    );
  }

  Widget dropdown(
      String title,
      List<String> elemList,
      TextEditingController? controler,
      bool checkEmpty,
      String type,
      String firstElm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        checkEmpty
            ? SizedBox(
                height: 20,
              )
            : SizedBox(
                height: 10,
              ),
        Text(
          title,
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        type != 'upd'
            ? DropdownButtonFormField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: checkEmpty
                              ? Color(0xFF080808)
                              : Color(0xFFE70C0C),
                          width: 1)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: checkEmpty
                              ? Color(0xFF080808)
                              : Color(0xFFE70C0C),
                          width: 1)),
                ),
                hint: Text(
                  'Choisir un $title',
                  style: TextStyle(color: Color(0xFF3E413E)),
                ),
                onChanged: (dynamic value) {
                  controler!.text = value;
                },
                items: elemList.map((String? e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e!, style: TextStyle(color: Color(0xFF3E413E))),
                  );
                }).toList(),
              )
            : DropdownButtonFormField(
                value: firstElm,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: checkEmpty
                              ? Color(0xFF080808)
                              : Color(0xFFE70C0C),
                          width: 1)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: checkEmpty
                              ? Color(0xFF080808)
                              : Color(0xFFE70C0C),
                          width: 1)),
                ),
                hint: Text(
                  'Choisir un $title',
                  style: TextStyle(color: Color(0xFF3E413E)),
                ),
                onChanged: (dynamic value) {
                  controler!.text = value;
                },
                items: elemList.map((String? e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e!, style: TextStyle(color: Color(0xFF3E413E))),
                  );
                }).toList(),
              ),
        !checkEmpty
            ? Container(
                padding: EdgeInsets.only(left: 10, top: 0),
                child: Text(
                  "Veuillez remplire $title",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.only(left: 10, top: 0),
                child: Text(''),
              ),
      ],
    );
  }
}
