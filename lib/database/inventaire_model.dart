// ignore_for_file: non_constant_identifier_names

class InventaireModel {
  final String date_inv;
  final String client;
  final String total;
  final String paye;
  final String reste;
  final String agent;
  final String is_print;
  final String is_deliver;
  final String id_com;
  InventaireModel({
    required this.date_inv,
    required this.client,
    required this.total,
    required this.paye,
    required this.reste,
    required this.agent,
    required this.is_print,
    required this.is_deliver,
    required this.id_com,
  });

  Map<String, dynamic> toMap() {
    return {
      'date_inv': date_inv.toString(),
      'client': client.toString(),
      'total': total.toString(),
      'paye': paye.toString(),
      'reste': reste.toString(),
      'agent': agent.toString(),
      'is_print': is_print.toString(),
      'is_deliver': is_deliver.toString(),
    };
  }

  factory InventaireModel.fromJson(Map<String, dynamic> json) {
    return InventaireModel(
      date_inv: json['date_inv'].toString(),
      client: json['client'].toString(),
      total: json['total'].toString(),
      paye: json['paye'].toString(),
      reste: json['reste'].toString(),
      agent: json['agent'].toString(),
      is_print: json['is_print'].toString(),
      is_deliver: json['is_deliver'].toString(),
      id_com: json['id_com'].toString(),
    );
  }
}
