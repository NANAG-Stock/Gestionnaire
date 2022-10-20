// ignore_for_file: non_constant_identifier_names

class RembourModel {
  final String id_rem;
  final String date_rem;
  final String nom_rem;
  final String card_id_rem;
  final String tel_rem;
  final String id_user_rem;
  final String montant_pay_rem;
  final String pay_type;
  final String numero;
  final String is_valid;
  RembourModel({
    required this.id_rem,
    required this.date_rem,
    required this.nom_rem,
    required this.card_id_rem,
    required this.tel_rem,
    required this.id_user_rem,
    required this.montant_pay_rem,
    required this.pay_type,
    required this.numero,
    required this.is_valid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_rem': id_rem.toString(),
      'date_rem': date_rem.toString(),
      'nom_rem': nom_rem.toString(),
      'card_id_rem': card_id_rem.toString(),
      'tel_rem': tel_rem.toString(),
      'user_rem': id_user_rem.toString(),
      'montant_pay_rem': montant_pay_rem.toString(),
      'is_valid': is_valid.toString(),
    };
  }

  factory RembourModel.fromJson(Map<String, dynamic> json) {
    return RembourModel(
      id_rem: json['id_rem'].toString(),
      date_rem: json['date_rem'].toString(),
      nom_rem: json['nom_rem'].toString(),
      card_id_rem: json['card_id_rem'].toString(),
      tel_rem: json['tel_rem'].toString(),
      id_user_rem: json['id_user_rem'].toString(),
      montant_pay_rem: json['montant_pay_rem'].toString(),
      numero: json['numero'].toString(),
      pay_type: json['pay_type'].toString(),
      is_valid: json['is_valid'].toString(),
    );
  }
}
