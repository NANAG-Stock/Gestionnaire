// ignore_for_file: file_names

class VenteInfos {
  final String dateVente;
  final String clientName;
  final String venteId;

  VenteInfos({
    required this.dateVente,
    required this.clientName,
    required this.venteId,
  });

  Map<String, dynamic> toMap() {
    return {
      'dateCom': dateVente.toString(),
      'fourName': clientName.toString(),
      'comId': venteId.toString(),
    };
  }

  factory VenteInfos.fromJson(Map<String, dynamic> json) {
    return VenteInfos(
      dateVente: json['dateVente'].toString(),
      clientName: json['clientName'].toString(),
      venteId: json['venteId'].toString(),
    );
  }
}
