// ignore_for_file: constant_identifier_names, prefer_collection_literals, avoid_print, unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/database/CommandeModel.dart';
import 'package:application_principal/database/annex_bout_model.dart';
import 'package:application_principal/database/bon_info_model.dart';
import 'package:application_principal/database/bon_sortie_model.dart';
import 'package:application_principal/database/categorieModel.dart';
import 'package:application_principal/database/clientModel.dart';
import 'package:application_principal/database/comInfos.dart';
import 'package:application_principal/database/commande_details_model.dart';
import 'package:application_principal/database/company_model.dart';
import 'package:application_principal/database/compte_versement_model.dart';
import 'package:application_principal/database/contenu_bon.dart';
import 'package:application_principal/database/credit_model.dart';
import 'package:application_principal/database/depense_model.dart';
import 'package:application_principal/database/employee_model.dart';
import 'package:application_principal/database/fourPay.dart';
import 'package:application_principal/database/fournisseurModel.dart';
import 'package:application_principal/database/fournisseur_prod.dart';
import 'package:application_principal/database/inventaire_model.dart';
import 'package:application_principal/database/list_pay_com_num.dart';
import 'package:application_principal/database/user.dart';
import 'package:application_principal/database/payment_liste_model.dart';
import 'package:application_principal/database/prod_Line_chart_model.dart';
import 'package:application_principal/database/product.dart';
import 'package:application_principal/database/produit_use_model.dart';
import 'package:application_principal/database/remboursement_model.dart';
import 'package:application_principal/database/retrait_model.dart';
import 'package:application_principal/database/salaireModel.dart';
import 'package:application_principal/database/track_cpt_achat.dart';
import 'package:application_principal/database/venteInfos.dart';
import 'package:application_principal/database/venteModel.dart';
import 'package:application_principal/database/versement_model.dart';
import 'package:application_principal/database/virement_model.dart';
import 'package:http/http.dart' as http;

class Services {
  // L'adresse pour les tests node js
  // static const ROOT = 'http://192.168.63.27:3000';
  static const ROOT = 'http://192.168.1.72:3000';
  // L'adresse pour les tests locaux
  // static const ROOT =
  //     'http://127.0.0.1/Desktop-GStock/gestion_quinca/server/bd.php';
  // L'adresse pour les tests en ligne
  // static const ROOT =
  // 'https://quincaillerie-bf.com/remote/quinca_back_test.php';
  //  L'adresse pour la production
  // static const ROOT = 'https://quincaillerie-bf.com/remote/quinca_back2.php';

  // ======================================================================//
  // =======                                                        =======//
  // =======          Tous les services liee aux utilisateurs       =======//
  // =======                                                        =======//
  // ======================================================================//

  // Connection des utilisateur
  static Future connection(
      String username, String password, String route) async {
    var map = Map<String, dynamic>();
    map['username'] = username;
    map['password'] = password;
    try {
      final response = await http.post(Uri.parse(ROOT + route), body: map);
      print(response.body);
      // print(response.headers);

      if (200 == response.statusCode) {
        return {'status': 200, 'data': connectionResponse(response.body)};
      } else if (404 == response.statusCode) {
        return {'status': 404, 'message': "Username ou mot de passe incorrect"};
      } else if (403 == response.statusCode) {
        return {'status': 403, 'message': "Accès refusé"};
      } else if (500 == response.statusCode) {
        return {'status': 500, 'message': "Erreur du serveur"};
      } else {
        return {'status': 400, 'message': "mauvaise requète"};
      }
    } catch (e) {
      print(e);
      return {'status': 500, 'message': "Erreur de connexion"};
    }
  }

  static User connectionResponse(String responseBody) {
    final parsed = json.decode(responseBody);
    return User.fromJson(parsed);
  }

// Fin connexion

// Creation de compte pour employee
  static Future<String> addEmp(
    String nom,
    String cnib,
    String tel,
    String salaire,
    String droit,
    String sexe,
  ) async {
    var map = Map<String, dynamic>();
    map['nom'] = nom;
    map['cnib'] = cnib;
    map['tel'] = tel;
    map['salaire'] = salaire;
    map['droit'] = droit;
    map['sexe'] = sexe;
    map['table_name'] = 'user';
    map['action'] = 'ajoutEmp';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      print(e);
      return '-2';
    }
  }

