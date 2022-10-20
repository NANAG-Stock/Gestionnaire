// ignore_for_file: non_constant_identifier_names

class CompanyModel {
  final String id;
  final String nom_com;
  final String tel_com;
  final String logo_com;
  final String slogan_com;
  final String email_com;
  final String tel2_com;
  final String adress;
  final String tel3_com;

  CompanyModel({
    required this.id,
    required this.nom_com,
    required this.tel_com,
    required this.logo_com,
    required this.slogan_com,
    required this.email_com,
    required this.tel2_com,
    required this.adress,
    required this.tel3_com,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom_com': nom_com.toString(),
      'tel_com': tel_com.toString(),
      'logo_com': logo_com.toString(),
      'slogan_com': slogan_com.toString(),
      'email_com': email_com.toString(),
      'tel2_com': tel2_com.toString(),
      'tel3_com': tel3_com.toString(),
    };
  }

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'].toString(),
      nom_com: json['nom_com'].toString(),
      tel_com: json['tel_com'].toString(),
      logo_com: json['logo_com'].toString(),
      slogan_com: json['slogan_com'].toString(),
      email_com: json['email_com'].toString(),
      tel2_com: json['tel2_com'].toString(),
      tel3_com: json['tel3_com'].toString(),
      adress: json['adress'].toString(),
    );
  }
}

class LogoCompany {
  final String sigle;
  final String compName;
  final String adresse;

  LogoCompany(this.sigle, this.compName, this.adresse);
}

class CommandeDetaile {
  final String factureNum;
  final String factureDate;
  final List<String> payType;

  CommandeDetaile({
    required this.factureNum,
    required this.factureDate,
    required this.payType,
  });
}

class ClientAdress {
  final String name;
  final String adresse;

  ClientAdress({
    required this.name,
    required this.adresse,
  });
}

class ResumerFacture {
  final String total;
  final String paye;
  final String rest;

  ResumerFacture({
    required this.total,
    required this.paye,
    required this.rest,
  });
}

class CommandeContent {
  final String designation;
  final String quantite;
  final String unitPrix;
  final String total;

  CommandeContent({
    required this.designation,
    required this.quantite,
    required this.unitPrix,
    required this.total,
  });
}
