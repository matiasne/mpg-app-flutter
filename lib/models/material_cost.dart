class MaterialCost {
  final int? id;
  final String description;
  final double quantity;
  final double price;

  MaterialCost({
    this.id,
    required this.description,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'quantity': quantity,
      'price': price,
    };
  }

  static MaterialCost fromMap(Map<String, dynamic> map) {
    return MaterialCost(
      id: map['id'],
      description: map['description'],
      quantity: map['quantity'].toDouble(),
      price: map['price'].toDouble(),
    );
  }
}