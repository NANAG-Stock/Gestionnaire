class PayComNumListModel {
  final String itemId;
  final String itemType;
  final String itemVal;
  PayComNumListModel({
    required this.itemId,
    required this.itemType,
    required this.itemVal,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId.toString(),
    };
  }

  factory PayComNumListModel.fromJson(Map<String, dynamic> json) {
    return PayComNumListModel(
      itemId: json['itemId'].toString(),
      itemVal: json['itemVal'].toString(),
      itemType: json['itemType'].toString(),
    );
  }
}
