// ignore_for_file: non_constant_identifier_names

class BonSortieModel {
  final String id_bon;
  final String agent_bon;
  final String id_bout_bon;
  final String qts_bon;
  final String is_print_bon;
  final String is_deliver_bon;
  final String nom_bon;
  final String date_bon;
  final String livraire_bon;
  BonSortieModel({
    required this.id_bon,
    required this.agent_bon,
    required this.id_bout_bon,
    required this.qts_bon,
    required this.is_print_bon,
    required this.is_deliver_bon,
    required this.nom_bon,
    required this.date_bon,
    required this.livraire_bon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_bon': id_bon.toString(),
      'agent_bon': agent_bon.toString(),
      'id_bout_bon': id_bout_bon.toString(),
      'is_print_bon': is_print_bon.toString(),
      'is_deliver_bon': is_deliver_bon.toString(),
    };
  }

  factory BonSortieModel.fromJson(Map<String, dynamic> json) {
    return BonSortieModel(
      id_bon: json['id_bon'].toString(),
      agent_bon: json['agent_bon'].toString(),
      id_bout_bon: json['id_bout_bon'].toString(),
      is_print_bon: json['is_print_bon'].toString(),
      is_deliver_bon: json['is_deliver_bon'].toString(),
      nom_bon: json['nom_bon'].toString(),
      date_bon: json['date_bon'].toString(),
      qts_bon: json['qts_bon'].toString(),
      livraire_bon: json['livraire_bon'].toString(),
    );
  }
}
