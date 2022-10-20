class ProduitUseModel {
  final String id;
  final String designation;
  final String categorie;
  final String prix;
  final String date;
  final String desc;
  final String qts;
  final String agent;
  final String idProd;
  final String idCat;

  ProduitUseModel(
      {required this.designation,
      required this.idProd,
      required this.idCat,
      required this.categorie,
      required this.id,
      required this.prix,
      required this.date,
      required this.desc,
      required this.qts,
      required this.agent});

  Map<String, dynamic> toMap() {
    return {
      'designation': designation.toString(),
      'categorie': categorie.toString(),
      'prix': prix.toString(),
      'date': date.toString(),
      'desc': date.toString(),
      'qts': date.toString(),
      'agent': agent.toString(),
      'id': id.toString(),
    };
  }

  factory ProduitUseModel.fromJson(Map<String, dynamic> json) {
    return ProduitUseModel(
      designation: json['designation'].toString(),
      agent: json['agent'].toString(),
      prix: json['prix'].toString(),
      categorie: json['categorie'].toString(),
      date: json['date'].toString(),
      desc: json['desc'].toString(),
      qts: json['qts'].toString(),
      id: json['id'].toString(),
      idCat: json['idCat'].toString(),
      idProd: json['idProd'].toString(),
    );
  }
}
