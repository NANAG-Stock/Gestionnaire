// ignore_for_file: file_names

class CommandInfos {
  final String dateCom;
  final String fourName;
  final String comId;

  CommandInfos({
    required this.dateCom,
    required this.fourName,
    required this.comId,
  });

  Map<String, dynamic> toMap() {
    return {
      'dateCom': dateCom.toString(),
      'fourName': fourName.toString(),
      'comId': comId.toString(),
    };
  }

  factory CommandInfos.fromJson(Map<String, dynamic> json) {
    return CommandInfos(
      dateCom: json['dateCom'].toString(),
      fourName: json['fourName'].toString(),
      comId: json['comId'].toString(),
    );
  }
}
