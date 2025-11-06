import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Medicine {
  String id;
  String name;
  int stockQuantity;
  double price;
  String usage;
  DateTime expiryDate;

  Medicine({
    String? id,
    required this.name,
    required this.stockQuantity,
    required this.price,
    required this.usage,
    required this.expiryDate,
  }): id = id ?? uuid.v4();

  bool isExpired() => DateTime.now().isAfter(expiryDate);
  
  bool hasStock(int quantity) => stockQuantity >= quantity;
  
  void reduceStock(int quantity) {
    if (hasStock(quantity)) {
      stockQuantity -= quantity;
    } else {
      throw Exception('Insufficient stock');
    } 
  }

  void updateInfo({String? name, int? stockQuantity, double? price, String? usage, DateTime? expiryDate }) {
    if (name != null) this.name = name;
    if (stockQuantity != null) this.stockQuantity = stockQuantity;
    if (price != null) this.price = price;
    if (usage != null) this.usage = usage;
    if (expiryDate != null) this.expiryDate = expiryDate;
  }
}