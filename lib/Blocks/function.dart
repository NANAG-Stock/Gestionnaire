import 'dart:math';

import 'package:application_principal/database/company_model.dart';
import 'package:application_principal/database/user.dart';
import 'package:application_principal/redux/actions.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MyFunctions {
  static String chartVerticalData(
      {required double y, required List<int> vBar}) {
    switch (y.toInt()) {
      case 1:
        return MyFunctions.vertical(vBar) == 1000
            ? '1 000 F'
            : MyFunctions.vertical(vBar) == 5000
                ? '5 000 F'
                : MyFunctions.vertical(vBar) == 10000
                    ? '10 000 F'
                    : MyFunctions.vertical(vBar) == 100000
                        ? '100 000 F'
                        : MyFunctions.vertical(vBar) == 1000000
                            ? '1 000 000 F'
                            : MyFunctions.vertical(vBar) == 2000000
                                ? '2 000 000 F'
                                : MyFunctions.vertical(vBar) == 3000000
                                    ? '3 000 000 F'
                                    : MyFunctions.vertical(vBar) == 4000000
                                        ? '4 000 000 F'
                                        : MyFunctions.vertical(vBar) == 5000000
                                            ? '5 000 000 F'
                                            : MyFunctions.vertical(vBar) ==
                                                    6000000
                                                ? '6 000 000 F'
                                                : MyFunctions.vertical(vBar) ==
                                                        7000000
                                                    ? '7 000 000 F'
                                                    : MyFunctions.vertical(
                                                                vBar) ==
                                                            8000000
                                                        ? '8 000 000 F'
                                                        : MyFunctions.vertical(
                                                                    vBar) ==
                                                                9000000
                                                            ? '9 000 000 F'
                                                            : MyFunctions.vertical(
                                                                        vBar) ==
                                                                    10000000
                                                                ? '10 000 000 F'
                                                                : MyFunctions.vertical(
                                                                            vBar) ==
                                                                        11000000
                                                                    ? '11 000 000 F'
                                                                    : MyFunctions.vertical(vBar) ==
                                                                            12000000
                                                                        ? '12 000 000 F'
                                                                        : MyFunctions.vertical(vBar) ==
                                                                                13000000
                                                                            ? '13 000 000 F'
                                                                            : MyFunctions.vertical(vBar) == 14000000
                                                                                ? '14 000 000 F'
                                                                                : MyFunctions.vertical(vBar) == 15000000
                                                                                    ? '15 000 000 F'
                                                                                    : MyFunctions.vertical(vBar) == 16000000
                                                                                        ? '16 000 000 F'
                                                                                        : MyFunctions.vertical(vBar) == 17000000
                                                                                            ? "17000000 F"
                                                                                            : MyFunctions.vertical(vBar) == 18000000
                                                                                                ? "18 000 000 F"
                                                                                                : MyFunctions.vertical(vBar) == 19000000
                                                                                                    ? "19 000 000 F"
                                                                                                    : MyFunctions.vertical(vBar) == 20000000
                                                                                                        ? "20 000 000 F"
                                                                                                        : MyFunctions.vertical(vBar) == 21000000
                                                                                                            ? "21 000 000 F"
                                                                                                            : MyFunctions.vertical(vBar) == 22000000
                                                                                                                ? "22 000 000 F"
                                                                                                                : MyFunctions.vertical(vBar) == 23000000
                                                                                                                    ? "23 000 000 F"
                                                                                                                    : MyFunctions.vertical(vBar) == 24000000
                                                                                                                        ? "24 000 000 F"
                                                                                                                        : MyFunctions.vertical(vBar) == 25000000
                                                                                                                            ? "25 000 000 F"
                                                                                                                            : MyFunctions.vertical(vBar) == 26000000
                                                                                                                                ? "26 000 000 F"
                                                                                                                                : MyFunctions.vertical(vBar) == 27000000
                                                                                                                                    ? "27 000 000 F"
                                                                                                                                    : MyFunctions.vertical(vBar) == 28000000
                                                                                                                                        ? "28 000 000 F"
                                                                                                                                        : MyFunctions.vertical(vBar) == 29000000
                                                                                                                                            ? "29 000 000 F"
                                                                                                                                            : MyFunctions.vertical(vBar) == 30000000
                                                                                                                                                ? "30 000 000 F"
                                                                                                                                                : MyFunctions.vertical(vBar) == 31000000
                                                                                                                                                    ? '31 000 000 F'
                                                                                                                                                    : MyFunctions.vertical(vBar) == 32000000
                                                                                                                                                        ? "32 000 000 F"
                                                                                                                                                        : MyFunctions.vertical(vBar) == 33000000
                                                                                                                                                            ? "33 000 000 F"
                                                                                                                                                            : MyFunctions.vertical(vBar) == 34000000
                                                                                                                                                                ? "34 000 000 F"
                                                                                                                                                                : MyFunctions.vertical(vBar) == 35000000
                                                                                                                                                                    ? "35 000 000 F"
                                                                                                                                                                    : MyFunctions.vertical(vBar) == 36000000
                                                                                                                                                                        ? "36 000 000 F"
                                                                                                                                                                        : MyFunctions.vertical(vBar) == 37000000
                                                                                                                                                                            ? "37 000 000 F"
                                                                                                                                                                            : MyFunctions.vertical(vBar) == 38000000
                                                                                                                                                                                ? "38 000 000 F"
                                                                                                                                                                                : MyFunctions.vertical(vBar) == 39000000
                                                                                                                                                                                    ? "39 000 000 F"
                                                                                                                                                                                    : MyFunctions.vertical(vBar) == 40000000
                                                                                                                                                                                        ? "40 000 000 F"
                                                                                                                                                                                        : MyFunctions.vertical(vBar) == 41000000
                                                                                                                                                                                            ? "41 000 000 F"
                                                                                                                                                                                            : MyFunctions.vertical(vBar) == 42000000
                                                                                                                                                                                                ? "42 000 000 F"
                                                                                                                                                                                                : MyFunctions.vertical(vBar) == 43000000
                                                                                                                                                                                                    ? "43 000 000 F"
                                                                                                                                                                                                    : MyFunctions.vertical(vBar) == 44000000
                                                                                                                                                                                                        ? "44 000 000 F"
                                                                                                                                                                                                        : MyFunctions.vertical(vBar) == 45000000
                                                                                                                                                                                                            ? "45 000 000 F"
                                                                                                                                                                                                            : MyFunctions.vertical(vBar) == 46000000
                                                                                                                                                                                                                ? "46 000 000 F"
                                                                                                                                                                                                                : "47 000 000 F";
      case 3:
        return MyFunctions.vertical(vBar) == 1000
            ? '3 000 F'
            : MyFunctions.vertical(vBar) == 5000
                ? '15 000 F'
                : MyFunctions.vertical(vBar) == 10000
                    ? '30 000 F'
                    : MyFunctions.vertical(vBar) == 100000
                        ? '300 000 F'
                        : MyFunctions.vertical(vBar) == 1000000
                            ? '3 000 000 F'
                            : MyFunctions.vertical(vBar) == 2000000
                                ? '6 000 000 F'
                                : MyFunctions.vertical(vBar) == 3000000
                                    ? '9 000 000 F'
                                    : MyFunctions.vertical(vBar) == 4000000
                                        ? '12 000 000 F'
                                        : MyFunctions.vertical(vBar) == 5000000
                                            ? '15 000 000 F'
                                            : MyFunctions.vertical(vBar) ==
                                                    6000000
                                                ? '18 000 000 F'
                                                : MyFunctions.vertical(vBar) ==
                                                        7000000
                                                    ? '21 000 000 F'
                                                    : MyFunctions.vertical(
                                                                vBar) ==
                                                            8000000
                                                        ? '24 000 000 F'
                                                        : MyFunctions.vertical(
                                                                    vBar) ==
                                                                9000000
                                                            ? '27 000 000 F'
                                                            : MyFunctions.vertical(
                                                                        vBar) ==
                                                                    10000000
                                                                ? '30 000 000 F'
                                                                : MyFunctions.vertical(
                                                                            vBar) ==
                                                                        11000000
                                                                    ? '33 000 000 F'
                                                                    : MyFunctions.vertical(vBar) ==
                                                                            12000000
                                                                        ? '36 000 000 F'
                                                                        : MyFunctions.vertical(vBar) ==
                                                                                13000000
                                                                            ? '39 000 000 F'
                                                                            : MyFunctions.vertical(vBar) == 14000000
                                                                                ? '42 000 000 F'
                                                                                : MyFunctions.vertical(vBar) == 15000000
                                                                                    ? '45 000 000 F'
                                                                                    : MyFunctions.vertical(vBar) == 16000000
                                                                                        ? '48 000 000 F'
                                                                                        : MyFunctions.vertical(vBar) == 17000000
                                                                                            ? "51 000 000 F"
                                                                                            : MyFunctions.vertical(vBar) == 18000000
                                                                                                ? "54 000 000 F"
                                                                                                : MyFunctions.vertical(vBar) == 19000000
                                                                                                    ? "57 000 000 F"
                                                                                                    : MyFunctions.vertical(vBar) == 20000000
                                                                                                        ? "60 000 000 F"
                                                                                                        : MyFunctions.vertical(vBar) == 21000000
                                                                                                            ? "63 000 000 F"
                                                                                                            : MyFunctions.vertical(vBar) == 22000000
                                                                                                                ? "66 000 000 F"
                                                                                                                : MyFunctions.vertical(vBar) == 23000000
                                                                                                                    ? "69 000 000 F"
                                                                                                                    : MyFunctions.vertical(vBar) == 24000000
                                                                                                                        ? "72 000 000 F"
                                                                                                                        : MyFunctions.vertical(vBar) == 25000000
                                                                                                                            ? "75 000 000 F"
                                                                                                                            : MyFunctions.vertical(vBar) == 26000000
                                                                                                                                ? "78 000 000 F"
                                                                                                                                : MyFunctions.vertical(vBar) == 27000000
                                                                                                                                    ? "81 000 000 F"
                                                                                                                                    : MyFunctions.vertical(vBar) == 28000000
                                                                                                                                        ? "84 000 000 F"
                                                                                                                                        : MyFunctions.vertical(vBar) == 29000000
                                                                                                                                            ? "87 000 000 F"
                                                                                                                                            : MyFunctions.vertical(vBar) == 30000000
                                                                                                                                                ? "90 000 000 F"
                                                                                                                                                : MyFunctions.vertical(vBar) == 31000000
                                                                                                                                                    ? '93 000 000 F'
                                                                                                                                                    : MyFunctions.vertical(vBar) == 32000000
                                                                                                                                                        ? "96 000 000 F"
                                                                                                                                                        : MyFunctions.vertical(vBar) == 33000000
                                                                                                                                                            ? "99 000 000 F"
                                                                                                                                                            : MyFunctions.vertical(vBar) == 34000000
                                                                                                                                                                ? "102 000 000 F"
                                                                                                                                                                : MyFunctions.vertical(vBar) == 35000000
                                                                                                                                                                    ? "105 000 000 F"
                                                                                                                                                                    : MyFunctions.vertical(vBar) == 36000000
                                                                                                                                                                        ? "108 000 000 F"
                                                                                                                                                                        : MyFunctions.vertical(vBar) == 37000000
                                                                                                                                                                            ? "111 000 000 F"
                                                                                                                                                                            : MyFunctions.vertical(vBar) == 38000000
                                                                                                                                                                                ? "114 000 000 F"
                                                                                                                                                                                : MyFunctions.vertical(vBar) == 39000000
                                                                                                                                                                                    ? "117 000 000 F"
                                                                                                                                                                                    : MyFunctions.vertical(vBar) == 40000000
                                                                                                                                                                                        ? "120 000 000 F"
                                                                                                                                                                                        : MyFunctions.vertical(vBar) == 41000000
                                                                                                                                                                                            ? "123 000 000 F"
                                                                                                                                                                                            : MyFunctions.vertical(vBar) == 42000000
                                                                                                                                                                                                ? "126 000 000 F"
                                                                                                                                                                                                : MyFunctions.vertical(vBar) == 43000000
                                                                                                                                                                                                    ? "129 000 000 F"
                                                                                                                                                                                                    : MyFunctions.vertical(vBar) == 44000000
                                                                                                                                                                                                        ? "132 000 000 F"
                                                                                                                                                                                                        : MyFunctions.vertical(vBar) == 45000000
                                                                                                                                                                                                            ? "135 000 000 F"
                                                                                                                                                                                                            : MyFunctions.vertical(vBar) == 46000000
                                                                                                                                                                                                                ? "138 000 000 F"
                                                                                                                                                                                                                : "141 000 000 F";
      case 5:
        return MyFunctions.vertical(vBar) == 1000
            ? '5000 F'
            : MyFunctions.vertical(vBar) == 5000
                ? '25000 F'
                : MyFunctions.vertical(vBar) == 10000
                    ? '50 000 F'
                    : MyFunctions.vertical(vBar) == 100000
                        ? '500 000 F'
                        : MyFunctions.vertical(vBar) == 1000000
                            ? '5 000 000 F'
                            : MyFunctions.vertical(vBar) == 2000000
                                ? '10 000 000 F'
                                : MyFunctions.vertical(vBar) == 3000000
                                    ? '15 000 000 F'
                                    : MyFunctions.vertical(vBar) == 4000000
                                        ? '20 000 000 F'
                                        : MyFunctions.vertical(vBar) == 5000000
                                            ? '25 000 000 F'
                                            : MyFunctions.vertical(vBar) ==
                                                    6000000
                                                ? '30 000 000 F'
                                                : MyFunctions.vertical(vBar) ==
                                                        7000000
                                                    ? '35 000 000 F'
                                                    : MyFunctions.vertical(
                                                                vBar) ==
                                                            8000000
                                                        ? '40 000 000 F'
                                                        : MyFunctions.vertical(
                                                                    vBar) ==
                                                                9000000
                                                            ? '45 000 000 F'
                                                            : MyFunctions.vertical(
                                                                        vBar) ==
                                                                    10000000
                                                                ? '50 000 000 F'
                                                                : MyFunctions.vertical(
                                                                            vBar) ==
                                                                        11000000
                                                                    ? '55 000 000 F'
                                                                    : MyFunctions.vertical(vBar) ==
                                                                            12000000
                                                                        ? '60 000 000 F'
                                                                        : MyFunctions.vertical(vBar) ==
                                                                                13000000
                                                                            ? '65 000 000 F'
                                                                            : MyFunctions.vertical(vBar) == 14000000
                                                                                ? '70 000 000 F'
                                                                                : MyFunctions.vertical(vBar) == 15000000
                                                                                    ? '75 000 000 F'
                                                                                    : MyFunctions.vertical(vBar) == 16000000
                                                                                        ? '80 000 000 F'
                                                                                        : MyFunctions.vertical(vBar) == 17000000
                                                                                            ? "85 000 000 F"
                                                                                            : MyFunctions.vertical(vBar) == 18000000
                                                                                                ? "90 000 000 F"
                                                                                                : MyFunctions.vertical(vBar) == 19000000
                                                                                                    ? "95 000 000 F"
                                                                                                    : MyFunctions.vertical(vBar) == 20000000
                                                                                                        ? "100 000 000 F"
                                                                                                        : MyFunctions.vertical(vBar) == 21000000
                                                                                                            ? "105 000 000 F"
                                                                                                            : MyFunctions.vertical(vBar) == 22000000
                                                                                                                ? "110 000 000 F"
                                                                                                                : MyFunctions.vertical(vBar) == 23000000
                                                                                                                    ? "115 000 000 F"
                                                                                                                    : MyFunctions.vertical(vBar) == 24000000
                                                                                                                        ? "120 000 000 F"
                                                                                                                        : MyFunctions.vertical(vBar) == 25000000
                                                                                                                            ? "125 000 000 F"
                                                                                                                            : MyFunctions.vertical(vBar) == 26000000
                                                                                                                                ? "130 000 000 F"
                                                                                                                                : MyFunctions.vertical(vBar) == 27000000
                                                                                                                                    ? "135 000 000 F"
                                                                                                                                    : MyFunctions.vertical(vBar) == 28000000
                                                                                                                                        ? "140 000 000 F"
                                                                                                                                        : MyFunctions.vertical(vBar) == 29000000
                                                                                                                                            ? "145 000 000 F"
                                                                                                                                            : MyFunctions.vertical(vBar) == 30000000
                                                                                                                                                ? "150 000 000 F"
                                                                                                                                                : MyFunctions.vertical(vBar) == 31000000
                                                                                                                                                    ? '155 000 000 F'
                                                                                                                                                    : MyFunctions.vertical(vBar) == 32000000
                                                                                                                                                        ? "160 000 000 F"
                                                                                                                                                        : MyFunctions.vertical(vBar) == 33000000
                                                                                                                                                            ? "165 000 000 F"
                                                                                                                                                            : MyFunctions.vertical(vBar) == 34000000
                                                                                                                                                                ? "170 000 000 F"
                                                                                                                                                                : MyFunctions.vertical(vBar) == 35000000
                                                                                                                                                                    ? "175 000 000 F"
                                                                                                                                                                    : MyFunctions.vertical(vBar) == 36000000
                                                                                                                                                                        ? "180 000 000 F"
                                                                                                                                                                        : MyFunctions.vertical(vBar) == 37000000
                                                                                                                                                                            ? "185 000 000 F"
                                                                                                                                                                            : MyFunctions.vertical(vBar) == 38000000
                                                                                                                                                                                ? "190 000 000 F"
                                                                                                                                                                                : MyFunctions.vertical(vBar) == 39000000
                                                                                                                                                                                    ? "195 000 000 F"
                                                                                                                                                                                    : MyFunctions.vertical(vBar) == 40000000
                                                                                                                                                                                        ? "200 000 000 F"
                                                                                                                                                                                        : MyFunctions.vertical(vBar) == 41000000
                                                                                                                                                                                            ? "205 000 000 F"
                                                                                                                                                                                            : MyFunctions.vertical(vBar) == 42000000
                                                                                                                                                                                                ? "210 000 000 F"
                                                                                                                                                                                                : MyFunctions.vertical(vBar) == 43000000
                                                                                                                                                                                                    ? "215 000 000 F"
                                                                                                                                                                                                    : MyFunctions.vertical(vBar) == 44000000
                                                                                                                                                                                                        ? "220 000 000 F"
                                                                                                                                                                                                        : MyFunctions.vertical(vBar) == 45000000
                                                                                                                                                                                                            ? "225 000 000 F"
                                                                                                                                                                                                            : MyFunctions.vertical(vBar) == 46000000
                                                                                                                                                                                                                ? "230 000 000 F"
                                                                                                                                                                                                                : "235 000 000 F";
      case 7:
        return MyFunctions.vertical(vBar) == 1000
            ? '7 000 F'
            : MyFunctions.vertical(vBar) == 5000
                ? '35 000 F'
                : MyFunctions.vertical(vBar) == 10000
                    ? '70 000 F'
                    : MyFunctions.vertical(vBar) == 100000
                        ? '700 000 F'
                        : MyFunctions.vertical(vBar) == 1000000
                            ? '7 000 000 F'
                            : MyFunctions.vertical(vBar) == 2000000
                                ? '14 000 000 F'
                                : MyFunctions.vertical(vBar) == 3000000
                                    ? '21 000 000 F'
                                    : MyFunctions.vertical(vBar) == 4000000
                                        ? '28 000 000 F'
                                        : MyFunctions.vertical(vBar) == 5000000
                                            ? '35 000 000 F'
                                            : MyFunctions.vertical(vBar) ==
                                                    6000000
                                                ? '42 000 000 F'
                                                : MyFunctions.vertical(vBar) ==
                                                        7000000
                                                    ? '49 000 000 F'
                                                    : MyFunctions.vertical(
                                                                vBar) ==
                                                            8000000
                                                        ? '56 000 000 F'
                                                        : MyFunctions.vertical(
                                                                    vBar) ==
                                                                9000000
                                                            ? '63 000 000 F'
                                                            : MyFunctions.vertical(
                                                                        vBar) ==
                                                                    10000000
                                                                ? '70 000 000 F'
                                                                : MyFunctions.vertical(
                                                                            vBar) ==
                                                                        11000000
                                                                    ? '77 000 000 F'
                                                                    : MyFunctions.vertical(vBar) ==
                                                                            12000000
                                                                        ? '84 000 000 F'
                                                                        : MyFunctions.vertical(vBar) ==
                                                                                13000000
                                                                            ? '91 000 000 F'
                                                                            : MyFunctions.vertical(vBar) == 14000000
                                                                                ? '98 000 000 F'
                                                                                : MyFunctions.vertical(vBar) == 15000000
                                                                                    ? '105 000 000 F'
                                                                                    : MyFunctions.vertical(vBar) == 16000000
                                                                                        ? '112 000 000 F'
                                                                                        : MyFunctions.vertical(vBar) == 17000000
                                                                                            ? "119 000 000 F"
                                                                                            : MyFunctions.vertical(vBar) == 18000000
                                                                                                ? "126 000 000 F"
                                                                                                : MyFunctions.vertical(vBar) == 19000000
                                                                                                    ? "133 000 000 F"
                                                                                                    : MyFunctions.vertical(vBar) == 20000000
                                                                                                        ? "140 000 000 F"
                                                                                                        : MyFunctions.vertical(vBar) == 21000000
                                                                                                            ? "147 000 000 F"
                                                                                                            : MyFunctions.vertical(vBar) == 22000000
                                                                                                                ? "154 000 000 F"
                                                                                                                : MyFunctions.vertical(vBar) == 23000000
                                                                                                                    ? "161 000 000 F"
                                                                                                                    : MyFunctions.vertical(vBar) == 24000000
                                                                                                                        ? "168 000 000 F"
                                                                                                                        : MyFunctions.vertical(vBar) == 25000000
                                                                                                                            ? "175 000 000 F"
                                                                                                                            : MyFunctions.vertical(vBar) == 26000000
                                                                                                                                ? "182 000 000 F"
                                                                                                                                : MyFunctions.vertical(vBar) == 27000000
                                                                                                                                    ? "189 000 000 F"
                                                                                                                                    : MyFunctions.vertical(vBar) == 28000000
                                                                                                                                        ? "196 000 000 F"
                                                                                                                                        : MyFunctions.vertical(vBar) == 29000000
                                                                                                                                            ? "203 000 000 F"
                                                                                                                                            : MyFunctions.vertical(vBar) == 30000000
                                                                                                                                                ? "210 000 000 F"
                                                                                                                                                : MyFunctions.vertical(vBar) == 31000000
                                                                                                                                                    ? '217 000 000 F'
                                                                                                                                                    : MyFunctions.vertical(vBar) == 32000000
                                                                                                                                                        ? "224 000 000 F"
                                                                                                                                                        : MyFunctions.vertical(vBar) == 33000000
                                                                                                                                                            ? "231 000 000 F"
                                                                                                                                                            : MyFunctions.vertical(vBar) == 34000000
                                                                                                                                                                ? "238 000 000 F"
                                                                                                                                                                : MyFunctions.vertical(vBar) == 35000000
                                                                                                                                                                    ? "245 000 000 F"
                                                                                                                                                                    : MyFunctions.vertical(vBar) == 36000000
                                                                                                                                                                        ? "252 000 000 F"
                                                                                                                                                                        : MyFunctions.vertical(vBar) == 37000000
                                                                                                                                                                            ? "259 000 000 F"
                                                                                                                                                                            : MyFunctions.vertical(vBar) == 38000000
                                                                                                                                                                                ? "266 000 000 F"
                                                                                                                                                                                : MyFunctions.vertical(vBar) == 39000000
                                                                                                                                                                                    ? "273 000 000 F"
                                                                                                                                                                                    : MyFunctions.vertical(vBar) == 40000000
                                                                                                                                                                                        ? "280 000 000 F"
                                                                                                                                                                                        : MyFunctions.vertical(vBar) == 41000000
                                                                                                                                                                                            ? "287 000 000 F"
                                                                                                                                                                                            : MyFunctions.vertical(vBar) == 42000000
                                                                                                                                                                                                ? "294 000 000 F"
                                                                                                                                                                                                : MyFunctions.vertical(vBar) == 43000000
                                                                                                                                                                                                    ? "301 000 000 F"
                                                                                                                                                                                                    : MyFunctions.vertical(vBar) == 44000000
                                                                                                                                                                                                        ? "308 000 000 F"
                                                                                                                                                                                                        : MyFunctions.vertical(vBar) == 45000000
                                                                                                                                                                                                            ? "315 000 000 F"
                                                                                                                                                                                                            : MyFunctions.vertical(vBar) == 46000000
                                                                                                                                                                                                                ? "322 000 000 F"
                                                                                                                                                                                                                : "329 000 000 F";
      case 9:
        return MyFunctions.vertical(vBar) == 1000
            ? '9 000 F'
            : MyFunctions.vertical(vBar) == 5000
                ? '45 000 F'
                : MyFunctions.vertical(vBar) == 10000
                    ? '90 000 F'
                    : MyFunctions.vertical(vBar) == 100000
                        ? '900 000 F'
                        : MyFunctions.vertical(vBar) == 1000000
                            ? '9 000 000 F'
                            : MyFunctions.vertical(vBar) == 2000000
                                ? '18 000 000 F'
                                : MyFunctions.vertical(vBar) == 3000000
                                    ? '27 000 000 F'
                                    : MyFunctions.vertical(vBar) == 4000000
                                        ? '36 000 000 F'
                                        : MyFunctions.vertical(vBar) == 5000000
                                            ? '45 000 000 F'
                                            : MyFunctions.vertical(vBar) ==
                                                    6000000
                                                ? '54 000 000 F'
                                                : MyFunctions.vertical(vBar) ==
                                                        7000000
                                                    ? '63 000 000 F'
                                                    : MyFunctions.vertical(
                                                                vBar) ==
                                                            8000000
                                                        ? '72 000 000 F'
                                                        : MyFunctions.vertical(
                                                                    vBar) ==
                                                                9000000
                                                            ? '81 000 000 F'
                                                            : MyFunctions.vertical(
                                                                        vBar) ==
                                                                    10000000
                                                                ? '90 000 000 F'
                                                                : MyFunctions.vertical(
                                                                            vBar) ==
                                                                        11000000
                                                                    ? '99 000 000 F'
                                                                    : MyFunctions.vertical(vBar) ==
                                                                            12000000
                                                                        ? '108 000 000 F'
                                                                        : MyFunctions.vertical(vBar) ==
                                                                                13000000
                                                                            ? '117 000 000 F'
                                                                            : MyFunctions.vertical(vBar) == 14000000
                                                                                ? '126 000 000 F'
                                                                                : MyFunctions.vertical(vBar) == 15000000
                                                                                    ? '135 000 000 F'
                                                                                    : MyFunctions.vertical(vBar) == 16000000
                                                                                        ? '144 000 000 F'
                                                                                        : MyFunctions.vertical(vBar) == 17000000
                                                                                            ? "153 000 000 F"
                                                                                            : MyFunctions.vertical(vBar) == 18000000
                                                                                                ? "162 000 000 F"
                                                                                                : MyFunctions.vertical(vBar) == 19000000
                                                                                                    ? "171 000 000 F"
                                                                                                    : MyFunctions.vertical(vBar) == 20000000
                                                                                                        ? "180 000 000 F"
                                                                                                        : MyFunctions.vertical(vBar) == 21000000
                                                                                                            ? "189 000 000 F"
                                                                                                            : MyFunctions.vertical(vBar) == 22000000
                                                                                                                ? "198 000 000 F"
                                                                                                                : MyFunctions.vertical(vBar) == 23000000
                                                                                                                    ? "207 000 000 F"
                                                                                                                    : MyFunctions.vertical(vBar) == 24000000
                                                                                                                        ? "216 000 000 F"
                                                                                                                        : MyFunctions.vertical(vBar) == 25000000
                                                                                                                            ? "225 000 000 F"
                                                                                                                            : MyFunctions.vertical(vBar) == 26000000
                                                                                                                                ? "234 000 000 F"
                                                                                                                                : MyFunctions.vertical(vBar) == 27000000
                                                                                                                                    ? "243 000 000 F"
                                                                                                                                    : MyFunctions.vertical(vBar) == 28000000
                                                                                                                                        ? "252 000 000 F"
                                                                                                                                        : MyFunctions.vertical(vBar) == 29000000
                                                                                                                                            ? "261 000 000 F"
                                                                                                                                            : MyFunctions.vertical(vBar) == 30000000
                                                                                                                                                ? "270 000 000 F"
                                                                                                                                                : MyFunctions.vertical(vBar) == 31000000
                                                                                                                                                    ? '279 000 000 F'
                                                                                                                                                    : MyFunctions.vertical(vBar) == 32000000
                                                                                                                                                        ? "288 000 000 F"
                                                                                                                                                        : MyFunctions.vertical(vBar) == 33000000
                                                                                                                                                            ? "297 000 000 F"
                                                                                                                                                            : MyFunctions.vertical(vBar) == 34000000
                                                                                                                                                                ? "306 000 000 F"
                                                                                                                                                                : MyFunctions.vertical(vBar) == 35000000
                                                                                                                                                                    ? "315 000 000 F"
                                                                                                                                                                    : MyFunctions.vertical(vBar) == 36000000
                                                                                                                                                                        ? "324 000 000 F"
                                                                                                                                                                        : MyFunctions.vertical(vBar) == 37000000
                                                                                                                                                                            ? "333 000 000 F"
                                                                                                                                                                            : MyFunctions.vertical(vBar) == 38000000
                                                                                                                                                                                ? "342 000 000 F"
                                                                                                                                                                                : MyFunctions.vertical(vBar) == 39000000
                                                                                                                                                                                    ? "351 000 000 F"
                                                                                                                                                                                    : MyFunctions.vertical(vBar) == 40000000
                                                                                                                                                                                        ? "360 000 000 F"
                                                                                                                                                                                        : MyFunctions.vertical(vBar) == 41000000
                                                                                                                                                                                            ? "369 000 000 F"
                                                                                                                                                                                            : MyFunctions.vertical(vBar) == 42000000
                                                                                                                                                                                                ? "378 000 000 F"
                                                                                                                                                                                                : MyFunctions.vertical(vBar) == 43000000
                                                                                                                                                                                                    ? "387 000 000 F"
                                                                                                                                                                                                    : MyFunctions.vertical(vBar) == 44000000
                                                                                                                                                                                                        ? "396 000 000 F"
                                                                                                                                                                                                        : MyFunctions.vertical(vBar) == 45000000
                                                                                                                                                                                                            ? "405 000 000 F"
                                                                                                                                                                                                            : MyFunctions.vertical(vBar) == 46000000
                                                                                                                                                                                                                ? "414 000 000 F"
                                                                                                                                                                                                                : "423 000 000 F";
      case 11:
        return MyFunctions.vertical(vBar) == 1000
            ? '11 000 F'
            : MyFunctions.vertical(vBar) == 5000
                ? '55 000 F'
                : MyFunctions.vertical(vBar) == 10000
                    ? '110 000 F'
                    : MyFunctions.vertical(vBar) == 100000
                        ? '1 100 000 F'
                        : MyFunctions.vertical(vBar) == 1000000
                            ? '11 000 000 F'
                            : MyFunctions.vertical(vBar) == 2000000
                                ? '22 000 000 F'
                                : MyFunctions.vertical(vBar) == 3000000
                                    ? '33 000 000 F'
                                    : MyFunctions.vertical(vBar) == 4000000
                                        ? '44 000 000 F'
                                        : MyFunctions.vertical(vBar) == 5000000
                                            ? '55 000 000 F'
                                            : MyFunctions.vertical(vBar) ==
                                                    6000000
                                                ? '66 000 000 F'
                                                : MyFunctions.vertical(vBar) ==
                                                        7000000
                                                    ? '77 000 000 F'
                                                    : MyFunctions.vertical(
                                                                vBar) ==
                                                            8000000
                                                        ? '88 000 000 F'
                                                        : MyFunctions.vertical(
                                                                    vBar) ==
                                                                9000000
                                                            ? '99 000 000 F'
                                                            : MyFunctions.vertical(
                                                                        vBar) ==
                                                                    10000000
                                                                ? '110 000 000 F'
                                                                : MyFunctions.vertical(
                                                                            vBar) ==
                                                                        11000000
                                                                    ? '121 000 000 F'
                                                                    : MyFunctions.vertical(vBar) ==
                                                                            12000000
                                                                        ? '132 000 000 F'
                                                                        : MyFunctions.vertical(vBar) ==
                                                                                13000000
                                                                            ? '143 000 000 F'
                                                                            : MyFunctions.vertical(vBar) == 14000000
                                                                                ? '154 000 000 F'
                                                                                : MyFunctions.vertical(vBar) == 15000000
                                                                                    ? '165 000 000 F'
                                                                                    : MyFunctions.vertical(vBar) == 16000000
                                                                                        ? '176 000 000 F'
                                                                                        : MyFunctions.vertical(vBar) == 17000000
                                                                                            ? "187 000 000 F"
                                                                                            : MyFunctions.vertical(vBar) == 18000000
                                                                                                ? "198 000 000 F"
                                                                                                : MyFunctions.vertical(vBar) == 19000000
                                                                                                    ? "209 000 000 F"
                                                                                                    : MyFunctions.vertical(vBar) == 20000000
                                                                                                        ? "220 000 000 F"
                                                                                                        : MyFunctions.vertical(vBar) == 21000000
                                                                                                            ? "231 000 000 F"
                                                                                                            : MyFunctions.vertical(vBar) == 22000000
                                                                                                                ? "242 000 000 F"
                                                                                                                : MyFunctions.vertical(vBar) == 23000000
                                                                                                                    ? "253 000 000 F"
                                                                                                                    : MyFunctions.vertical(vBar) == 24000000
                                                                                                                        ? "264 000 000 F"
                                                                                                                        : MyFunctions.vertical(vBar) == 25000000
                                                                                                                            ? "275 000 000 F"
                                                                                                                            : MyFunctions.vertical(vBar) == 26000000
                                                                                                                                ? "286 000 000 F"
                                                                                                                                : MyFunctions.vertical(vBar) == 27000000
                                                                                                                                    ? "297 000 000 F"
                                                                                                                                    : MyFunctions.vertical(vBar) == 28000000
                                                                                                                                        ? "308 000 000 F"
                                                                                                                                        : MyFunctions.vertical(vBar) == 29000000
                                                                                                                                            ? "319 000 000 F"
                                                                                                                                            : MyFunctions.vertical(vBar) == 30000000
                                                                                                                                                ? "330 000 000 F"
                                                                                                                                                : MyFunctions.vertical(vBar) == 31000000
                                                                                                                                                    ? '341 000 000 F'
                                                                                                                                                    : MyFunctions.vertical(vBar) == 32000000
                                                                                                                                                        ? "352 000 000 F"
                                                                                                                                                        : MyFunctions.vertical(vBar) == 33000000
                                                                                                                                                            ? "363 000 000 F"
                                                                                                                                                            : MyFunctions.vertical(vBar) == 34000000
                                                                                                                                                                ? "374 000 000 F"
                                                                                                                                                                : MyFunctions.vertical(vBar) == 35000000
                                                                                                                                                                    ? "385 000 000 F"
                                                                                                                                                                    : MyFunctions.vertical(vBar) == 36000000
                                                                                                                                                                        ? "396 000 000 F"
                                                                                                                                                                        : MyFunctions.vertical(vBar) == 38000000
                                                                                                                                                                            ? "407 000 000 F"
                                                                                                                                                                            : MyFunctions.vertical(vBar) == 39000000
                                                                                                                                                                                ? "418 000 000 F"
                                                                                                                                                                                : MyFunctions.vertical(vBar) == 40000000
                                                                                                                                                                                    ? "440 000 000 F"
                                                                                                                                                                                    : MyFunctions.vertical(vBar) == 41000000
                                                                                                                                                                                        ? "451 000 000 F"
                                                                                                                                                                                        : MyFunctions.vertical(vBar) == 42000000
                                                                                                                                                                                            ? "462 000 000 F"
                                                                                                                                                                                            : MyFunctions.vertical(vBar) == 43000000
                                                                                                                                                                                                ? "473 000 000 F"
                                                                                                                                                                                                : MyFunctions.vertical(vBar) == 44000000
                                                                                                                                                                                                    ? "484 000 000 F"
                                                                                                                                                                                                    : MyFunctions.vertical(vBar) == 45000000
                                                                                                                                                                                                        ? "495 000 000 F"
                                                                                                                                                                                                        : MyFunctions.vertical(vBar) == 46000000
                                                                                                                                                                                                            ? "506 000 000 F"
                                                                                                                                                                                                            : "517 000 000 F";
      default:
        return '';
    }
  }

  // vertical bar
  static int vertical(List<int> verData) {
    int maxElem = verData.isEmpty ? 0 : verData.reduce(max);
    int diviser = 0;
    if (0 <= maxElem && maxElem < 12001) {
      diviser = 1000;
    } else if (12001 <= maxElem && maxElem < 60001) {
      diviser = 5000;
    } else if (60001 <= maxElem && maxElem < 120001) {
      diviser = 10000;
    } else if (120001 <= maxElem && maxElem < 1200001) {
      diviser = 100000;
    } else if (1200001 <= maxElem && maxElem < 12000001) {
      diviser = 1000000;
    } else if (12000001 <= maxElem && maxElem < 24000001) {
      diviser = 2000000;
    } else if (24000001 <= maxElem && maxElem < 36000001) {
      diviser = 3000000;
    } else if (36000001 <= maxElem && maxElem < 48000001) {
      diviser = 4000000;
    } else if (48000001 <= maxElem && maxElem < 60000001) {
      diviser = 5000000;
    } else if (60000001 <= maxElem && maxElem < 72000001) {
      diviser = 6000000;
    } else if (72000001 <= maxElem && maxElem < 84000001) {
      diviser = 7000000;
    } else if (84000001 <= maxElem && maxElem < 96000001) {
      diviser = 8000000;
    } else if (96000001 <= maxElem && maxElem < 108000001) {
      diviser = 9000000;
    } else if (108000001 <= maxElem && maxElem < 120000001) {
      diviser = 10000000;
    } else if (120000001 <= maxElem && maxElem < 132000001) {
      diviser = 11000000;
    } else if (132000001 <= maxElem && maxElem < 144000001) {
      diviser = 12000000;
    } else if (144000001 <= maxElem && maxElem < 156000001) {
      diviser = 13000000;
    } else if (156000001 <= maxElem && maxElem < 168000001) {
      diviser = 14000000;
    } else if (168000001 <= maxElem && maxElem < 180000001) {
      diviser = 15000000;
    } else if (180000001 <= maxElem && maxElem < 192000001) {
      diviser = 16000000;
    } else if (192000001 <= maxElem && maxElem < 204000001) {
      diviser = 17000000;
    } else if (204000001 <= maxElem && maxElem < 216000001) {
      diviser = 18000000;
    } else if (216000001 <= maxElem && maxElem < 228000001) {
      diviser = 19000000;
    } else if (228000001 <= maxElem && maxElem < 240000001) {
      diviser = 20000000;
    } else if (240000001 <= maxElem && maxElem < 252000001) {
      diviser = 21000000;
    } else if (252000001 <= maxElem && maxElem < 264000001) {
      diviser = 22000000;
    } else if (264000001 <= maxElem && maxElem < 276000001) {
      diviser = 23000000;
    } else if (276000001 <= maxElem && maxElem < 288000001) {
      diviser = 24000000;
    } else if (288000001 <= maxElem && maxElem < 290000001) {
      diviser = 25000000;
    } else if (290000001 <= maxElem && maxElem < 302000001) {
      diviser = 26000000;
    } else if (302000001 <= maxElem && maxElem < 314000001) {
      diviser = 27000000;
    } else if (314000001 <= maxElem && maxElem < 326000001) {
      diviser = 28000000;
    } else if (326000001 <= maxElem && maxElem < 338000001) {
      diviser = 29000000;
    } else if (338000001 <= maxElem && maxElem < 340000001) {
      diviser = 30000000;
    } else if (340000001 <= maxElem && maxElem < 352000001) {
      diviser = 31000000;
    } else if (352000001 <= maxElem && maxElem < 364000001) {
      diviser = 32000000;
    } else if (364000001 <= maxElem && maxElem < 380000001) {
      diviser = 33000000;
    } else if (380000001 <= maxElem && maxElem < 392000001) {
      diviser = 34000000;
    } else if (392000001 <= maxElem && maxElem < 404000001) {
      diviser = 35000000;
    } else if (404000001 <= maxElem && maxElem < 416000001) {
      diviser = 36000000;
    } else if (416000001 <= maxElem && maxElem < 428000001) {
      diviser = 37000000;
    } else if (428000001 <= maxElem && maxElem < 430000001) {
      diviser = 38000000;
    } else if (430000001 <= maxElem && maxElem < 442000001) {
      diviser = 39000000;
    } else if (442000001 <= maxElem && maxElem < 454000001) {
      diviser = 40000000;
    } else if (454000001 <= maxElem && maxElem < 466000001) {
      diviser = 42000000;
    } else if (466000001 <= maxElem && maxElem < 478000001) {
      diviser = 43000000;
    } else if (478000001 <= maxElem && maxElem < 490000001) {
      diviser = 44000000;
    } else if (490000001 <= maxElem && maxElem < 502000001) {
      diviser = 45000000;
    } else if (502000001 <= maxElem && maxElem < 514000001) {
      diviser = 46000000;
    }
    return diviser;
  }

  static setUser({required User user, required BuildContext context}) {
    StoreProvider.of<AppState>(context).dispatch(
      UserRedux(user: user),
    );
  }

