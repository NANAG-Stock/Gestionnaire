// ignore_for_file: non_constant_identifier_names

class Product {
  final String designation;
  final String description;
  final String prix;
  final String prod_date;
  final String promo;
  final String id_cat;
  final String id_user;
  final String id_prod;
  final String status;
  final String stock;

  Product({
    required this.designation,
    required this.description,
    required this.prix,
    required this.prod_date,
    required this.promo,
    required this.id_cat,
    required this.id_user,
    required this.id_prod,
    required this.status,
    required this.stock,
  });

  Map<String, dynamic> toMap() {
    return {
      'designation': designation.toString(),
      'description': description.toString(),
      'prix': prix.toString(),
      'promo': promo.toString(),
      'id_cat': id_cat.toString(),
      'id_user': id_user.toString(),
      'id_prod': id_prod.toString(),
      'prod_date': prod_date.toString(),
      'status': status.toString(),
      'stock': stock.toString()
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      designation: json['Nom_pro'].toString(),
      description: json['Describe_pro'].toString(),
      prix: json['Prix_pro'].toString(),
      promo: json['Reduice_pro'].toString(),
      id_cat: json['Id_cat'].toString(),
      id_user: json['Id_user'].toString(),
      id_prod: json['Id_pro'].toString(),
      prod_date: json['Date_pro'].toString(),
      status: json['Is_delete_prod'].toString(),
      stock: json['stock'].toString(),
    );
  }
}
