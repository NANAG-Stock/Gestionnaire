// ignore_for_file: file_names, non_constant_identifier_names
class SalaireModel {
  final String saId;
  final String saVal;
  final String saUser;
  final String del_sa;
  final String date_sa;

  SalaireModel({
    required this.saId,
    required this.saVal,
    required this.saUser,
    required this.del_sa,
    required this.date_sa,
  });

  Map<String, dynamic> toMap() {
    return {
      'saId': saId.toString(),
      'saVal': saVal.toString(),
      'saUser': saUser.toString(),
      'del_sa': del_sa.toString(),
    };
  }

  factory SalaireModel.fromJson(Map<String, dynamic> json) {
    return SalaireModel(
      saId: json['id_sa'].toString(),
      saVal: json['val_sa'].toString(),
      saUser: json['user_sa'].toString(),
      del_sa: json['del_sa'].toString(),
      date_sa: json['date_sa'].toString(),
    );
  }
}
