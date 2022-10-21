import 'package:application_principal/database/company_model.dart';
import 'package:application_principal/database/user.dart';
import 'package:application_principal/theme/full_themes.dart';

class AppState {
  User? user;
  CompanyModel? company;
  bool? isClosed;
  FullThemes? fullThemes;
  Map<String, dynamic>? sideBarElements;
  AppState(
      {required this.user,
      required this.company,
      required this.isClosed,
      required this.fullThemes,
      this.sideBarElements = const {
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
        'comptabilite': false,
        'parametre': false,
        'produit_use': false,
      }});

  AppState.fromAppState(AppState another) {
    user = another.user;
    company = another.company;
    sideBarElements = another.sideBarElements;
    isClosed = another.isClosed;
    fullThemes = another.fullThemes;
  }
}
