// ignore_for_file: non_constant_identifier_names
class ContenuBon {
  String qts_ctn;
  String qts_total_ctn;
  String id_prod_ctn;
  String id_bout_ctn;
  String id_bon_ctn;
  String idClient;
  String prod_nom_bon_ctn;
  ContenuBon({
    required this.qts_ctn,
    required this.qts_total_ctn,
    required this.id_prod_ctn,
    required this.id_bout_ctn,
    required this.id_bon_ctn,
    required this.idClient,
    required this.prod_nom_bon_ctn,
  });
  Map<String, dynamic> toMap() {
    return {
      'qts_ctn': qts_ctn.toString(),
      'id_prod_ctn': id_prod_ctn.toString(),
      'id_bon_ctn': id_bon_ctn.toString(),
    };
  }

  factory ContenuBon.fromJson(Map<String, dynamic> json) {
    return ContenuBon(
      qts_ctn: json['qts_ctn'].toString(),
      id_prod_ctn: json['id_prod_ctn'].toString(),
      id_bon_ctn: json['id_bon_ctn'].toString(),
      prod_nom_bon_ctn: json['prod_nom_bon_ctn'].toString(),
      qts_total_ctn: json['qts_total_ctn'].toString(),
      id_bout_ctn: json['id_bout_ctn'].toString(),
      idClient: json['idClient'].toString(),
    );
  }
}
