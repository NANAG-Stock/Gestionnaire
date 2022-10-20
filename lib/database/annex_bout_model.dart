// ignore_for_file: non_constant_identifier_names

class AnnexeBoutModel {
  final String nom_bout;
  final String tel_bout;
  final String date_bout;
  final String agent_bout;
  final String desc_bout;
  final String ville_bout;
  final String id_bout;
  AnnexeBoutModel({
    required this.nom_bout,
    required this.tel_bout,
    required this.date_bout,
    required this.agent_bout,
    required this.desc_bout,
    required this.ville_bout,
    required this.id_bout,
  });

  Map<String, dynamic> toMap() {
    return {
      'nom_bout': nom_bout.toString(),
      'tel_bout': tel_bout.toString(),
      'date_bout': date_bout.toString(),
      'agent_bout': agent_bout.toString(),
      'desc_bout': desc_bout.toString(),
      'ville_bout': ville_bout.toString(),
      'id_bout': id_bout.toString(),
    };
  }

  factory AnnexeBoutModel.fromJson(Map<String, dynamic> json) {
    return AnnexeBoutModel(
      nom_bout: json['nom_bout'].toString(),
      tel_bout: json['tel_bout'].toString(),
      date_bout: json['date_bout'].toString(),
      agent_bout: json['agent_bout'].toString(),
      desc_bout: json['desc_bout'].toString(),
      ville_bout: json['ville_bout'].toString(),
      id_bout: json['id_bout'].toString(),
    );
  }
}
