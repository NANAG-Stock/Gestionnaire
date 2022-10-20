// ignore_for_file: non_constant_identifier_names

class DepenseModel {
  final String id_dep;
  final String date_dep;
  final String prix_dep;
  final String raison_dep;
  final String id_user;
  final String etat;
  DepenseModel({
    required this.id_dep,
    required this.date_dep,
    required this.prix_dep,
    required this.raison_dep,
    required this.id_user,
    required this.etat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_dep': id_dep.toString(),
      'date_dep': date_dep.toString(),
      'prix_dep': prix_dep.toString(),
      'raison_dep': raison_dep.toString(),
      'id_user': id_user.toString(),
    };
  }

  factory DepenseModel.fromJson(Map<String, dynamic> json) {
    return DepenseModel(
      id_dep: json['id_dep'].toString(),
      date_dep: json['date_dep'].toString(),
      prix_dep: json['prix_dep'].toString(),
      raison_dep: json['raison_dep'].toString(),
      id_user: json['id_user'].toString(),
      etat: json['etat'].toString(),
    );
  }
}