// Modifier un employee
  static Future<String> updEmp(
    String nom,
    String cnib,
    String tel,
    String salaire,
    String droit,
    String sexe,
    String idEmp,
  ) async {
    var map = Map<String, dynamic>();
    map['nom'] = nom;
    map['cnib'] = cnib;
    map['tel'] = tel;
    map['salaire'] = salaire;
    map['droit'] = droit;
    map['idEmp'] = idEmp;
    map['sexe'] = sexe;
    map['table_name'] = 'user';
    map['action'] = 'updEmp';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      print(e);
      return '-2';
    }
  }

  // Modifier le nom d'utilisateur
  static Future<String> updUserName(
    String id,
    String username,
  ) async {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['username'] = username;
    map['table_name'] = 'user';
    map['action'] = 'updUserName';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      print(e);
      return '-2';
    }
  }

  // Modifier le nom d'utilisateur
  static Future<String> addCode(
    String id,
    String code,
  ) async {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['code'] = code;
    map['table_name'] = 'user';
    map['action'] = 'addCode';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      print(e);
      return '-2';
    }
  }

  // Modifier le mot de passe
  static Future<String> updPassword(
    String id,
    String oldPass,
    String newPass,
  ) async {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['oldPass'] = oldPass;
    map['newPass'] = newPass;
    map['table_name'] = 'user';
    map['action'] = 'updPassword';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      print(e);
      return '-2';
    }
  }

  // suppression d'employee
  static Future<String> delEmp(String idEmp) async {
    var map = Map<String, dynamic>();
    map['idEmp'] = idEmp;
    map['table_name'] = 'user';
    map['action'] = 'delUser';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

  //recuperation de liste des employee
  static Future<List<EmployeeModel>> getEmployees(
      String type, String id) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'user';
    map['id'] = id;
    map['type'] = type;
    map['action'] = 'getEmp';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<EmployeeModel> listProduct = empResponse(response.body);
        return listProduct;
      } else {
        List<EmployeeModel> badeStatusProd = [
          EmployeeModel(
            nomEmp: '-1',
            cnibEmp: '-1',
            telEmp: '-1',
            motdepassEmp: '-1',
            droitEmp: '-1',
            idEmp: '-1',
            codeEmp: '-1',
            statutEmp: '-1',
            salaireEmp: '-1',
            sexe: '-1',
            dateUser: '-1',
            username: '',
          )
        ];
        return badeStatusProd;
      }
    } catch (e) {
      List<EmployeeModel> expceptionProd = [
        EmployeeModel(
            nomEmp: '-2',
            cnibEmp: '-2',
            telEmp: '-2',
            motdepassEmp: '-2',
            droitEmp: '-2',
            idEmp: '-2',
            codeEmp: '-2',
            statutEmp: '-2',
            salaireEmp: '-2',
            sexe: '-2',
            dateUser: '-2',
            username: '')
      ];
      // throw Exception(e.toString());
      return expceptionProd;
    }
  }

  static List<EmployeeModel> empResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<EmployeeModel>((json) => EmployeeModel.fromJson(json))
        .toList();
  }

  // ======================================================================//
  // =======                                                        =======//
  // =======      Tous les services liee a la table salaire         =======//
  // =======                                                        =======//
  // ======================================================================//

  // Ajout d'un salaire
  static Future<String> addSalaire(String saVal, String user) async {
    var map = Map<String, dynamic>();
    map['saVal'] = saVal;
    map['user'] = user;
    map['table_name'] = 'salaire';
    map['action'] = 'ajoutSa';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

  // Recuperation des salaires
  static Future<List<SalaireModel>> getSalaire() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'salaire';
    map['action'] = 'getSa';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        List<SalaireModel> catListe = saResponse(response.body);
        return catListe;
      } else {
        List<SalaireModel> vide = [
          SalaireModel(
              saId: '-1',
              saVal: '-1',
              saUser: '-1',
              del_sa: '-1',
              date_sa: '-1')
        ];
        return vide;
      }
    } catch (e) {
      List<SalaireModel> videExcept = [
        SalaireModel(
            saId: '-2', saVal: '-2', saUser: '-2', del_sa: '-2', date_sa: '-2')
      ];
      return videExcept;
    }
  }

  static List<SalaireModel> saResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<SalaireModel>((json) => SalaireModel.fromJson(json))
        .toList();
  }

  // Modifier un salaire
  static Future<String> updSalaire(String saVal, String saId) async {
    var map = Map<String, dynamic>();
    map['saVal'] = saVal;
    map['saId'] = saId;
    map['table_name'] = 'salaire';
    map['action'] = 'updSa';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

  // suppression d'un salaire
  static Future<String> delSa(String idSa) async {
    var map = Map<String, dynamic>();
    map['idSa'] = idSa;
    map['table_name'] = 'salaire';
    map['action'] = 'deleteSa';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

  // ======================================================================//
  // =======                                                        =======//
  // =======      Tous les services liee a la table produits        =======//
  // =======                                                        =======//
  // ======================================================================//

// Ajout d'un produits
  static Future<String> addProd(
    String designation,
    String categorie,
    String description,
    String prix,
    String promo,
    String user,
  ) async {
    var map = Map<String, dynamic>();
    map['designation'] = designation;
    map['categorie'] = categorie;
    map['description'] = description;
    map['prix'] = prix;
    map['promo'] = promo;
    map['user'] = user;
    map['table_name'] = 'produits';
    map['action'] = 'ajoutProd';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      print(e);
      return '-2';
    }
  }

  // Recuperation de la liste des produits
  static Future getProdList() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'produits';
    map['action'] = 'getProd';

    try {
      final response = await http.get(Uri.parse('$ROOT/produits'));
      // print(response.body);
      if (200 == response.statusCode) {
        return {"status": 200, 'data': productResponse(response.body)};
      } else if (404 == response.statusCode) {
        return {"status": 404, "message": jsonDecode(response.body)['message']};
      } else if (403 == response.statusCode) {
        return {"status": 403, "message": jsonDecode(response.body)['message']};
      } else if (400 == response.statusCode) {
        return {"status": 400, "message": jsonDecode(response.body)['message']};
      } else if (500 == response.statusCode) {
        return {"status": 500, "message": jsonDecode(response.body)['message']};
      }
    } catch (e) {
      print(e);
      return {"status": 400, "message": "Erreur de connexion"};
    }
  }

  static List<Product> productResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  // Recuperation de la liste des produits 2
  static Future<List<Product>> getProdList2(String limit, String search) async {
    // print(limit);
    var map = Map<String, dynamic>();
    map['table_name'] = 'produits';
    map['limiteee'] = limit;
    map['searcheee'] = search;
    map['action'] = 'getProdList2';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<Product> listProduct = productResponse2(response.body);
        return listProduct;
      } else {
        List<Product> badeStatusProd = [
          Product(
            designation: '-1',
            description: '-1',
            prix: '-1',
            promo: '-1',
            id_cat: '-1',
            id_user: '-1',
            id_prod: response.body,
            prod_date: '-1',
            status: '-1',
            stock: '-1',
          )
        ];
        return badeStatusProd;
      }
    } catch (e) {
      List<Product> expceptionProd = [
        Product(
          designation: '-2',
          description: '-2',
          prix: '-2',
          promo: '-2',
          id_cat: '-2',
          id_user: '-2',
          id_prod: e.toString(),
          prod_date: '-2',
          status: '-2',
          stock: '-2',
        ),
      ];
      return expceptionProd;
    }
  }

  static List<Product> productResponse2(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  // Recuperation de la liste des produits des fournisseurs
  static Future<List<FournisseurProduct>> getFourProdList(
      String limit, String search) async {
    // print(limit);
    var map = Map<String, dynamic>();
    map['table_name'] = 'produits';
    map['limit'] = limit;
    map['search'] = search;
    map['action'] = 'getFourProdList';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<FournisseurProduct> listProduct =
            fourProductResponse(response.body);
        return listProduct;
      } else {
        List<FournisseurProduct> badeStatusProd = [
          FournisseurProduct(
              designation: '-1',
              prix: '-1',
              prod_date: '-1',
              categorie: '-1',
              fournisseur: '-1',
              quantite: '-1',
              type: '-1',
              tel_four: '-1',
              id_four: '-1')
        ];
        return badeStatusProd;
      }
    } catch (e) {
      print(e);
      List<FournisseurProduct> expceptionProd = [
        FournisseurProduct(
            designation: '-2',
            prix: '-2',
            prod_date: '-2',
            categorie: '-2',
            fournisseur: '-2',
            quantite: '-2',
            type: '-2',
            tel_four: '-2',
            id_four: '-2')
      ];
      return expceptionProd;
    }
  }

  static List<FournisseurProduct> fourProductResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<FournisseurProduct>((json) => FournisseurProduct.fromJson(json))
        .toList();
  }

  // Supprimer un produit
  static Future<String> delProd(String idProd) async {
    var map = Map<String, dynamic>();

    map['action'] = 'delProd';
    map['table_name'] = 'produits';
    map['id_prod'] = idProd;

    try {
      final proDelResponse = await http.post(Uri.parse(ROOT), body: map);
      if (200 == proDelResponse.statusCode) {
        return proDelResponse.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Supprimer un produit
  static Future<String> updStock(String idProd, String qts) async {
    var map = Map<String, dynamic>();

    map['action'] = 'updStock';
    map['table_name'] = 'stock';
    map['id_prod'] = idProd;
    map['qts'] = qts;

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      //  (response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Mettre un produit a jour
  static Future<String> updProd(
    String idProd,
    String designation,
    String categorie,
    String description,
    String prix,
    String promo,
  ) async {
    var map = Map<String, dynamic>();
    map['action'] = 'updProd';
    map['table_name'] = 'produits';
    map['id_prod'] = idProd;
    map['designation'] = designation;
    map['categorie'] = categorie;
    map['description'] = description;
    map['prix'] = prix;
    map['promo'] = promo;
    try {
      final proDelResponse = await http.post(Uri.parse(ROOT), body: map);
      if (200 == proDelResponse.statusCode) {
        return proDelResponse.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Fin services produits

  // ======================================================================//
  // =======                                                        =======//
  // =======      Tous les services liee a la table categorie       =======//
  // =======                                                        =======//
  // ======================================================================//

  // Ajout d'une categorie
  static Future<String> addCategorie(
    String catName,
    String user,
  ) async {
    var map = Map<String, dynamic>();
    map['cateName'] = catName;
    map['user'] = user;
    map['table_name'] = 'categorie';
    map['action'] = 'ajoutCat';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

  // Modifier une categorie
  static Future<String> updCategorie(String catName, String catId) async {
    var map = Map<String, dynamic>();
    map['cateName'] = catName;
    map['catId'] = catId;
    map['table_name'] = 'categorie';
    map['action'] = 'updCat';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

// Recuperation des categories

  static Future<List<CategorieModel>> getCategorie() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'categorie';
    map['action'] = 'getCat';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        List<CategorieModel> catListe = catResponse(response.body);
        return catListe;
      } else {
        List<CategorieModel> vide = [
          CategorieModel(
              catId: '-1',
              catName: '-1',
              catDate: '-1',
              cateDel: '-1',
              catUser: '-1')
        ];
        return vide;
      }
    } catch (e) {
      List<CategorieModel> videExcept = [
        CategorieModel(
            catId: '-2',
            catName: '-2',
            catDate: '-2',
            cateDel: '-2',
            catUser: '-2')
      ];
      return videExcept;
    }
  }

  static List<CategorieModel> catResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CategorieModel>((json) => CategorieModel.fromJson(json))
        .toList();
  }

  // suppression d'une categorie
  static Future<String> delCategorie(String idCat) async {
    var map = Map<String, dynamic>();
    map['idCat'] = idCat;
    map['table_name'] = 'categorie';
    map['action'] = 'deleteCat';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }
  // fin services categorie

  // ======================================================================//
  // =======                                                        =======//
  // =======      Tous les services liee a la table fournisseur     =======//
  // =======                                                        =======//
  // ======================================================================//

  // Ajouter un fournisseur
  static Future<String> addFour(
    String nom,
    String type,
    String pays,
    String ville,
    String adress,
    String email,
    String tel,
    String cnib,
    String desc,
    String user,
  ) async {
    var map = Map<String, dynamic>();
    map['action'] = 'addFour';
    map['table_name'] = 'fournisseur';
    map['nom'] = nom;
    map['type'] = type;
    map['pays'] = pays;
    map['ville'] = ville;
    map['adress'] = adress;
    map['email'] = email;
    map['tel'] = tel;
    map['cnib'] = cnib;
    map['user'] = user;
    map['desc'] = desc;
    try {
      final fourAddResponse = await http.post(Uri.parse(ROOT), body: map);
      if (200 == fourAddResponse.statusCode) {
        return fourAddResponse.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // suppression d'un fournisseur
  static Future<String> delFour(String idFour) async {
    var map = Map<String, dynamic>();
    map['idFour'] = idFour;
    map['table_name'] = 'fournisseur';
    map['action'] = 'deleteFour';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

  // Mettre a jour un fournisseur
  static Future<String> updFour(
    String nom,
    String type,
    String pays,
    String ville,
    String adress,
    String email,
    String tel,
    String cnib,
    String desc,
    String idFour,
  ) async {
    var map = Map<String, dynamic>();
    map['action'] = 'updFour';
    map['table_name'] = 'fournisseur';
    map['nom'] = nom;
    map['type'] = type;
    map['pays'] = pays;
    map['ville'] = ville;
    map['adress'] = adress;
    map['email'] = email;
    map['tel'] = tel;
    map['cnib'] = cnib;
    map['desc'] = desc;
    map['id_four'] = idFour;
    try {
      final fourAddResponse = await http.post(Uri.parse(ROOT), body: map);
      if (200 == fourAddResponse.statusCode) {
        return fourAddResponse.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Recuperation des Fournisseur
  static Future<List<FournisseurModel>> getFournisseur() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'fournisseur';
    map['action'] = 'getfour';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      //  (response.body);
      if (200 == response.statusCode) {
        List<FournisseurModel> fourListe = fourResponse(response.body);
        return fourListe;
      } else {
        List<FournisseurModel> vide = [
          FournisseurModel(
              idFour: '-1',
              nomFour: '-1',
              dateFour: '-1',
              userFour: '-1',
              typeFour: '-1',
              addressFour: '-1',
              villeFour: '-1',
              paysFour: '-1',
              telFour: '-1',
              codePosFour: '-1',
              emailFour: '-1',
              fourCNIB: '-1',
              fourDesc: '-1')
        ];
        return vide;
      }
    } catch (e) {
      List<FournisseurModel> videExcept = [
        FournisseurModel(
            idFour: '-2',
            nomFour: '-2',
            dateFour: '-2',
            userFour: '-2',
            typeFour: '-2',
            addressFour: '-2',
            villeFour: '-2',
            paysFour: '-2',
            telFour: '-2',
            codePosFour: '-2',
            emailFour: '-2',
            fourCNIB: '-2',
            fourDesc: '-2')
      ];
      return videExcept;
    }
  }

  static List<FournisseurModel> fourResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<FournisseurModel>((json) => FournisseurModel.fromJson(json))
        .toList();
  }
  // fin services fournisseur

  // ======================================================================//
  // =======                                                        =======//
  // =======      Tous les services liee a la table clients         =======//
  // =======                                                        =======//
  // ======================================================================//

  // suppression d'un client
  static Future<String> delClient(String idClient) async {
    var map = Map<String, dynamic>();
    map['idClient'] = idClient;
    map['table_name'] = 'client';
    map['action'] = 'deleteClient';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

// Recuperer un client par son id
  static Future<List<ClientModel>> getOneClients(String id) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'client';
    map['action'] = 'getOneClients';
    map['id'] = id;
    //  (id);
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      //  (response.body);
      if (200 == response.statusCode) {
        List<ClientModel> clientListe = cientResponse(response.body);
        return clientListe;
      } else {
        List<ClientModel> vide = [
          ClientModel(
              id_client: '-1',
              type_client: '-1',
              nom_complet_client: '-1',
              cnib_client: '-1',
              date_client: '-1',
              tel_client: '-1',
              adress_client: '-1',
              user_client: '-1',
              ville_client: '-1',
              desc_client: '-1')
        ];
        return vide;
      }
    } catch (e) {
      (e);
      List<ClientModel> videExcept = [
        ClientModel(
            id_client: '-2',
            type_client: '-2',
            nom_complet_client: '-2',
            cnib_client: '-2',
            date_client: '-2',
            tel_client: '-2',
            adress_client: '-2',
            user_client: '-2',
            ville_client: '-2',
            desc_client: '-2')
      ];
      return videExcept;
    }
  }

  // Recuperation de la liste des clients
  static Future<List<ClientModel>> getClients() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'client';
    map['action'] = 'getClient';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      //  (response.body);
      if (200 == response.statusCode) {
        List<ClientModel> clientListe = cientResponse(response.body);
        return clientListe;
      } else {
        List<ClientModel> vide = [
          ClientModel(
              id_client: '-1',
              type_client: '-1',
              nom_complet_client: '-1',
              cnib_client: '-1',
              date_client: '-1',
              tel_client: '-1',
              adress_client: '-1',
              user_client: '-1',
              ville_client: '-1',
              desc_client: '-1')
        ];
        return vide;
      }
    } catch (e) {
      (e);
      List<ClientModel> videExcept = [
        ClientModel(
            id_client: '-2',
            type_client: '-2',
            nom_complet_client: '-2',
            cnib_client: '-2',
            date_client: '-2',
            tel_client: '-2',
            adress_client: '-2',
            user_client: '-2',
            ville_client: '-2',
            desc_client: '-2')
      ];
      return videExcept;
    }
  }

  static List<ClientModel> cientResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ClientModel>((json) => ClientModel.fromJson(json))
        .toList();
  }

  // Recuperation de la liste des clients
  static Future<List<ClientModel>> getClientsLimit(
      String limit, String search) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'client';
    map['limit'] = limit;
    map['search'] = search;
    map['action'] = 'getClientsLimit';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      //  (response.body);
      if (200 == response.statusCode) {
        List<ClientModel> clientListe = cientLimitResponse(response.body);
        return clientListe;
      } else {
        List<ClientModel> vide = [
          ClientModel(
              id_client: '-1',
              type_client: '-1',
              nom_complet_client: '-1',
              cnib_client: '-1',
              date_client: '-1',
              tel_client: '-1',
              adress_client: '-1',
              user_client: '-1',
              ville_client: '-1',
              desc_client: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<ClientModel> videExcept = [
        ClientModel(
            id_client: '-2',
            type_client: '-2',
            nom_complet_client: '-2',
            cnib_client: '-2',
            date_client: '-2',
            tel_client: '-2',
            adress_client: '-2',
            user_client: '-2',
            ville_client: '-2',
            desc_client: '-2')
      ];
      return videExcept;
    }
  }

  static List<ClientModel> cientLimitResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ClientModel>((json) => ClientModel.fromJson(json))
        .toList();
  }

  // Ajouter un client
  static Future<String> addClient(
    String nom,
    String type,
    String ville,
    String adress,
    String tel,
    String cnib,
    String desc,
    String user,
  ) async {
    var map = Map<String, dynamic>();
    map['action'] = 'addClient';
    map['table_name'] = 'client';
    map['nom'] = nom;
    map['type'] = type;
    map['ville'] = ville;
    map['adress'] = adress;
    map['tel'] = tel;
    map['cnib'] = cnib;
    map['desc'] = desc;
    map['user'] = user;
    try {
      final fourAddResponse = await http.post(Uri.parse(ROOT), body: map);
      if (200 == fourAddResponse.statusCode) {
        return fourAddResponse.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Mettre a jour un client
  static Future<String> updClient(
    String nom,
    String type,
    String ville,
    String adress,
    String tel,
    String cnib,
    String desc,
    String idClient,
  ) async {
    var map = Map<String, dynamic>();
    map['action'] = 'updClient';
    map['table_name'] = 'client';
    map['nom'] = nom;
    map['type'] = type;
    map['ville'] = ville;
    map['adress'] = adress;
    map['tel'] = tel;
    map['cnib'] = cnib;
    map['desc'] = desc;
    map['idClient'] = idClient;
    try {
      final fourAddResponse = await http.post(Uri.parse(ROOT), body: map);
      if (200 == fourAddResponse.statusCode) {
        return fourAddResponse.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }
  // fin services clients

  // Recuperation de la lists des ventes
  static Future<List<VenteModel>> getVente(String isDeliver) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'commande';
    map['_isDeliver'] = isDeliver;
    map['action'] = 'getVente';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        List<VenteModel> venteListe = venteResponse(response.body);
        return venteListe;
      } else {
        List<VenteModel> vide = [
          VenteModel(
              idCom: '-1',
              idClient: '-1',
              clientName: '-1',
              nbrProd: '-1',
              prixTotal: '-1',
              comDate: '-1',
              comEtat: '-1',
              user: '-1',
              is_deliver_com: '-1',
              is_print_com: '-1')
        ];
        return vide;
      }
    } catch (e) {
      List<VenteModel> videExcept = [
        VenteModel(
            idCom: '-2',
            idClient: '-2',
            clientName: '-2',
            nbrProd: '-2',
            prixTotal: '-2',
            comDate: '-2',
            comEtat: '-2',
            user: '-2',
            is_deliver_com: '-2',
            is_print_com: '-2')
      ];
      return videExcept;
    }
  }

  static List<VenteModel> venteResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<VenteModel>((json) => VenteModel.fromJson(json)).toList();
  }

  // Recuperation de la lists des ventes avec limit
  static Future<List<VenteModel>> getVenteLimit(
      String isDeliver, String limit, String search) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'commande';
    map['_isDeliver'] = isDeliver;
    map['limit'] = limit;
    map['search'] = search;
    map['action'] = 'getVenteLimit';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        // print(response.body);
        List<VenteModel> venteListe = venteLimitResponse(response.body);

        return venteListe;
      } else {
        List<VenteModel> vide = [
          VenteModel(
              idCom: '-1',
              idClient: '-1',
              clientName: '-1',
              nbrProd: '-1',
              prixTotal: '-1',
              comDate: '-1',
              comEtat: '-1',
              user: '-1',
              is_deliver_com: '-1',
              is_print_com: '-1')
        ];
        return vide;
      }
    } catch (e) {
      List<VenteModel> videExcept = [
        VenteModel(
            idCom: '-2',
            idClient: '-2',
            clientName: '-2',
            nbrProd: '-2',
            prixTotal: '-2',
            comDate: '-2',
            comEtat: '-2',
            user: '-2',
            is_deliver_com: '-2',
            is_print_com: '-2')
      ];
      return videExcept;
    }
  }

  static List<VenteModel> venteLimitResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<VenteModel>((json) => VenteModel.fromJson(json)).toList();
  }

  // creer une vente
  static Future<String> creatVente(String idClient, String user) async {
    var map = Map<String, dynamic>();

    map['idClient'] = idClient;
    map['user'] = user;
    map['table_name'] = 'commande';
    map['action'] = 'creatVente';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

// get vente Infos
  static Future<List<VenteInfos>> getVenteInfos(String idClient) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'commande';
    map['action'] = 'getVenteInfos';
    map['idClient'] = idClient;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);

      if (200 == response.statusCode) {
        List<VenteInfos> ventInfoListe = venteInfoResponse(response.body);
        return ventInfoListe;
      } else {
        List<VenteInfos> vide = [
          VenteInfos(dateVente: '-1', clientName: '-1', venteId: '-1')
        ];
        return vide;
      }
    } catch (e) {
      List<VenteInfos> videExcept = [
        VenteInfos(dateVente: '-2', clientName: '-2', venteId: '-2')
      ];
      return videExcept;
    }
  }

  static List<VenteInfos> venteInfoResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<VenteInfos>((json) => VenteInfos.fromJson(json)).toList();
  }

  // Envoie du contenu de la vente
  static Future<String> sendVenteList(String idProd, String idClient,
      String qts, String prix, String idCom) async {
    var map = Map<String, dynamic>();

    map['idProd'] = idProd;
    map['idClient'] = idClient;
    map['qts'] = qts;
    map['prix'] = prix;
    map['idCom'] = idCom;
    map['table_name'] = 'contenuecom';
    map['action'] = 'fill_vente';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Recuperation du contenu de la vente
  static Future<List<ContenuCom>> getVenteContent(String idCom) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'commande';
    map['action'] = 'getVenteContent';
    map['idCom'] = idCom;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<ContenuCom> catListe = venteContentResponse(response.body);
        return catListe;
      } else {
        List<ContenuCom> vide = [
          ContenuCom(
            idRav: '-1',
            idProd: '-1',
            idFour: '-1',
            qtsProd: '-1',
            prixUnit: '-1',
            designation: '-1',
            qtsTotal: '-1',
            prixPromo: '-1',
          )
        ];
        return vide;
      }
    } catch (e) {
      List<ContenuCom> videExcept = [
        ContenuCom(
          idRav: '-2',
          idProd: '-2',
          idFour: '-2',
          qtsProd: '-2',
          prixUnit: '-2',
          designation: '-2',
          qtsTotal: '-2',
          prixPromo: '-2',
        )
      ];
      return videExcept;
    }
  }

  static List<ContenuCom> venteContentResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ContenuCom>((json) => ContenuCom.fromJson(json)).toList();
  }

  //Supprimer un produit de la vente
  static Future<String> deleteVenteItem(
      String idProd, String idCom, String quantite) async {
    var map = Map<String, dynamic>();
    map['idProd'] = idProd;
    map['idCom'] = idCom;
    map['quantite'] = quantite;
    map['table_name'] = 'contenuecom';
    map['action'] = 'deleteVenteItem';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  //Supprimer toute la vente
  static Future<String> deleteVente(
    String idCom,
  ) async {
    var map = Map<String, dynamic>();
    map['idCom'] = idCom;
    map['table_name'] = 'commande';
    map['action'] = 'deleteVente';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  //Valider la livraison
  static Future<String> venteIsdeliver(String idCom) async {
    var map = Map<String, dynamic>();
    map['idCom'] = idCom;
    map['table_name'] = 'commande';
    map['action'] = 'venteIsdeliver';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Recuperation des infos de paiements du client
  static Future<List<FourPay>> getVentePay(String idCom) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'paycom';
    map['action'] = 'getVentePay';
    map['idCom'] = idCom;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<FourPay> catListe = ventePayResponse(response.body);
        return catListe;
      } else {
        List<FourPay> vide = [
          FourPay(
              typePay: '-1',
              totalPay: '-1',
              amountPay: '-1',
              datePay: '-1',
              user: '-1')
        ];
        return vide;
      }
    } catch (e) {
      List<FourPay> videExcept = [
        FourPay(
            typePay: '-2',
            totalPay: '-2',
            amountPay: '-2',
            datePay: '-2',
            user: '-2')
      ];
      return videExcept;
    }
  }

  static List<FourPay> ventePayResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<FourPay>((json) => FourPay.fromJson(json)).toList();
  }

  //effectuer un paiement de vente
  static Future<String> clientNewPaiement(String paye, String type,
      String total, String idCom, String user, String mode) async {
    var map = Map<String, dynamic>();
    map['type'] = type;
    map['mode'] = mode;
    map['paye'] = paye;
    map['prix'] = total;
    map['idCom'] = idCom;
    map['user'] = user;
    map['table_name'] = 'paycom';
    map['action'] = 'clientNewPaiement';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

// Selection de vente du jour
  static Future<String> dayVente() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'paycom';
    map['action'] = 'dayVente';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }
  // ======================================================================//
  // =======                                                        =======//
  // =======       Tous les services liee a la table commande       =======//
  // =======                                                        =======//
  // ======================================================================//

  // creer une commade
  static Future<String> creatCom(String idFour, String user) async {
    var map = Map<String, dynamic>();
    map['idFour'] = idFour;
    map['user'] = user;
    map['table_name'] = 'ravitail';
    map['action'] = 'creatCont';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

  // get Commades list
  static Future<List<CommandeModel>> getCom() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'ravitail';
    map['action'] = 'getCom';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        List<CommandeModel> comListe = comResponse(response.body);
        return comListe;
      } else {
        List<CommandeModel> vide = [
          CommandeModel(
              idCom: '-1',
              fourId: '-1',
              fourNom: '-1',
              nbrProd: '-1',
              prixTotal: '-1',
              comDate: '-1',
              comEtat: '-1',
              user: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<CommandeModel> videExcept = [
        CommandeModel(
            idCom: '-2',
            fourId: '-2',
            fourNom: '-2',
            nbrProd: '-2',
            prixTotal: '-2',
            comDate: '-2',
            comEtat: '-2',
            user: '-2')
      ];
      return videExcept;
    }
  }

  static List<CommandeModel> comResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CommandeModel>((json) => CommandeModel.fromJson(json))
        .toList();
  }

  // get Commades list with limit
  static Future<List<CommandeModel>> getComLimit(
      String isDeliver, String limit, String search) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'ravitail';
    map['limit'] = limit;
    map['search'] = search;
    map['isDeliver'] = isDeliver;
    map['action'] = 'getComLimit';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        List<CommandeModel> comListe = comLimitResponse(response.body);
        return comListe;
      } else {
        List<CommandeModel> vide = [
          CommandeModel(
              idCom: '-1',
              fourId: '-1',
              fourNom: '-1',
              nbrProd: '-1',
              prixTotal: '-1',
              comDate: '-1',
              comEtat: '-1',
              user: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<CommandeModel> videExcept = [
        CommandeModel(
            idCom: '-2',
            fourId: '-2',
            fourNom: '-2',
            nbrProd: '-2',
            prixTotal: '-2',
            comDate: '-2',
            comEtat: '-2',
            user: '-2')
      ];
      return videExcept;
    }
  }

  static List<CommandeModel> comLimitResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CommandeModel>((json) => CommandeModel.fromJson(json))
        .toList();
  }

  // validate a commande
  static Future<String> validateCom(String idRav) async {
    var map = Map<String, dynamic>();
    map['idRav'] = idRav;
    map['table_name'] = 'ravitail';
    map['action'] = 'validateCom';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

  // delete a commande

  static Future<String> delCom(String idRav) async {
    var map = Map<String, dynamic>();
    map['idRav'] = idRav;
    map['table_name'] = 'ravitail';
    map['action'] = 'delCom';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

  // get Commande Infos
  static Future<List<CommandInfos>> getComInfos(String idFour) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'ravitail';
    map['action'] = 'getComInfos';
    map['idFour'] = idFour;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        List<CommandInfos> catListe = comInfoResponse(response.body);
        return catListe;
      } else {
        List<CommandInfos> vide = [
          CommandInfos(dateCom: '-1', fourName: '-1', comId: '-1')
        ];
        return vide;
      }
    } catch (e) {
      List<CommandInfos> videExcept = [
        CommandInfos(dateCom: '-2', fourName: '-2', comId: '-2')
      ];
      return videExcept;
    }
  }

  static List<CommandInfos> comInfoResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CommandInfos>((json) => CommandInfos.fromJson(json))
        .toList();
  }

  // Envoie du contenu de la commande
  static Future<String> sendComList(String idProd, String idFour, String qts,
      String prix, String idCom) async {
    var map = Map<String, dynamic>();
    map['idProd'] = idProd;
    map['idFour'] = idFour;
    map['qts'] = qts;
    map['prix'] = prix;
    map['idCom'] = idCom;
    map['table_name'] = 'contenuerav';
    map['action'] = 'fill_com';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  //Supprimer un produit d'une commande
  static Future<String> deleteComItem(
      String idProd, String idCom, String quantite) async {
    var map = Map<String, dynamic>();
    map['idProd'] = idProd;
    map['idCom'] = idCom;
    map['quantite'] = quantite;
    map['table_name'] = 'contenuerav';
    map['action'] = 'deleteComItem';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Recuperation du contenu de la commmande
  static Future<List<ContenuCom>> getCommandeContent(String idCom) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'ravitail';
    map['action'] = 'getCommandeContent';
    map['idCom'] = idCom;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        List<ContenuCom> catListe = commandeContentResponse(response.body);
        return catListe;
      } else {
        List<ContenuCom> vide = [
          ContenuCom(
            idRav: '-1',
            idProd: '-1',
            idFour: '-1',
            qtsProd: '-1',
            prixUnit: '-1',
            designation: '-1',
            qtsTotal: '-1',
            prixPromo: '-1',
          )
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<ContenuCom> videExcept = [
        ContenuCom(
          idRav: '-2',
          idProd: '-2',
          idFour: '-2',
          qtsProd: '-2',
          prixUnit: '-2',
          designation: '-2',
          qtsTotal: '-2',
          prixPromo: '-2',
        )
      ];
      return videExcept;
    }
  }

  static List<ContenuCom> commandeContentResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ContenuCom>((json) => ContenuCom.fromJson(json)).toList();
  }

  // envoie des infos de paiement
  static Future<String> sendPaiement(
      String type, String prixTotal, String paye, String idCom) async {
    var map = Map<String, dynamic>();

    map['type'] = type;
    map['prix'] = prixTotal;
    map['paye'] = paye;
    map['idCom'] = idCom;
    map['table_name'] = 'payravitail';
    map['action'] = 'payment';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  //effectuer un paiement
  static Future<String> fourNewPaiement(String paye, String idCom) async {
    var map = Map<String, dynamic>();
    map['paye'] = paye;
    map['idCom'] = idCom;
    map['table_name'] = 'payravitail';
    map['action'] = 'newPayment';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Recuperation des infos de paiements
  static Future<List<FourPay>> getCommandePay(String idCom) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'payravitail';
    map['action'] = 'getCommandePay';
    map['idCom'] = idCom;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        List<FourPay> catListe = commandePayResponse(response.body);
        return catListe;
      } else {
        List<FourPay> vide = [
          FourPay(
              typePay: '-1',
              totalPay: '-1',
              amountPay: '-1',
              datePay: '-1',
              user: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<FourPay> videExcept = [
        FourPay(
            typePay: '-2',
            totalPay: '-2',
            amountPay: '-2',
            datePay: '-2',
            user: '-2')
      ];
      return videExcept;
    }
  }

  static List<FourPay> commandePayResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<FourPay>((json) => FourPay.fromJson(json)).toList();
  }

  // insertion d'un credit
  static Future<String> sendCredit(
      String prix, String dateFin, String idCom, String idUser) async {
    var map = Map<String, dynamic>();
    map['prix'] = prix;
    map['dateFin'] = dateFin;
    map['idCom'] = idCom;
    map['table_name'] = 'credit';
    map['action'] = 'sendCredit';
    map['idUser'] = idUser;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  //Notifier une impression
  static Future<String> notifyPrint(String idCom) async {
    var map = Map<String, dynamic>();
    map['idCom'] = idCom;
    map['table_name'] = 'impression';
    map['action'] = 'notifyPrint';
    map['idUser'] = '1';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // ======================================================================//
  // =======                                                        =======//
  // =======       Tous les services liee a la table Entreprise      =======//
  // =======                                                        =======//
  // ======================================================================//
  // modifier les infos de l'entreprise
  static Future<String> updCompInfos(
      String nomComp,
      String adressComp,
      String emailComp,
      String tel1Comp,
      String tel2Comp,
      String tel3Comp,
      String idComp) async {
    var map = Map<String, dynamic>();
    map['nomComp'] = nomComp;
    map['adressComp'] = adressComp;
    map['emailComp'] = emailComp;
    map['tel1Comp'] = tel1Comp;
    map['tel2Comp'] = tel2Comp;
    map['tel3Comp'] = tel3Comp;
    map['idComp'] = idComp;
    map['table_name'] = 'company';
    map['action'] = 'updCompInfos';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  static Future getCompayDetail(String route) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'company';
    map['action'] = 'getComapayDetails';
    try {
      final response = await http.get(Uri.parse(ROOT + route));

      if (200 == response.statusCode) {
        return {"status": 200, 'data': companyResponse(response.body)};
      } else if (404 == response.statusCode) {
        return {"status": 404, "message": jsonDecode(response.body)['message']};
      } else if (403 == response.statusCode) {
        return {"status": 403, "message": jsonDecode(response.body)['message']};
      } else if (400 == response.statusCode) {
        return {"status": 400, "message": jsonDecode(response.body)['message']};
      } else if (500 == response.statusCode) {
        return {"status": 500, "message": jsonDecode(response.body)['message']};
      }
    } catch (e) {
      print(e);
      return {"status": 400, "message": "Erreur de connexion"};
    }
  }

  static CompanyModel companyResponse(String responseBody) {
    final parsed = json.decode(responseBody);
    return CompanyModel.fromJson(parsed);
  }

  // get commande list per date
  static Future<List<CommandeDetailsModel>> getCommandesListet(
      String mois, String annee) async {
    var map = Map<String, dynamic>();
    map['mois'] = mois;
    map['annee'] = annee;
    map['table_name'] = 'commande';
    map['action'] = 'getCommandesListet';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<CommandeDetailsModel> catListe = getComResponse(response.body);
        return catListe;
      } else {
        List<CommandeDetailsModel> vide = [
          CommandeDetailsModel(
              id_com: '-1',
              date_com: '-1',
              total_com: '-1',
              user_com: '-1',
              client_com: '-1',
              deliver_com: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<CommandeDetailsModel> videExcept = [
        CommandeDetailsModel(
            id_com: '-2',
            date_com: '-2',
            total_com: '-2',
            user_com: '-2',
            client_com: '-2',
            deliver_com: '-2')
      ];
      return videExcept;
    }
  }

  static List<CommandeDetailsModel> getComResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CommandeDetailsModel>(
            (json) => CommandeDetailsModel.fromJson(json))
        .toList();
  }

  // ***************************
// get commande pay type and num
  static Future<List<PayComNumListModel>> getComPayTypeNum() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'paycom';
    map['action'] = 'getComPayTypeNum';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<PayComNumListModel> catListe =
            getComPayTypeNumResponse(response.body);
        return catListe;
      } else {
        List<PayComNumListModel> vide = [
          PayComNumListModel(itemId: '-1', itemType: '-1', itemVal: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<PayComNumListModel> videExcept = [
        PayComNumListModel(itemId: '-2', itemType: '-2', itemVal: '-2')
      ];
      return videExcept;
    }
  }

  static List<PayComNumListModel> getComPayTypeNumResponse(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<PayComNumListModel>((json) => PayComNumListModel.fromJson(json))
        .toList();
  }
  // **************************

  // get prod linechart data
  static Future<List<ProdLineChartModel>> getProdLineChart(
      String mois, String annee) async {
    var map = Map<String, dynamic>();
    map['mois'] = mois;
    map['annee'] = annee;
    map['table_name'] = 'commande';
    map['action'] = 'getProChartData';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<ProdLineChartModel> catListe = chartResponse(response.body);
        return catListe;
      } else {
        List<ProdLineChartModel> vide = [
          ProdLineChartModel(number: '-1', item: '-1', val: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<ProdLineChartModel> videExcept = [
        ProdLineChartModel(number: '-2 ', item: '-2', val: '-2')
      ];
      return videExcept;
    }
  }

  static List<ProdLineChartModel> chartResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ProdLineChartModel>((json) => ProdLineChartModel.fromJson(json))
        .toList();
  }

  // recuperrer les credits par dates
  static Future<List<CreditModel>> credit(String mois, String annee) async {
    var map = Map<String, dynamic>();
    map['mois'] = mois;
    map['annee'] = annee;
    map['table_name'] = 'credit';
    map['action'] = 'getCredit';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<CreditModel> catListe = creditResponse(response.body);
        return catListe;
      } else {
        List<CreditModel> vide = [
          CreditModel(
              nom: '-1',
              nume: '-1',
              paye: '-1',
              reste: '-1',
              dateCred: '-1',
              dateRem: '-1',
              idCre: '-1',
              agent: '-1',
              total_com: '-1',
              fact_num: '-1',
              is_manual: '-1',
              client_tel: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<CreditModel> videExcept = [
        CreditModel(
            nom: '-2',
            nume: '-2',
            paye: '-2',
            reste: '-2',
            dateCred: '-2',
            dateRem: '-2',
            idCre: '-2',
            agent: '-2',
            total_com: '-2',
            fact_num: '-2',
            is_manual: '-2',
            client_tel: '-2')
      ];
      return videExcept;
    }
  }

  static List<CreditModel> creditResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CreditModel>((json) => CreditModel.fromJson(json))
        .toList();
  }

  // recuperrer les paiements par dates
  static Future<List<PaymentListeModel>> paymentListe(
      String mois, String annee) async {
    var map = Map<String, dynamic>();
    map['mois'] = mois;
    map['annee'] = annee;
    map['table_name'] = 'paycom';
    map['action'] = 'getPayments';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<PaymentListeModel> payListe = payListeResponse(response.body);
        return payListe;
      } else {
        List<PaymentListeModel> vide = [
          PaymentListeModel(
              somme_pay: '-1',
              idcom_pay: '-1',
              id_pay: '-1',
              pay_type: '-1',
              user_pay: '-1',
              date_pay: '-1',
              client_pay: '-1',
              fact_num: '-1',
              is_manual: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<PaymentListeModel> videExcept = [
        PaymentListeModel(
            somme_pay: '-2',
            idcom_pay: '-2',
            id_pay: '-2',
            pay_type: '-2',
            user_pay: '-2',
            date_pay: '-2',
            client_pay: '-2',
            fact_num: '-2',
            is_manual: '-2')
      ];
      return videExcept;
    }
  }

  static List<PaymentListeModel> payListeResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<PaymentListeModel>((json) => PaymentListeModel.fromJson(json))
        .toList();
  }

  // recuperrer les depense par dates
  static Future<List<DepenseModel>> getDepensePerDate(
      String mois, String annee) async {
    var map = Map<String, dynamic>();
    // print("moi: " + mois + " Annee: " + annee);
    map['mois'] = mois;
    map['annee'] = annee;
    map['table_name'] = 'depense';
    map['action'] = 'getDepensePerDate';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<DepenseModel> depListe = depenseListeResponse(response.body);
        return depListe = depenseListeResponse(response.body);
      } else {
        List<DepenseModel> vide = [
          DepenseModel(
              id_dep: '-1',
              date_dep: '-1',
              prix_dep: '-1',
              raison_dep: '-1',
              id_user: '-1',
              etat: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<DepenseModel> videExcept = [
        DepenseModel(
            id_dep: '-2',
            date_dep: '-2',
            prix_dep: '-2',
            raison_dep: '-2',
            id_user: '-2',
            etat: '-2')
      ];
      return videExcept;
    }
  }

  static List<DepenseModel> depenseListeResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<DepenseModel>((json) => DepenseModel.fromJson(json))
        .toList();
  }

  // ajouter un virement bancaire
  static Future<String> addVirement(
      String nomComp,
      String numComp,
      String nomBanq,
      String agent,
      String somme,
      String dateVire,
      String idUser,
      String desc,
      String type) async {
    var map = Map<String, dynamic>();
    map['nomComp'] = nomComp;
    map['numComp'] = numComp;
    map['nomBanq'] = nomBanq;
    map['agent'] = agent;
    map['somme'] = somme;
    map['dateVire'] = dateVire;
    map['type'] = type;
    map['table_name'] = type == 'vire' ? 'virementbank' : 'retraitbank';
    map['action'] = 'transfert';
    map['idUser'] = idUser;
    map['desc'] = desc;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // recuperation des retrait
  static Future<List<RetraitModel>> getRetraitLis() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'retraitbank';
    map['action'] = 'getRetraitLis';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        List<RetraitModel> catListe = restraitResponse(response.body);
        return catListe;
      } else {
        List<RetraitModel> vide = [
          RetraitModel(
              nom_compte: '-1',
              num_compte: '-1',
              banq_nom: '-1',
              agent: '-1',
              somme: '-1',
              date_vire: '-1',
              id_ret: '-1',
              desc_re: '-1',
              process: '-1',
              id_com: '-1',
              fact_num: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<RetraitModel> videExcept = [
        RetraitModel(
            nom_compte: '-2',
            num_compte: '-2',
            banq_nom: '-2',
            agent: '-2',
            somme: '-2',
            date_vire: '-2',
            id_ret: '-2',
            desc_re: '-2',
            process: '-2',
            id_com: '-2',
            fact_num: '-2')
      ];
      return videExcept;
    }
  }

  static List<RetraitModel> restraitResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<RetraitModel>((json) => RetraitModel.fromJson(json))
        .toList();
  }

  // supprimer un retrait
  static Future<String> delRet(String idret) async {
    var map = Map<String, dynamic>();
    map['idret'] = idret;
    map['table_name'] = 'retraitbank';
    map['action'] = 'delRet';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // recuperation des virements
  static Future<List<VirementModel>> getVireLis() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'virementbank';
    map['action'] = 'getVireLis';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<VirementModel> catListe = vireResponse(response.body);
        return catListe;
      } else {
        List<VirementModel> vide = [
          VirementModel(
              nom_compte: '-1',
              num_compte: '-1',
              banq_nom: '-1',
              agent: '-1',
              somme: '-1',
              date_vire: '-1',
              id_vire: '-1',
              desc_vire: '-1',
              process: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<VirementModel> videExcept = [
        VirementModel(
            nom_compte: '-2',
            num_compte: '-2',
            banq_nom: '-2',
            agent: '-2',
            somme: '-2',
            date_vire: '-2',
            id_vire: '-2',
            desc_vire: '-2',
            process: '-2')
      ];
      return videExcept;
    }
  }

  static List<VirementModel> vireResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VirementModel>((json) => VirementModel.fromJson(json))
        .toList();
  }

  // supprimer un virement
  static Future<String> delVire(String idVire) async {
    var map = Map<String, dynamic>();
    map['idVire'] = idVire;
    map['table_name'] = 'virementbank';
    map['action'] = 'delVire';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // creation d'un compte de versement
  static Future<String> compteVersement(String user, String idClient) async {
    var map = Map<String, dynamic>();
    map['user'] = user;
    map['idClient'] = idClient;
    map['table_name'] = 'compteversement';
    map['action'] = 'compteVersement';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // supprimer un compte de versement
  static Future<String> delComptVer(String id_cpt) async {
    var map = Map<String, dynamic>();
    map['id_cpt'] = id_cpt;
    map['table_name'] = 'compteversement';
    map['action'] = 'delcompteVers';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // recuperer un seul versement
  static Future<String> getSingleVers(String id_client) async {
    var map = Map<String, dynamic>();
    map['id_client'] = id_client;
    map['table_name'] = 'compteversement';
    map['action'] = 'getSingleVers';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // terminer un versement
  static Future<String> terminateVers(String id_cpt) async {
    var map = Map<String, dynamic>();
    map['id_cpt'] = id_cpt;
    map['table_name'] = 'compteversement';
    map['action'] = 'terminateVers';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Appliquer le versement
  static Future<String> applyVersement(String id_client) async {
    var map = Map<String, dynamic>();
    map['id_client'] = id_client;
    map['table_name'] = 'compteversement';
    map['action'] = 'applyVersement';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // realiser un versement
  static Future<String> addVersement(String deposant, String tel, String cnib,
      String somme, String user, String id_cpt) async {
    // print(idClien);
    var map = Map<String, dynamic>();
    map['deposant'] = deposant;
    map['tel'] = tel;
    map['cnib'] = cnib;
    map['somme'] = somme;
    map['table_name'] = 'versenent';
    map['action'] = 'addversement';
    map['idUser'] = user;
    map['id_cpt'] = id_cpt;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // recuperation des versement grouper
  static Future<List<CompteVersementModel>> getlisteVersementCount() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'compteversement';
    map['action'] = 'getAllVersLis';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<CompteVersementModel> catListe = verseCptResponse(response.body);
        return catListe;
      } else {
        List<CompteVersementModel> vide = [
          CompteVersementModel(
              id_cpt: '-1',
              client_cpt: '-1',
              date_cpt: '-1',
              etat_cpt: '-1',
              somme_cpt: '-1',
              agent_cpt: '-1',
              tel_cpt: '-1',
              id_client: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<CompteVersementModel> videExcept = [
        CompteVersementModel(
            id_cpt: '-2',
            client_cpt: '-2',
            date_cpt: '-2',
            etat_cpt: '-2',
            somme_cpt: '-2',
            agent_cpt: '-2',
            tel_cpt: '-2',
            id_client: '-2')
      ];
      return videExcept;
    }
  }

  static List<CompteVersementModel> verseCptResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CompteVersementModel>(
            (json) => CompteVersementModel.fromJson(json))
        .toList();
  }

  // recuperation des versement grouper avec Limit
  static Future<List<CompteVersementModel>> getlisteVersementCounLimit(
      String limit, String search) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'compteversement';
    map['limit'] = limit;
    map['search'] = search;
    map['action'] = 'getAllVersLisLimit';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<CompteVersementModel> catListe =
            verseCptLimitResponse(response.body);
        return catListe;
      } else {
        List<CompteVersementModel> vide = [
          CompteVersementModel(
              id_cpt: '-1',
              client_cpt: '-1',
              date_cpt: '-1',
              etat_cpt: '-1',
              somme_cpt: '-1',
              agent_cpt: '-1',
              tel_cpt: '-1',
              id_client: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<CompteVersementModel> videExcept = [
        CompteVersementModel(
            id_cpt: '-2',
            client_cpt: '-2',
            date_cpt: '-2',
            etat_cpt: '-2',
            somme_cpt: '-2',
            agent_cpt: '-2',
            tel_cpt: '-2',
            id_client: '-2')
      ];
      return videExcept;
    }
  }

  static List<CompteVersementModel> verseCptLimitResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CompteVersementModel>(
            (json) => CompteVersementModel.fromJson(json))
        .toList();
  }

  // // recuperation des versement grouper du jour
  // static Future<List<CompteVersementModel>> getDaylistVersementCount() async {
  //   var map = Map<String, dynamic>();
  //   map['table_name'] = 'compteversement';
  //   map['action'] = 'getDaylistVersementCount';
  //   try {
  //     final response = await http.post(Uri.parse(ROOT), body: map);
  //     // print(response.body);
  //     if (200 == response.statusCode) {
  //       List<CompteVersementModel> catListe =
  //           dayVerseCptResponse(response.body);
  //       return catListe;
  //     } else {
  //       List<CompteVersementModel> vide = [
  //         CompteVersementModel(
  //             id_cpt: '-1',
  //             client_cpt: '-1',
  //             date_cpt: '-1',
  //             etat_cpt: '-1',
  //             somme_cpt: '-1',
  //             agent_cpt: '-1',
  //             tel_cpt: '-1',
  //             id_client: '-1')
  //       ];
  //       return vide;
  //     }
  //   } catch (e) {
  //     print(e);
  //     List<CompteVersementModel> videExcept = [
  //       CompteVersementModel(
  //           id_cpt: '-2',
  //           client_cpt: '-2',
  //           date_cpt: '-2',
  //           etat_cpt: '-2',
  //           somme_cpt: '-2',
  //           agent_cpt: '-2',
  //           tel_cpt: '-2',
  //           id_client: '-2')
  //     ];
  //     return videExcept;
  //   }
  // }

  // static List<CompteVersementModel> dayVerseCptResponse(String responseBody) {
  //   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  //   return parsed
  //       .map<CompteVersementModel>(
  //           (json) => CompteVersementModel.fromJson(json))
  //       .toList();
  // }

  // recuperation des versement grouper du jour
  static Future<List<CompteVersementModel>> getDaylistVersementCount(
      String mois, String annee) async {
    var map = Map<String, dynamic>();
    map['mois'] = mois;
    map['annee'] = annee;
    map['table_name'] = 'compteversement';
    map['action'] = 'getDaylistVersementCount';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<CompteVersementModel> catListe =
            dayVerseCptResponse(response.body);
        return catListe;
      } else {
        List<CompteVersementModel> vide = [
          CompteVersementModel(
              id_cpt: '-1',
              client_cpt: '-1',
              date_cpt: '-1',
              etat_cpt: '-1',
              somme_cpt: '-1',
              agent_cpt: '-1',
              tel_cpt: '-1',
              id_client: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<CompteVersementModel> videExcept = [
        CompteVersementModel(
            id_cpt: '-2',
            client_cpt: '-2',
            date_cpt: '-2',
            etat_cpt: '-2',
            somme_cpt: '-2',
            agent_cpt: '-2',
            tel_cpt: '-2',
            id_client: '-2')
      ];
      return videExcept;
    }
  }

  static List<CompteVersementModel> dayVerseCptResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CompteVersementModel>(
            (json) => CompteVersementModel.fromJson(json))
        .toList();
  }

  // recuperation des versements
  static Future<List<VersementModel>> getversement(String id_cpt) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'versenent';
    map['id_cpt'] = id_cpt;
    map['action'] = 'getVersLis';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<VersementModel> catListe = verseResponse(response.body);
        return catListe;
      } else {
        List<VersementModel> vide = [
          VersementModel(
              id_vers: '-1',
              somme_vers: '-1',
              date_vers: '-1',
              user_vers: '-1',
              nom_vers: '-1',
              cnib_vers: '-1',
              tel_vers: '-1',
              is_active_vers: '-1'),
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<VersementModel> videExcept = [
        VersementModel(
            id_vers: '-2',
            somme_vers: '-2',
            date_vers: '-2',
            user_vers: '-2',
            nom_vers: '-2',
            cnib_vers: '-2',
            tel_vers: '-2',
            is_active_vers: '-2')
      ];
      return videExcept;
    }
  }

  static List<VersementModel> verseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VersementModel>((json) => VersementModel.fromJson(json))
        .toList();
  }

// valider un versement
  static Future<String> validateVer(String id_vers) async {
    var map = Map<String, dynamic>();
    map['id_ver'] = id_vers;
    map['table_name'] = 'versenent';
    map['action'] = 'validateVer';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // supprimer un versement
  static Future<String> delVer(String id_vers) async {
    var map = Map<String, dynamic>();
    map['id_ver'] = id_vers;
    map['table_name'] = 'versenent';
    map['action'] = 'delVer';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // enregistrement de depense
  static Future<String> saveDepense(
      String desc, String somme, String user) async {
    var map = Map<String, dynamic>();
    map['desc'] = desc;
    map['somme'] = somme;
    map['table_name'] = 'depense';
    map['action'] = 'seaveDepense';
    map['idUser'] = user;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // valider une depense
  static Future<String> validateDep(String idep) async {
    var map = Map<String, dynamic>();
    map['idep'] = idep;
    map['table_name'] = 'depense';
    map['action'] = 'validateDep';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // supprimer une depense
  static Future<String> delDep(String idep) async {
    var map = Map<String, dynamic>();
    map['idep'] = idep;
    map['table_name'] = 'depense';
    map['action'] = 'delDep';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // recuperarion des depenses
  static Future<List<DepenseModel>> getDepenseLis() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'depense';
    map['action'] = 'getDepenseLis';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<DepenseModel> catListe = depenseResponse(response.body);
        return catListe;
      } else {
        List<DepenseModel> vide = [
          DepenseModel(
              id_dep: '-1',
              date_dep: '-1',
              prix_dep: '-1',
              raison_dep: '-1',
              id_user: '-1',
              etat: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<DepenseModel> videExcept = [
        DepenseModel(
            id_dep: '-2',
            date_dep: '-2',
            prix_dep: '-2',
            raison_dep: '-2',
            id_user: '-2',
            etat: '-2')
      ];
      return videExcept;
    }
  }

  static List<DepenseModel> depenseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<DepenseModel>((json) => DepenseModel.fromJson(json))
        .toList();
  }

  // recuperarion des depenses avec Limit
  static Future<List<DepenseModel>> getDepenseLisLimit(
      String limit, String search) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'depense';
    map['limit'] = limit;
    map['search'] = search;
    map['action'] = 'getDepenseLisLimit';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<DepenseModel> catListe = depenseLimitResponse(response.body);
        return catListe;
      } else {
        List<DepenseModel> vide = [
          DepenseModel(
              id_dep: '-1',
              date_dep: '-1',
              prix_dep: '-1',
              raison_dep: '-1',
              id_user: '-1',
              etat: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<DepenseModel> videExcept = [
        DepenseModel(
            id_dep: '-2',
            date_dep: '-2',
            prix_dep: '-2',
            raison_dep: '-2',
            id_user: '-2',
            etat: '-2')
      ];
      return videExcept;
    }
  }

  static List<DepenseModel> depenseLimitResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<DepenseModel>((json) => DepenseModel.fromJson(json))
        .toList();
  }

  // recuperer tous les credits sans filtres
  static Future<List<CreditModel>> allCredit() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'credit';
    map['action'] = 'getAllCredit';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<CreditModel> catListe = allcreditResponse(response.body);
        return catListe;
      } else {
        List<CreditModel> vide = [
          CreditModel(
              nom: '-1',
              nume: '-1',
              paye: '-1',
              reste: '-1',
              dateCred: '-1',
              dateRem: '-1',
              idCre: '-1',
              agent: '-1',
              total_com: '-1',
              fact_num: '-1',
              is_manual: '-1',
              client_tel: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<CreditModel> videExcept = [
        CreditModel(
            nom: '-2',
            nume: '-2',
            paye: '-2',
            reste: '-2',
            dateCred: '-2',
            dateRem: '-2',
            idCre: '-2',
            agent: '-2',
            total_com: '-2',
            fact_num: '-2',
            is_manual: '-2',
            client_tel: '-2')
      ];
      return videExcept;
    }
  }

  static List<CreditModel> allcreditResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CreditModel>((json) => CreditModel.fromJson(json))
        .toList();
  }

  // recuperer tous les credits avec Limit
  static Future<List<CreditModel>> allCreditLimit(
      String limit, String search) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'credit';
    map['limit'] = limit;
    map['search'] = search;
    map['action'] = 'allCreditLimit';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<CreditModel> catListe = allcreditLimitResponse(response.body);
        return catListe;
      } else {
        List<CreditModel> vide = [
          CreditModel(
              nom: '-1',
              nume: '-1',
              paye: '-1',
              reste: '-1',
              dateCred: '-1',
              dateRem: '-1',
              idCre: '-1',
              agent: '-1',
              total_com: '-1',
              fact_num: '-1',
              is_manual: '-1',
              client_tel: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<CreditModel> videExcept = [
        CreditModel(
            nom: '-2',
            nume: '-2',
            paye: '-2',
            reste: '-2',
            dateCred: '-2',
            dateRem: '-2',
            idCre: '-2',
            agent: '-2',
            total_com: '-2',
            fact_num: '-2',
            is_manual: '-2',
            client_tel: '-2')
      ];
      return videExcept;
    }
  }

  static List<CreditModel> allcreditLimitResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CreditModel>((json) => CreditModel.fromJson(json))
        .toList();
  }

  // Ajouter un credit manuelement
  static Future<String> addCredit(
    String id_client,
    String num_facture,
    String total_facture,
    String total_credit,
    String total_paye,
    String date_credit,
    String user_id,
  ) async {
    var map = Map<String, dynamic>();
    map['id_client'] = id_client;
    map['num_facture'] = num_facture;
    map['total_facture'] = total_facture;
    map['total_credit'] = total_credit;
    map['total_paye'] = total_paye;
    map['date_credit'] = date_credit;
    map['user_id'] = user_id;
    map['table_name'] = 'credit';
    map['action'] = 'addCredit';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      print(e);
      return '-2';
    }
  }

  // supprimer un credit
  static Future<String> delCredit(String idCred) async {
    // print("val: $idCred");
    var map = Map<String, dynamic>();
    map['idCred'] = idCred;
    map['table_name'] = 'credit';
    map['action'] = 'delCredit';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // realiser un remboursement
  static Future<String> rembourseCred(
      String deposant,
      String tel,
      String cnib,
      String somme,
      String idCred,
      String user,
      String numero,
      String payType) async {
    var map = Map<String, dynamic>();
    map['deposant'] = deposant;
    map['tel'] = tel;
    map['cnib'] = cnib;
    map['somme'] = somme;
    map['idCred'] = idCred;
    map['numero'] = numero;
    map['payType'] = payType;
    map['table_name'] = 'rembousement';
    map['action'] = 'RembourseCred';
    map['idUser'] = user;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Valider un paiement de credit
  static Future<String> valideRembourse(String idRem, String prix) async {
    var map = Map<String, dynamic>();
    map['idRem'] = idRem;
    map['prix'] = prix;
    map['table_name'] = 'rembousement';
    map['action'] = 'valideRembourse';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // recuperer la liste de reboursement
  static Future<List<RembourModel>> getRemboursList(String idCred) async {
    // print("cer: " + idCred);
    var map = Map<String, dynamic>();
    map['table_name'] = 'rembousement';
    map['idCred'] = idCred;
    map['action'] = 'getRemboursList';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<RembourModel> rembListe = rembourResponse(response.body);
        return rembListe;
      } else {
        List<RembourModel> vide = [
          RembourModel(
              id_rem: '-1',
              date_rem: '-1',
              nom_rem: '-1',
              card_id_rem: '-1',
              tel_rem: '-1',
              id_user_rem: '-1',
              montant_pay_rem: '-1',
              numero: '-1',
              pay_type: '-1',
              is_valid: '-1'),
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<RembourModel> videExcept = [
        RembourModel(
            id_rem: '-2',
            date_rem: '-2',
            nom_rem: '-2',
            card_id_rem: '-2',
            tel_rem: '-2',
            id_user_rem: '-2',
            montant_pay_rem: '-2',
            numero: '-2',
            pay_type: '-2',
            is_valid: '-2')
      ];
      return videExcept;
    }
  }

  static List<RembourModel> rembourResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<RembourModel>((json) => RembourModel.fromJson(json))
        .toList();
  }

  // supprimer un remboursement
  static Future<String> delRembourse(String idRem) async {
    var map = Map<String, dynamic>();
    map['idRem'] = idRem;
    map['table_name'] = 'rembousement';
    map['action'] = 'delRembourse';
    map['idUser'] = '1';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // inventaire de boutique

  // get commande list per date
  static Future<List<CommandeDetailsModel>> getInventaireComList(
      String debut, String fin) async {
    var map = Map<String, dynamic>();
    map['debut'] = debut;
    map['fin'] = fin;
    map['table_name'] = 'commande';
    map['action'] = 'getInventaireComList';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<CommandeDetailsModel> catListe =
            getinventaireComResponse(response.body);
        return catListe;
      } else {
        List<CommandeDetailsModel> vide = [
          CommandeDetailsModel(
              id_com: '-1',
              date_com: '-1',
              total_com: '-1',
              user_com: '-1',
              client_com: '-1',
              deliver_com: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<CommandeDetailsModel> videExcept = [
        CommandeDetailsModel(
            id_com: '-2',
            date_com: '-2',
            total_com: '-2',
            user_com: '-2',
            client_com: '-2',
            deliver_com: '-2')
      ];
      return videExcept;
    }
  }

  static List<CommandeDetailsModel> getinventaireComResponse(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CommandeDetailsModel>(
            (json) => CommandeDetailsModel.fromJson(json))
        .toList();
  }

  // recuperrer les paiements pour inventaire
  static Future<List<PaymentListeModel>> inventairePayList(
      String debut, String fin) async {
    var map = Map<String, dynamic>();
    map['debut'] = debut;
    map['fin'] = fin;
    map['table_name'] = 'paycom';
    map['action'] = 'inventairePayList';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<PaymentListeModel> payListe =
            inventairepayListeResponse(response.body);
        return payListe;
      } else {
        List<PaymentListeModel> vide = [
          PaymentListeModel(
              somme_pay: '-1',
              idcom_pay: '-1',
              id_pay: '-1',
              pay_type: '-1',
              user_pay: '-1',
              date_pay: '-1',
              client_pay: '-1',
              fact_num: '-1',
              is_manual: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<PaymentListeModel> videExcept = [
        PaymentListeModel(
            somme_pay: '-2',
            idcom_pay: '-2',
            id_pay: '-2',
            pay_type: '-2',
            user_pay: '-2',
            date_pay: '-2',
            client_pay: '-2',
            fact_num: '-2',
            is_manual: '-2')
      ];
      return videExcept;
    }
  }

  static List<PaymentListeModel> inventairepayListeResponse(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<PaymentListeModel>((json) => PaymentListeModel.fromJson(json))
        .toList();
  }

  // recuperrer les credits par dates
  static Future<List<CreditModel>> inventairecredit(
      String debut, String fin) async {
    var map = Map<String, dynamic>();
    map['debut'] = debut;
    map['fin'] = fin;
    map['table_name'] = 'credit';
    map['action'] = 'inventairecredit';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<CreditModel> catListe = inventairecreditResponse(response.body);
        return catListe;
      } else {
        List<CreditModel> vide = [
          CreditModel(
              nom: '-1',
              nume: '-1',
              paye: '-1',
              reste: '-1',
              dateCred: '-1',
              dateRem: '-1',
              idCre: '-1',
              agent: '-1',
              total_com: '-1',
              fact_num: '-1',
              is_manual: '-1',
              client_tel: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<CreditModel> videExcept = [
        CreditModel(
            nom: '-2',
            nume: '-2',
            paye: '-2',
            reste: '-2',
            dateCred: '-2',
            dateRem: '-2',
            idCre: '-2',
            agent: '-2',
            total_com: '-2',
            fact_num: '-2',
            is_manual: '-2',
            client_tel: '-1')
      ];
      return videExcept;
    }
  }

  static List<CreditModel> inventairecreditResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CreditModel>((json) => CreditModel.fromJson(json))
        .toList();
  }

  static Future<List<InventaireModel>> getInventaire(
      String dateDebut, String dateFin) async {
    var map = Map<String, dynamic>();
    map['action'] = 'inventaire';
    map['dateDebut'] = dateDebut;
    map['dateFin'] = dateFin;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<InventaireModel> rembListe = inventResponse(response.body);
        return rembListe;
      } else {
        List<InventaireModel> vide = [
          InventaireModel(
              date_inv: '-1',
              client: '-1',
              total: '-1',
              paye: '-1',
              reste: '-1',
              agent: '-1',
              is_print: '-1',
              is_deliver: '-1',
              id_com: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<InventaireModel> videExcept = [
        InventaireModel(
            date_inv: '-2',
            client: '-2',
            total: '-2',
            paye: '-2',
            reste: '-2',
            agent: '-2',
            is_print: '-2',
            is_deliver: '-2',
            id_com: '-2')
      ];
      return videExcept;
    }
  }

  static List<InventaireModel> inventResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<InventaireModel>((json) => InventaireModel.fromJson(json))
        .toList();
  }

  // Ajouter une boutique annexe
  static Future<String> addBoutique(
      String nom, String tel, String ville, String desc, String user) async {
    var map = Map<String, dynamic>();
    map['nom'] = nom;
    map['tel'] = tel;
    map['ville'] = ville;
    map['desc'] = desc;
    map['user'] = user;
    map['table_name'] = 'boutiqueannexe';
    map['action'] = 'addBoutique';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

// modifier une boutique annexe
  static Future<String> updBoutique(
      String nom, String tel, String ville, String desc, String idbout) async {
    var map = Map<String, dynamic>();
    map['nom'] = nom;
    map['tel'] = tel;
    map['ville'] = ville;
    map['desc'] = desc;
    map['idbout'] = idbout;
    map['table_name'] = 'boutiqueannexe';
    map['action'] = 'updBoutique';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  //Supprimer une boutique
  static Future<String> delBoutique(
    String idBou,
  ) async {
    var map = Map<String, dynamic>();
    map['idBou'] = idBou;
    map['table_name'] = 'boutiqueannexe';
    map['action'] = 'delBoutique';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Recuperation de liste des boutiques annexe
  static Future<List<AnnexeBoutModel>> getAnnexBou() async {
    var map = Map<String, dynamic>();
    map['action'] = 'getAnnexBou';
    map['table_name'] = 'boutiqueannexe';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<AnnexeBoutModel> boutListe = boutListeResponse(response.body);
        return boutListe;
      } else {
        List<AnnexeBoutModel> vide = [
          AnnexeBoutModel(
              nom_bout: '-1',
              tel_bout: '-1',
              date_bout: '-1',
              agent_bout: '-1',
              desc_bout: '-1',
              ville_bout: '-1',
              id_bout: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<AnnexeBoutModel> videExcept = [
        AnnexeBoutModel(
            nom_bout: '-2',
            tel_bout: '-2',
            date_bout: '-2',
            agent_bout: '-2',
            desc_bout: '-2',
            ville_bout: '-2',
            id_bout: '-2')
      ];
      return videExcept;
    }
  }

  static List<AnnexeBoutModel> boutListeResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<AnnexeBoutModel>((json) => AnnexeBoutModel.fromJson(json))
        .toList();
  }

  // Bon de sortie vers une boutique annexe
  static Future<String> createBon(
      String id_bout, String id_client, String user) async {
    var map = Map<String, dynamic>();
    map['id_bout'] = id_bout;
    map['id_client'] = id_client;
    map['user'] = user;
    map['table_name'] = 'bonsortie';
    map['action'] = 'createBon';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // recuperation de toute la liste des bons de sortie
  static Future<List<BonSortieModel>> getAllBonSortieInfos(String type) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'bonsortie';
    map['type'] = type;
    map['action'] = 'getAllBonSortieInfos';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        // print(response.body);
        List<BonSortieModel> ventInfoListe = bonAllInfoResponse(response.body);
        return ventInfoListe;
      } else {
        List<BonSortieModel> vide = [
          BonSortieModel(
            id_bon: '-1',
            agent_bon: '-1',
            id_bout_bon: '-1',
            is_print_bon: '-1',
            is_deliver_bon: '-1',
            nom_bon: '-1',
            date_bon: '-1',
            qts_bon: '-1',
            livraire_bon: '-1',
          )
        ];
        return vide;
      }
    } catch (e) {
      List<BonSortieModel> videExcept = [
        BonSortieModel(
          id_bon: '-2',
          agent_bon: '-2',
          id_bout_bon: '-2',
          is_print_bon: '-2',
          is_deliver_bon: '-2',
          nom_bon: '-2',
          date_bon: '-2',
          qts_bon: '-2',
          livraire_bon: '-2',
        )
      ];
      return videExcept;
    }
  }

  static List<BonSortieModel> bonAllInfoResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<BonSortieModel>((json) => BonSortieModel.fromJson(json))
        .toList();
  }

// recuperation de toute la liste des bons de sortie
  static Future<List<BonSortieModel>> getAllBonSortieInfosLimit(
      String type, String limit, String search) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'bonsortie';
    map['type'] = type;
    map['limit'] = limit;
    map['search'] = search;
    map['action'] = 'getAllBonSortieInfosLimit';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        // print(response.body);
        List<BonSortieModel> ventInfoListe =
            bonAllInfoLimitResponse(response.body);
        return ventInfoListe;
      } else {
        List<BonSortieModel> vide = [
          BonSortieModel(
            id_bon: '-1',
            agent_bon: '-1',
            id_bout_bon: '-1',
            is_print_bon: '-1',
            is_deliver_bon: '-1',
            nom_bon: '-1',
            date_bon: '-1',
            qts_bon: '-1',
            livraire_bon: '-1',
          )
        ];
        return vide;
      }
    } catch (e) {
      List<BonSortieModel> videExcept = [
        BonSortieModel(
          id_bon: '-2',
          agent_bon: '-2',
          id_bout_bon: '-2',
          is_print_bon: '-2',
          is_deliver_bon: '-2',
          nom_bon: '-2',
          date_bon: '-2',
          qts_bon: '-2',
          livraire_bon: '-2',
        )
      ];
      return videExcept;
    }
  }

  static List<BonSortieModel> bonAllInfoLimitResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<BonSortieModel>((json) => BonSortieModel.fromJson(json))
        .toList();
  }

  // recuperation des infos du bon de sortie
  static Future<List<BonInfoModel>> getBonSortieInfos(
      String id_bout, String type) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'bonsortie';
    map['action'] = 'getBonSortieInfos';
    map['id_bout'] = id_bout;
    map['type'] = type;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<BonInfoModel> ventInfoListe = bonInfoResponse(response.body);
        return ventInfoListe;
      } else {
        List<BonInfoModel> vide = [
          BonInfoModel(date_bon: '-1', bout_nom: '-1', bon_id: '-1')
        ];
        return vide;
      }
    } catch (e) {
      List<BonInfoModel> videExcept = [
        BonInfoModel(date_bon: '-2', bout_nom: '-2', bon_id: '-2')
      ];
      return videExcept;
    }
  }

  static List<BonInfoModel> bonInfoResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<BonInfoModel>((json) => BonInfoModel.fromJson(json))
        .toList();
  }

  // Envoyer le contenu du bon de sortie cote boutique
  static Future<String> sendBonList(
      String idProd, String qts, String idBon) async {
    // print('pro: ' + idProd + ' ' + 'idBon' + idBon + ' ' + 'Qts: ' + qts);
    var map = Map<String, dynamic>();
    map['idProd'] = idProd;
    map['qts'] = qts;
    map['idBon'] = idBon;
    map['table_name'] = 'contenubon';
    map['action'] = 'fill_bon';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Recuperation du contenu du bon
  static Future<List<ContenuBon>> getBonContent(
      String idBon, String type) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'bonsortie';
    map['action'] = 'getBonContent';
    map['idBon'] = idBon;
    map['type'] = type;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<ContenuBon> catListe = bonContentResponse(response.body);
        return catListe;
      } else {
        List<ContenuBon> vide = [
          ContenuBon(
              qts_ctn: '-1',
              id_prod_ctn: '-1',
              id_bout_ctn: '-1',
              id_bon_ctn: '-1',
              prod_nom_bon_ctn: '-1',
              qts_total_ctn: '-1',
              idClient: '-1')
        ];
        return vide;
      }
    } catch (e) {
      List<ContenuBon> videExcept = [
        ContenuBon(
            qts_ctn: '-2',
            id_prod_ctn: '-2',
            id_bout_ctn: '-2',
            id_bon_ctn: '-2',
            prod_nom_bon_ctn: '-2',
            qts_total_ctn: '-1',
            idClient: '-1')
      ];
      return videExcept;
    }
  }

  static List<ContenuBon> bonContentResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ContenuBon>((json) => ContenuBon.fromJson(json)).toList();
  }

  // supprimer un produits de la liste de bon de sortie
  static Future<String> deleteBonItem(
      String idProd, String idBon, String quantite) async {
    var map = Map<String, dynamic>();
    map['idProd'] = idProd;
    map['idBon'] = idBon;
    map['quantite'] = quantite;
    map['table_name'] = 'contenubon';
    map['action'] = 'deleteBonItem';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      print(e);
      return '-2';
    }
  }