// set company data
  static setCompany(
      {required CompanyModel company, required BuildContext context}) {
    StoreProvider.of<AppState>(context)
        .dispatch(CompanyRedux(company: company));
  }

// redirect routes
  static redirect({required BuildContext context, required String page}) {
    Navigator.pushNamed(context, page);
  }

// set dashboard actions
  static setSideBareAction(
      {required String droit, required BuildContext context}) {
    StoreProvider.of<AppState>(context).dispatch(
      SideBarAction(
        sidebarElements: droit.toUpperCase() == "ADMIN"
            ? const {
                'home': true,
                'produit': false,
                'stock': false,
                'fournisseur': false,
                'client': false,
                'achat': false,
                'emploie': false,
                'vente': false,
                'bon_de_sortie': false,
                'inventaire': false,
                'comptabilite': false,
                'parametre': false,
                'produit_use': false,
              }
            : droit.toUpperCase() == "SECRET1"
                ? const {
                    'home': false,
                    'produit': false,
                    'stock': false,
                    'fournisseur': false,
                    'client': false,
                    'achat': false,
                    'emploie': false,
                    'vente': false,
                    'bon_de_sortie': false,
                    'inventaire': false,
                    'comptabilite': true,
                    'parametre': false,
                    'produit_use': false,
                  }
                : droit.toUpperCase() == "MAGASIN"
                    ? const {
                        'home': false,
                        'produit': false,
                        'stock': false,
                        'fournisseur': false,
                        'client': false,
                        'achat': false,
                        'emploie': false,
                        'vente': true,
                        'bon_de_sortie': false,
                        'inventaire': false,
                        'comptabilite': false,
                        'parametre': false,
                        'produit_use': false,
                      }
                    : const {
                        'home': false,
                        'produit': false,
                        'stock': false,
                        'fournisseur': false,
                        'client': false,
                        'achat': false,
                        'emploie': false,
                        'vente': true,
                        'bon_de_sortie': false,
                        'inventaire': false,
                        'comptabilite': false,
                        'parametre': false,
                        'produit_use': false,
                      },
      ),
    );
  }

  // addDelimiter used to format any number
  static String addDelimiter(String val) {
    // let's initialize the compteur
    int cpt = 1;
    // let's convert the value to a list of numbers by taking account the double values
    List vals = val.split(".")[0].split("");
    String mainVal = "";
    String myString = "";

    while (cpt <= vals.length) {
      myString = vals[vals.length - cpt] + myString;
      if ((vals.length - cpt + myString.length) <= 3) {
        if ((vals.length - cpt) == 0) {
          mainVal += " $myString";
        }
      } else {
        if (myString.length >= 3) {
          mainVal += " $myString";
          myString = "";
        }
      }
      cpt++;
    }
    return val.split(".").length > 1
        ? "${mainVal.split(" ").reversed.toList().join(" ")}.${val.split(".")[1]}"
        : mainVal.split(" ").reversed.toList().join(" ");
  }

  // inputDelimiter used to format number textFields when typing
  static inputDelimitter(String val) {
    List formatVal = val.split(" ");
    String newVal = "";
    if (formatVal[0].length >= 4) {
      if (formatVal[0].length == 4) {
        newVal += formatVal[0].split("")[0] +
            " " +
            formatVal[0].split("")[1] +
            formatVal[0].split("")[2] +
            formatVal[0].split("")[3];
      }
    } else {
      newVal = formatVal[0];
    }
    formatVal.removeAt(0);
    return "$newVal ${formatVal.join(" ")}";
  }

  // function to find the max number from a list of map
  static Map<String, int> getMaxValue(List<List<Map<int, int>>> data) {
    int maxVal = data[0].map((e) => e.values.first).toList().reduce(max);
    int maxX = data[0].length;
    for (List<Map<int, int>> element in data) {
      if (element.map((e) => e.values.first).toList().reduce(max) > maxVal) {
        maxVal = element.map((e) => e.values.first).toList().reduce(max);
      }
      if (element.length > maxX) {
        maxX = element.length;
      }
    }
    return {'maxval': maxVal, "maxX": maxX};
  }

  static List<Color> pieColors = const [
    Colors.red,
    Colors.green,
    Color.fromARGB(255, 16, 150, 207),
    Color.fromARGB(255, 160, 98, 5),
    Color.fromARGB(255, 16, 150, 207),
    Colors.pink,
    Color.fromARGB(255, 108, 17, 124),
    Color.fromARGB(255, 55, 4, 94),
    Color.fromARGB(255, 139, 42, 15),
    Color.fromARGB(255, 7, 91, 108),
    Color.fromARGB(255, 104, 8, 61),
    Color.fromARGB(255, 6, 65, 112),
    Colors.red,
    Colors.green,
    Color.fromARGB(255, 16, 150, 207),
    Colors.pink,
    Color.fromARGB(255, 160, 98, 5),
    Color.fromARGB(255, 108, 17, 124),
    Color.fromARGB(255, 9, 84, 32),
    Color.fromARGB(255, 55, 4, 94),
    Color.fromARGB(255, 139, 42, 15),
    Color.fromARGB(255, 7, 91, 108),
    Color.fromARGB(255, 104, 8, 61),
    Color.fromARGB(255, 43, 86, 4),
    Color.fromARGB(255, 164, 8, 65),
    Color.fromARGB(255, 13, 149, 140),
    Color.fromARGB(255, 9, 90, 44),
    Color.fromARGB(255, 6, 65, 112),
    Colors.red,
    Colors.green,
    Color.fromARGB(255, 16, 150, 207),
    Colors.pink,
    Color.fromARGB(255, 160, 98, 5),
    Color.fromARGB(255, 108, 17, 124),
    Color.fromARGB(255, 139, 42, 15),
    Color.fromARGB(255, 7, 91, 108),
    Color.fromARGB(255, 104, 8, 61),
    Color.fromARGB(255, 43, 86, 4),
    Color.fromARGB(255, 164, 8, 65),
    Color.fromARGB(255, 13, 149, 140),
    Color.fromARGB(255, 160, 98, 5),
    Color.fromARGB(255, 108, 17, 124),
    Color.fromARGB(255, 139, 42, 15),
    Color.fromARGB(255, 7, 91, 108),
  ];

  static Map<String, int> viewPort = {
    "colXS": 12,
    "colS": 6,
    "colM": 4,
    "colL": 4,
    "colXL": 2,
  };

  // methode to get the device screen size
  static Map<String, double> deviceSize(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    double deviceHeight = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;

    return {"w": deviceWidth, "h": deviceHeight};
  }
}

loader(var context) {
  Loader.show(
    context,
    isSafeAreaOverlay: true,
    isBottomBarOverlay: true,
    progressIndicator: const CircularProgressIndicator(),
  );
}

List<double> getDeviceWidht(BuildContext context) {
  double deviceWidth = MediaQuery.of(context).size.width *
      MediaQuery.of(context).devicePixelRatio;
  double deviceHeight = MediaQuery.of(context).size.height *
      MediaQuery.of(context).devicePixelRatio;
  return [deviceWidth, deviceHeight];
}
