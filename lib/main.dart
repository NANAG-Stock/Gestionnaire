// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:application_principal/Blocks/function.dart';
import 'package:application_principal/Screens/entreprise/dashboard.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/redux/redux_functions.dart';
import 'package:application_principal/Screens/bon_de_sortie.dart';
import 'package:application_principal/Screens/caisier/caiss_bon_de_sortie.dart';
import 'package:application_principal/Screens/caisier/caisscomptabilite.dart';
import 'package:application_principal/Screens/caisier/caiss_ventes.dart';
import 'package:application_principal/Screens/client.dart';
import 'package:application_principal/Screens/commande.dart';
import 'package:application_principal/Screens/comptabilite.dart';
import 'package:application_principal/Screens/compte.dart';
import 'package:application_principal/Screens/connection.dart';
import 'package:application_principal/Screens/employee.dart';
import 'package:application_principal/Screens/fournisseur.dart';
import 'package:application_principal/Screens/home.dart';
import 'package:application_principal/Screens/inventaire.dart';
import 'package:application_principal/Screens/magasin/maga_commande.dart';
import 'package:application_principal/Screens/magasin/maga_fournisseur.dart';
import 'package:application_principal/Screens/magasin/maga_produits.dart';
import 'package:application_principal/Screens/magasin/maga_stock.dart';
import 'package:application_principal/Screens/magasin/maga_ventes.dart';
import 'package:application_principal/Screens/produit_usee.dart';
import 'package:application_principal/Screens/produits.dart';
import 'package:application_principal/Screens/secret1/secre1_client.dart';
import 'package:application_principal/Screens/secret1/secre1_commande.dart';
import 'package:application_principal/Screens/secret1/secre1_fournisseur.dart';
import 'package:application_principal/Screens/secret1/secre1_produits.dart';
import 'package:application_principal/Screens/secret1/secre1_stock.dart';
import 'package:application_principal/Screens/secret1/secre1_ventes.dart';
import 'package:application_principal/Screens/secret1/secret1_comptabilite.dart';
import 'package:application_principal/Screens/secret2/secre2_comptabilite.dart';
import 'package:application_principal/Screens/secret2/secre2_stock.dart';
import 'package:application_principal/Screens/secret2/secre2_ventes.dart';
import 'package:application_principal/Screens/secret2/secret2_bon_de_sortie.dart';
import 'package:application_principal/Screens/stock.dart';
import 'package:application_principal/Screens/ventes.dart';
import 'package:application_principal/theme/full_themes.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:window_manager/window_manager.dart';
import 'Screens/secret2/secre2_client.dart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();
  // windowManager.waitUntilReadyToShow().then((value) async {
  //   await windowManager.maximize();
  //   await windowManager.setTitle('G-Stock');
  //   windowManager.show();
  // });
  doWhenWindowReady(() {
    final win = appWindow;
    // const initialSize = Size(900, 650);
    // win.minSize = initialSize;
    win.minSize = Size(768, 1024);
    win.alignment = Alignment.center;
    win.title = "G-Stock";
    win.maximize();
    win.show();
  });
  final initialState = AppState(
    user: null,
    isClosed: false,
    company: null,
    fullThemes: FullThemes(
      contentThemes: MyFunctions.setContentTheme(name: "dark"),
      sideBarTheme: MyFunctions.setSideBarTheme(name: "dark"),
      topBarTheme: MyFunctions.setTopBarTheme(name: "dark"),
    ),
  );
  final Store<AppState> store =
      Store<AppState>(reducer, initialState: initialState);
  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'produit_use',
        routes: {
          'produits': (context) => Produits(),
          'home': (context) => Home(),
          'login': (context) => Connection(),
          'fournisseur': (context) => Fournisseur(),
          'client': (context) => Client(),
          'vente': (context) => Ventes(),
          'achat': (context) => Commande(),
          'stock': (context) => Stock(),
          'employee': (context) => Employees(),
          'comptabilite': (context) => Comptabilite(),
          'inventaire': (context) => Inventaire(),
          'bon': (context) => BonDeSortie(),
          'compte': (context) => Compte(),
          'produit_use': (context) => ProduitsUse(),
          'dash': (context) => Dashboad(),
          // secretatire 1
          'Secre1client': (context) => Secret1Client(),
          'Secre1vente': (context) => Secret1Ventes(),
          'Secre1comptabilite': (context) => Secret1Comptabilite(),
          // 'Secre1bon': (context) => Secret1BonDeSortie(),
          'Secre1prod': (context) => Secret1Produits(),
          'Secre1stock': (context) => Secret1Stock(),
          'Secre1four': (context) => Secret1Fournisseur(),
          'Secre1com': (context) => Secret1Commande(),
          // secretatire 2
          'Secre2client': (context) => Secret2Client(),
          'Secre2vente': (context) => Secret2Ventes(),
          'Secre2comptabilite': (context) => Secret2Comptabilite(),
          'Secre2bon': (context) => Secret2BonDeSortie(),
          // 'Secre2prod': (context) => Secret2Produits(),
          'Secre2stock': (context) => Secret2Stock(),
          // 'Secre2four': (context) => Secret2Fournisseur(),
          // 'Secre2com': (context) => Secret2Commande(),
          // secretatire 3
          // Caissiere
          'Caisse_vente': (context) => CaisseVentes(),
          'Caisse_comptabilite': (context) => CaisseComptabilite(),
          'Casse_bon_de_sortie': (context) => CaisseBonDeSortie(),
          // Magasin
          'maga_produits': (context) => MagaProduits(),
          'maga_fournisseur': (context) => MagaFournisseur(),
          'maga_vente': (context) => MagaVentes(),
          'maga_achat': (context) => MagaCommande(),
          'maga_stock': (context) => MAgaStock(),
        },
      ),
    );
  }
}
