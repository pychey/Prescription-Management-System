class Medicine {
  String id;
  String name;
  int stockQuantity;
  double price;
  String usage;
  DateTime expiryDate;

  Medicine({
    required this.id,
    required this.name,
    required this.stockQuantity,
    required this.price,
    required this.usage,
    required this.expiryDate,
  });

  bool isExpired() => DateTime.now().isAfter(expiryDate);
  
  bool hasStock(int quantity) => stockQuantity >= quantity;
  
  void reduceStock(int quantity) {
    if (hasStock(quantity)) {
      stockQuantity -= quantity;
    } else {
      throw Exception('Insufficient stock');
    } 
  }
}