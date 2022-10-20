// ignore_for_file: file_names

class TrackCpt {
  final String idCom;
  final String dateCom;
  final String agent;
  final String somme;
  TrackCpt({
    required this.idCom,
    required this.dateCom,
    required this.agent,
    required this.somme,
  });
  Map<String, dynamic> toMap() {
    return {
      'idCom': idCom,
      'dateCom': dateCom,
      'agent': agent,
      'somme': somme,
    };
  }

  factory TrackCpt.fromJson(Map<String, dynamic> json) {
    return TrackCpt(
      idCom: json['idCom'],
      dateCom: json['dateCom'],
      agent: json['agent'],
      somme: json['somme'],
    );
  }
}
