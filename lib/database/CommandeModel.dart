// ignore_for_file: file_names

class CommandeModel {
  final String idCom;
  final String fourId;
  final String fourNom;
  final String nbrProd;
  final String prixTotal;
  final String comDate;
  final String comEtat;
  final String user;

  CommandeModel({
    required this.idCom,
    required this.fourId,
    required this.fourNom,
    required this.nbrProd,
    required this.prixTotal,
    required this.comDate,
    required this.comEtat,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'idCom': idCom.toString(),
      'fourId': fourId.toString(),
      'fourNom': fourNom.toString(),
      'nbrProd': nbrProd.toString(),
      'prixTotal': prixTotal.toString(),
      'comDate': comDate.toString(),
      'comEtat': comEtat.toString(),
    };
  }

  factory CommandeModel.fromJson(Map<String, dynamic> json) {
    return CommandeModel(
      idCom: json['idCom'].toString(),
      fourId: json['fourId'].toString(),
      fourNom: json['fourNom'].toString(),
      nbrProd: json['nbrProd'].toString(),
      prixTotal: json['prixTotal'].toString(),
      comDate: json['comDate'].toString(),
      comEtat: json['comEtat'].toString(),
      user: json['user'].toString(),
    );
  }
}
