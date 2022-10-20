// ignore: file_names
// ignore_for_file: non_constant_identifier_names

class VirementModel {
  final String id_vire;
  final String nom_compte;
  final String num_compte;
  final String banq_nom;
  final String agent;
  final String somme;
  final String date_vire;
  final String desc_vire;
  final String process;
  VirementModel({
    required this.id_vire,
    required this.nom_compte,
    required this.num_compte,
    required this.banq_nom,
    required this.agent,
    required this.somme,
    required this.date_vire,
    required this.desc_vire,
    required this.process,
  });

  Map<String, dynamic> toMap() {
    return {
      'nom_compte': nom_compte.toString(),
      'num_compte': num_compte.toString(),
      'banq_nom': banq_nom.toString(),
      'agent': agent.toString(),
      'somme': somme.toString(),
      'date_vire': date_vire.toString(),
    };
  }

  factory VirementModel.fromJson(Map<String, dynamic> json) {
    return VirementModel(
      nom_compte: json['nom_compte'].toString(),
      num_compte: json['num_compte'].toString(),
      banq_nom: json['banq_nom'].toString(),
      agent: json['agent'].toString(),
      somme: json['somme'].toString(),
      date_vire: json['date_vire'].toString(),
      id_vire: json['id_vire'].toString(),
      desc_vire: json['desc_vire'].toString(),
      process: json['process'].toString(),
    );
  }
}
