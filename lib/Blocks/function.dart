import 'dart:math';

import 'package:application_principal/database/company_model.dart';
import 'package:application_principal/database/themes.dart';
import 'package:application_principal/database/user.dart';
import 'package:application_principal/redux/actions.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/theme/content_theme.dart';
import 'package:application_principal/theme/side_bar_theme.dart';
import 'package:application_principal/theme/top_bar_theme.dart';
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

  // set Theme data
  static ContentThemes setContentTheme({required String name}) {
    Map<String, dynamic> themeData = {
      'dark': ContentThemes(
        bgColor: const Color(0xFF333333),
        sideBarColor: const Color(0xFF08021A),
        topBarColor: const Color(0xFF333333),
        primaryColor: const Color(0xFFFFFFFF),
        secondaryColor: const Color(0xFFFFFFFF).withOpacity(0.6),
        btnPrimaryColor: const Color(0xFF333333),
        btnSecondaryColor: const Color(0xFF333333),
      ),
      'light': ContentThemes(
        bgColor: const Color(0xFF333333),
        sideBarColor: const Color(0xFF08021A),
        topBarColor: const Color(0xFF333333),
        primaryColor: const Color(0xFFFFFFFF),
        secondaryColor: const Color(0xFFFFFFFF).withOpacity(0.6),
        btnPrimaryColor: const Color(0xFF333333),
        btnSecondaryColor: const Color(0xFF333333),
      )
    };

    return themeData[name];
  }

  // set setSideBarTheme data
  static SideBarTheme setSideBarTheme({required String name}) {
    Map<String, dynamic> sideThemeData = {
      'dark': SideBarTheme(
        bgColor: const Color(0xFF08021A),
        primaryColor: const Color(0xFFFFFFFF),
        secondaryColor: const Color(0xFFFFFFFF).withOpacity(0.6),
        alertColor: Colors.red,
        foccusColor: Colors.amber.withOpacity(0.7),
        highlihtColor: Colors.amber.withOpacity(0.7),
      )
    };

    return sideThemeData[name];
  }

  // set setTopBarTheme data
  static TopBarTheme setTopBarTheme({required String name}) {
    Map<String, dynamic> themeData = {
      'dark': TopBarTheme(
        bgColor: const Color(0xFF08021A),
        primaryColor: const Color(0xFFFFFFFF),
        secondaryColor: const Color(0xFFFFFFFF).withOpacity(0.6),
        alertColor: Colors.red,
        foccusColor: Colors.amber.withOpacity(0.7),
        highlihtColor: Colors.amber.withOpacity(0.7),
      )
    };

    return themeData[name];
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