//Supprimer toute le bon
  static Future<String> deleteBon(
    String idBon,
  ) async {
    var map = Map<String, dynamic>();
    map['idBon'] = idBon;
    map['table_name'] = 'bonsortie';
    map['action'] = 'deleteBon';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Impression de bon de sortie cote boutique
  static Future<String> noticeBonPrint(String idBon, String livraire) async {
    var map = Map<String, dynamic>();
    map['idBon'] = idBon;
    map['livraire'] = livraire;
    map['table_name'] = 'bonsortie';
    map['action'] = 'noticeBonPrint';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Ajouterle numero de transfert du paiement
  static Future<String> addPayNumber(
      String idCom, String tel, String user) async {
    var map = Map<String, dynamic>();
    map['idCom'] = idCom;
    map['tel'] = tel;
    map['user'] = user;
    map['table_name'] = 'numeropay';
    map['action'] = 'addPayNumber';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // get vente Infos for bon de livraison cote client
  static Future<List<VenteInfos>> getVenteInfosForBon(String idCom) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'commande';
    map['action'] = 'getVenteInfosForBon';
    map['idCom'] = idCom;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<VenteInfos> ventInfoListe = venteInfoForBonResponse(response.body);
        return ventInfoListe;
      } else {
        List<VenteInfos> vide = [
          VenteInfos(dateVente: '-1', clientName: '-1', venteId: '-1')
        ];
        return vide;
      }
    } catch (e) {
      List<VenteInfos> videExcept = [
        VenteInfos(dateVente: '-2', clientName: '-2', venteId: '-2')
      ];
      return videExcept;
    }
  }

  static List<VenteInfos> venteInfoForBonResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<VenteInfos>((json) => VenteInfos.fromJson(json)).toList();
  }

  // ajout de la somme payer par un bon client
  static Future<String> addBonClientPay(
      String idCom, String idBon, String somme, String user) async {
    var map = Map<String, dynamic>();
    map['idCom'] = idCom;
    map['idBon'] = idBon;
    map['somme'] = somme;
    map['user'] = user;
    map['table_name'] = 'reviewfactu';
    map['action'] = 'addBonClientPay';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // Update la somme payer par un bon client
  static Future<String> updBonClientPay(String idBon, String somme) async {
    var map = Map<String, dynamic>();
    map['idBon'] = idBon;
    map['somme'] = somme;
    map['table_name'] = 'reviewfactu';
    map['action'] = 'updBonClientPay';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // recupere la somme payer par un bon client
  static Future<String> getBonClientPay(String idBon) async {
    var map = Map<String, dynamic>();
    map['idBon'] = idBon;
    map['table_name'] = 'reviewfactu';
    map['action'] = 'getBonClientPay';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // recuperer idBon pour les bon de sortie cote client
  static Future<String> getClientIdBon(String idClient, String type) async {
    var map = Map<String, dynamic>();
    map['idClient'] = idClient;
    map['type'] = type;
    map['table_name'] = 'bonsortie';
    map['action'] = 'getClientIdBon';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // recuperer le numero de paiement
  static Future<String> getpayNumber(String idCom) async {
    var map = Map<String, dynamic>();
    map['idCom'] = idCom;
    map['table_name'] = 'numeropay';
    map['action'] = 'getpayNumber';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        Map data = {'status': '200', 'data': json.decode(response.body)};
        return json.encode(data);
      } else {
        Map data = {
          'status': '400',
          'data': json.decode({"statut": -1}.toString()),
        };
        return json.encode(data);
      }
    } catch (e) {
      Map data = {
        'status': '400',
        'data': json.decode({"statut": -2}.toString()),
      };
      return json.encode(data);
    }
  }

  // Verification de compte de versement
  static Future<String> checkVersement(
      String id_cpt, String totalPay, String idCom, String idUser) async {
    var map = Map<String, dynamic>();
    map['id_cpt'] = id_cpt;
    map['totalPay'] = totalPay;
    map['idCom'] = idCom;
    map['table_name'] = 'sortiecompte';
    map['action'] = 'checkVersement';
    map['idUser'] = idUser;
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }

  // recuperation des versements
  static Future<List<TrackCpt>> getTrackVersement(String id_cpt) async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'sortiecompte';
    map['id_cpt'] = id_cpt;
    map['action'] = 'getTrackVersement';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<TrackCpt> catListe = trackAchatResponse(response.body);
        return catListe;
      } else {
        List<TrackCpt> vide = [
          TrackCpt(idCom: '-1', dateCom: '-1', agent: '-1', somme: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<TrackCpt> videExcept = [
        TrackCpt(idCom: '-2', dateCom: '-2', agent: '-2', somme: '-2'),
      ];
      return videExcept;
    }
  }

  static List<TrackCpt> trackAchatResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TrackCpt>((json) => TrackCpt.fromJson(json)).toList();
  }

  // Ajout d'un  produit use
  static Future<String> addProduitUse(
      String idProd, String prix, String qts, String desc, String user) async {
    var map = Map<String, dynamic>();
    map['idProd'] = idProd;
    map['prix'] = prix;
    map['qts'] = qts;
    map['desc'] = desc;
    map['user'] = user;
    map['table_name'] = 'produit_uses';
    map['action'] = 'addProduitUse';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

  // recuperation de la liste des produits usés
  static Future<List<ProduitUseModel>> getProdutsUse() async {
    var map = Map<String, dynamic>();
    map['table_name'] = 'produit_uses';
    map['action'] = 'getProdutsUse';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        List<ProduitUseModel> catListe = produitUseResponse(response.body);
        return catListe;
      } else {
        List<ProduitUseModel> vide = [
          ProduitUseModel(
              designation: '-1',
              categorie: '-1',
              prix: '-1',
              date: '-1',
              desc: '-1',
              qts: '-1',
              agent: '-1',
              id: '-1',
              idCat: '-1',
              idProd: '-1')
        ];
        return vide;
      }
    } catch (e) {
      print(e);
      List<ProduitUseModel> videExcept = [
        ProduitUseModel(
            designation: '-2',
            categorie: '-2',
            prix: '-2',
            date: '-2',
            desc: '-2',
            qts: '-2',
            agent: '-2',
            id: '-2',
            idCat: '-2',
            idProd: '-2'),
      ];
      return videExcept;
    }
  }

  static List<ProduitUseModel> produitUseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ProduitUseModel>((json) => ProduitUseModel.fromJson(json))
        .toList();
  }

  // modification d'un  produit use
  static Future<String> modifyProduitUse(String idProd, String prix, String qts,
      String desc, String user, String id_prod_use) async {
    var map = Map<String, dynamic>();
    map['idProd'] = idProd;
    map['prix'] = prix;
    map['qts'] = qts;
    map['desc'] = desc;
    map['id_prod_use'] = id_prod_use;
    map['user'] = user;
    map['table_name'] = 'produit_uses';
    map['action'] = 'modifyProduitUse';

    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return "-2";
    }
  }

  //Supprimer toute le bon
  static Future<String> deleteProduitUse(
    String idProdUse,
  ) async {
    var map = Map<String, dynamic>();
    map['idProdUse'] = idProdUse;
    map['table_name'] = 'produit_uses';
    map['action'] = 'deleteProduitUse';
    try {
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print(response.body);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return '-1';
      }
    } catch (e) {
      return '-2';
    }
  }
}
