// ignore_for_file: file_names

class CategorieModel {
  final String catId;
  final String catName;
  final String catDate;
  final String cateDel;
  final String catUser;

  CategorieModel({
    required this.catId,
    required this.catName,
    required this.catDate,
    required this.cateDel,
    required this.catUser,
  });

  Map<String, dynamic> toMap() {
    return {
      'catId': catId.toString(),
      'catName': catName.toString(),
      'catDate': catDate.toString(),
      'cateDel': cateDel.toString(),
      'catUser': catUser.toString(),
    };
  }

  factory CategorieModel.fromJson(Map<String, dynamic> json) {
    return CategorieModel(
      catId: json['Id_cat'].toString(),
      catName: json['Nom_cat'].toString(),
      catDate: json['Date_Cat'].toString(),
      cateDel: json['Is_delete_cat'].toString(),
      catUser: json['Id_user_cat'].toString(),
    );
  }
}
