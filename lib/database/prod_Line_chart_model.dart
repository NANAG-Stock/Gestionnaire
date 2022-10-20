// ignore_for_file: file_names

class ProdLineChartModel {
  final String number;
  final String item;
  final String val;
  ProdLineChartModel({
    required this.number,
    required this.item,
    required this.val,
  });

  Map<String, dynamic> toMap() {
    return {
      'number': number.toString(),
      'item': item.toString(),
      'val': val.toString(),
    };
  }

  factory ProdLineChartModel.fromJson(Map<String, dynamic> json) {
    return ProdLineChartModel(
      number: json['number'].toString(),
      item: json['item'].toString(),
      val: json['val'].toString(),
    );
  }
}
