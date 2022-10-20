// ignore_for_file: file_names

class ComPayEspeceListModel {
  final String item;
  ComPayEspeceListModel({
    required this.item,
  });

  Map<String, dynamic> toMap() {
    return {
      'item': item.toString(),
    };
  }

  factory ComPayEspeceListModel.fromJson(Map<String, dynamic> json) {
    return ComPayEspeceListModel(
      item: json['item'].toString(),
    );
  }
}
