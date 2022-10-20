// ignore_for_file: non_constant_identifier_names

class CompteVersementModel {
  final String id_cpt;
  final String id_client;
  final String client_cpt;
  final String date_cpt;
  final String etat_cpt;
  final String somme_cpt;
  final String agent_cpt;
  final String tel_cpt;
  CompteVersementModel({
    required this.id_cpt,
    required this.id_client,
    required this.client_cpt,
    required this.date_cpt,
    required this.etat_cpt,
    required this.somme_cpt,
    required this.agent_cpt,
    required this.tel_cpt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_cpt': id_cpt.toString(),
      'client_cpt': client_cpt.toString(),
      'date_cpt': date_cpt.toString(),
      'etat_cpt': etat_cpt.toString(),
      'somme_cpt': somme_cpt.toString(),
      'agent_cpt': agent_cpt.toString(),
      'tel_cpt': tel_cpt.toString(),
    };
  }

  factory CompteVersementModel.fromJson(Map<String, dynamic> json) {
    return CompteVersementModel(
      id_cpt: json['id_cpt'].toString(),
      client_cpt: json['client_cpt'].toString(),
      date_cpt: json['date_cpt'].toString(),
      etat_cpt: json['etat_cpt'].toString(),
      somme_cpt: json['somme_cpt'].toString(),
      agent_cpt: json['agent_cpt'].toString(),
      tel_cpt: json['tel_cpt'].toString(),
      id_client: json['id_client'].toString(),
    );
  }
}
