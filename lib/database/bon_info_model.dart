// ignore_for_file: non_constant_identifier_names

class BonInfoModel {
  final String date_bon;
  final String bout_nom;
  final String bon_id;
  BonInfoModel({
    required this.date_bon,
    required this.bout_nom,
    required this.bon_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'date_bon': date_bon.toString(),
      'bout_id': bout_nom.toString(),
      'bon_id': bon_id.toString(),
    };
  }

  factory BonInfoModel.fromJson(Map<String, dynamic> json) {
    return BonInfoModel(
      date_bon: json['date_bon'].toString(),
      bout_nom: json['bout_nom'].toString(),
      bon_id: json['bon_id'].toString(),
    );
  }
}
