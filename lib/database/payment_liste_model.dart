// ignore_for_file: non_constant_identifier_names

class PaymentListeModel {
  final String somme_pay;
  final String idcom_pay;
  final String client_pay;
  final String id_pay;
  final String pay_type;
  final String user_pay;
  final String date_pay;
  final String is_manual;
  final String fact_num;
  PaymentListeModel({
    required this.somme_pay,
    required this.idcom_pay,
    required this.client_pay,
    required this.id_pay,
    required this.pay_type,
    required this.user_pay,
    required this.date_pay,
    required this.is_manual,
    required this.fact_num,
  });

  Map<String, dynamic> toMap() {
    return {
      'somme_pay': somme_pay.toString(),
      'idcom_pay': idcom_pay.toString(),
      'id_pay': id_pay.toString(),
      'pay_type': pay_type.toString(),
      'user_pay': user_pay.toString(),
      'date_pay': date_pay.toString(),
    };
  }

  factory PaymentListeModel.fromJson(Map<String, dynamic> json) {
    return PaymentListeModel(
      somme_pay: json['somme_pay'].toString(),
      idcom_pay: json['idcom_pay'].toString(),
      id_pay: json['id_pay'].toString(),
      pay_type: json['pay_type'].toString(),
      user_pay: json['user_pay'].toString(),
      date_pay: json['date_pay'].toString(),
      client_pay: json['client_pay'].toString(),
      is_manual: json['is_manual'].toString(),
      fact_num: json['fact_num'].toString(),
    );
  }
}
