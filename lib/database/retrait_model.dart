// ignore: file_names
// ignore_for_file: non_constant_identifier_names

class RetraitModel {
  final String id_ret;
  final String nom_compte;
  final String num_compte;
  final String banq_nom;
  final String agent;
  final String somme;
  final String date_vire;
  final String desc_re;
  final String process;
  final String id_com;
  final String fact_num;
  RetraitModel({
    required this.id_ret,
    required this.nom_compte,
    required this.num_compte,
    required this.banq_nom,
    required this.agent,
    required this.somme,
    required this.date_vire,
    required this.desc_re,
    required this.process,
    required this.id_com,
    required this.fact_num,
  });

  Map<String, dynamic> toMap() {
    return {
      'nom_compte': nom_compte.toString().toString(),
      'num_compte': num_compte.toString().toString(),
      'banq_nom': banq_nom.toString().toString(),
      'agent': agent.toString().toString(),
      'somme': somme.toString().toString(),
      'date_vire': date_vire.toString().toString(),
    };
  }

  factory RetraitModel.fromJson(Map<String, dynamic> json) {
    return RetraitModel(
      nom_compte: json['nom_compte'].toString(),
      num_compte: json['num_compte'].toString(),
      banq_nom: json['banq_nom'].toString(),
      agent: json['agent'].toString(),
      somme: json['somme'].toString(),
      date_vire: json['date_vire'].toString(),
      id_ret: json['id_ret'].toString(),
      desc_re: json['desc_re'].toString(),
      process: json['process'].toString(),
      id_com: json['id_com'],
      fact_num: json['fact_num'].toString(),
    );
  }
}
