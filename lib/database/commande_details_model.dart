// ignore_for_file: non_constant_identifier_names

class CommandeDetailsModel {
  final String id_com;
  final String date_com;
  final String total_com;
  final String user_com;
  final String client_com;
  final String deliver_com;
  CommandeDetailsModel({
    required this.id_com,
    required this.date_com,
    required this.total_com,
    required this.user_com,
    required this.client_com,
    required this.deliver_com,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_com': id_com.toString(),
      'date_com': date_com.toString(),
      'total_com': total_com.toString(),
      'user_com': user_com.toString(),
      'client_com': client_com.toString(),
      'deliver_com': deliver_com.toString(),
    };
  }

  factory CommandeDetailsModel.fromJson(Map<String, dynamic> json) {
    return CommandeDetailsModel(
      id_com: json['id_com'].toString(),
      date_com: json['date_com'].toString(),
      total_com: json['total_com'].toString(),
      user_com: json['user_com'].toString(),
      client_com: json['client_com'].toString(),
      deliver_com: json['deliver_com'].toString(),
    );
  }
}
