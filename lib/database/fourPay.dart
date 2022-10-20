// ignore_for_file: file_names

class FourPay {
  final String typePay;
  final String totalPay;
  final String amountPay;
  final String datePay;
  final String user;

  FourPay({
    required this.typePay,
    required this.totalPay,
    required this.amountPay,
    required this.datePay,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'typePay': typePay.toString(),
      'totalPay': totalPay.toString(),
      'amountPay': amountPay.toString(),
      'datePay': datePay.toString(),
    };
  }

  factory FourPay.fromJson(Map<String, dynamic> json) {
    return FourPay(
      typePay: json['typePay'].toString(),
      totalPay: json['totalPay'].toString(),
      amountPay: json['amountPay'].toString(),
      datePay: json['datePay'].toString(),
      user: json['user'].toString(),
    );
  }
}
