// ignore: file_names
// ignore_for_file: non_constant_identifier_names
class VersementModel {
  final String id_vers;
  final String somme_vers;
  final String date_vers;
  final String user_vers;
  final String nom_vers;
  final String cnib_vers;
  final String tel_vers;
  final String is_active_vers;
  VersementModel({
    required this.id_vers,
    required this.somme_vers,
    required this.date_vers,
    required this.user_vers,
    required this.nom_vers,
    required this.cnib_vers,
    required this.tel_vers,
    required this.is_active_vers,
  });

  Map<String, dynamic> tojson() {
    return {
      'id_vers': id_vers.toString(),
      'somme_vers': somme_vers.toString(),
      'date_vers': date_vers.toString(),
      'user_vers': user_vers.toString(),
      'nom_vers': nom_vers.toString(),
      'cnib_vers': cnib_vers.toString(),
      'tel_vers': tel_vers.toString(),
    };
  }

  factory VersementModel.fromJson(Map<String, dynamic> json) {
    return VersementModel(
      id_vers: json['id_vers'].toString(),
      somme_vers: json['somme_vers'].toString(),
      date_vers: json['date_vers'].toString(),
      user_vers: json['user_vers'].toString(),
      nom_vers: json['nom_vers'].toString(),
      cnib_vers: json['cnib_vers'].toString(),
      tel_vers: json['tel_vers'].toString(),
      is_active_vers: json['is_active_vers'].toString(),
    );
  }
}
