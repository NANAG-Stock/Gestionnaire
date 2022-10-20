// ignore_for_file: file_names, non_constant_identifier_names
class VenteModel {
  final String idCom;
  final String idClient;
  final String clientName;
  final String nbrProd;
  final String prixTotal;
  final String comDate;
  final String comEtat;
  final String user;
  final String is_print_com;
  final String is_deliver_com;

  VenteModel({
    required this.idCom,
    required this.idClient,
    required this.clientName,
    required this.nbrProd,
    required this.prixTotal,
    required this.comDate,
    required this.comEtat,
    required this.user,
    required this.is_print_com,
    required this.is_deliver_com,
  });
  Map<String, dynamic> toMap() {
    return {
      'idCom': idCom.toString(),
      'idClient': idClient.toString(),
      'clientName': clientName.toString(),
      'nbrProd': nbrProd.toString(),
      'prixTotal': prixTotal.toString(),
      'comDate': comDate.toString(),
      'comEtat': comEtat.toString(),
    };
  }

  factory VenteModel.fromJson(Map<String, dynamic> json) {
    return VenteModel(
      idCom: json['idCom'].toString(),
      idClient: json['idClient'].toString(),
      clientName: json['clientName'].toString(),
      nbrProd: json['nbrProd'].toString(),
      prixTotal: json['prixTotal'].toString(),
      comDate: json['comDate'].toString(),
      comEtat: json['comEtat'].toString(),
      user: json['user'].toString(),
      is_deliver_com: json['is_deliver_com'].toString(),
      is_print_com: json['is_print_com'].toString(),
    );
  }
}
