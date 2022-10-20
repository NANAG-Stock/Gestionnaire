// ignore_for_file: file_names, non_constant_identifier_names

class CreditModel {
  final String idCre;
  final String nom;
  final String total_com;
  final String nume;
  final String paye;
  final String reste;
  final String dateCred;
  final String dateRem;
  final String agent;
  final String is_manual;
  final String fact_num;
  final String client_tel;
  CreditModel({
    required this.idCre,
    required this.nom,
    required this.total_com,
    required this.nume,
    required this.paye,
    required this.reste,
    required this.dateCred,
    required this.dateRem,
    required this.agent,
    required this.is_manual,
    required this.fact_num,
    required this.client_tel,
  });

  Map<String, dynamic> toMap() {
    return {
      'nom': nom.toString(),
      'nume': nume.toString(),
      'paye': paye.toString(),
      'reste': reste.toString(),
      'dateCred': dateCred.toString(),
      'dateRem': dateRem.toString(),
    };
  }

  factory CreditModel.fromJson(Map<String, dynamic> json) {
    return CreditModel(
      nom: json['nom'].toString(),
      nume: json['nume'].toString(),
      paye: json['paye'].toString(),
      reste: json['reste'].toString(),
      dateCred: json['dateCred'].toString(),
      dateRem: json['dateRem'].toString(),
      idCre: json['idCred'].toString(),
      agent: json['agent'].toString(),
      total_com: json['total_com'].toString(),
      is_manual: json['is_manual'].toString(),
      fact_num: json['fact_num'].toString(),
      client_tel: json['client_tel'].toString(),
    );
  }
}
