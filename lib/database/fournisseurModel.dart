// ignore_for_file: file_names
class FournisseurModel {
  final String idFour;
  final String nomFour;
  final String dateFour;
  final String userFour;
  final String typeFour;
  final String addressFour;
  final String villeFour;
  final String paysFour;
  final String telFour;
  final String codePosFour;
  final String emailFour;
  final String fourCNIB;
  final String fourDesc;

  FournisseurModel({
    required this.idFour,
    required this.nomFour,
    required this.dateFour,
    required this.userFour,
    required this.typeFour,
    required this.addressFour,
    required this.villeFour,
    required this.paysFour,
    required this.telFour,
    required this.codePosFour,
    required this.emailFour,
    required this.fourCNIB,
    required this.fourDesc,
  });

  Map<String, dynamic> toMap() {
    return {
      'idFour': idFour.toString(),
      'nomFour': nomFour.toString(),
      'dateFour': dateFour.toString(),
      'userFour': userFour.toString(),
      'typeFour': typeFour.toString(),
      'addressFour': addressFour.toString(),
      'villeFour': villeFour.toString(),
      'paysFour': paysFour.toString(),
      'telFour': telFour.toString(),
      'codePosFour': codePosFour.toString(),
      'emailFour': emailFour.toString(),
    };
  }

  factory FournisseurModel.fromJson(Map<String, dynamic> json) {
    return FournisseurModel(
      idFour: json['Id_four'].toString(),
      nomFour: json['Nom_four'].toString(),
      dateFour: json['Date_four'].toString(),
      userFour: json['userFour'].toString(),
      typeFour: json['type_four'].toString(),
      addressFour: json['adress_four'].toString(),
      villeFour: json['ville_four'].toString(),
      paysFour: json['Pays_four'].toString(),
      telFour: json['tel_four'].toString(),
      codePosFour: json['codePost_four'].toString(),
      emailFour: json['email_four'].toString(),
      fourCNIB: json['four_cnib'].toString(),
      fourDesc: json['four_desc'].toString(),
    );
  }
}
