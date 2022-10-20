// ignore_for_file: non_constant_identifier_names

class FournisseurProduct {
  final String designation;
  final String prix;
  final String prod_date;
  final String categorie;
  final String fournisseur;
  final String quantite;
  final String type;
  final String tel_four;
  final String id_four;

  FournisseurProduct({
    required this.designation,
    required this.prix,
    required this.prod_date,
    required this.categorie,
    required this.fournisseur,
    required this.quantite,
    required this.type,
    required this.tel_four,
    required this.id_four,
  });

  Map<String, dynamic> toMap() {
    return {
      'designation': designation.toString(),
      'prix': prix.toString(),
      'prod_date': prod_date.toString(),
      'categorie': categorie.toString(),
      'fournisseur': fournisseur.toString(),
      'quantite': quantite.toString(),
      'tel_four': tel_four.toString(),
      'type': type.toString(),
      'id_four': id_four.toString(),
    };
  }

  factory FournisseurProduct.fromJson(Map<String, dynamic> json) {
    return FournisseurProduct(
      designation: json['designation'].toString(),
      prix: json['prix'].toString(),
      prod_date: json['prod_date'].toString(),
      categorie: json['categorie'].toString(),
      fournisseur: json['fournisseur'].toString(),
      quantite: json['quantite'].toString(),
      tel_four: json['tel_four'].toString(),
      type: json['type'].toString(),
      id_four: json['id_four'].toString(),
    );
  }
}
