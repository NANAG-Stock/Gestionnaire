// ignore_for_file: file_names, non_constant_identifier_names

class ClientModel {
  final String id_client;
  final String type_client;
  final String nom_complet_client;
  final String cnib_client;
  final String date_client;
  final String tel_client;
  final String adress_client;
  final String user_client;
  final String ville_client;
  final String desc_client;

  ClientModel({
    required this.id_client,
    required this.type_client,
    required this.nom_complet_client,
    required this.cnib_client,
    required this.date_client,
    required this.tel_client,
    required this.adress_client,
    required this.user_client,
    required this.ville_client,
    required this.desc_client,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_client': id_client.toString(),
      'type_client': type_client.toString(),
      'nom_complet_client': nom_complet_client.toString(),
      'cnib_client': cnib_client.toString(),
      'date_client': date_client.toString(),
      'tel_client': tel_client.toString(),
      'adress_client': adress_client.toString(),
    };
  }

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id_client: json['id_client'].toString(),
      type_client: json['type_client'].toString(),
      nom_complet_client: json['nom_complet_client'].toString(),
      cnib_client: json['cnib_client'].toString(),
      date_client: json['date_client'].toString(),
      tel_client: json['tel_client'].toString(),
      adress_client: json['adress_client'].toString(),
      user_client: json['user'].toString(),
      ville_client: json['ville_client'].toString(),
      desc_client: json['desc_client'].toString(),
    );
  }
}
