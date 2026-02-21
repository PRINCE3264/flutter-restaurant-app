
class FoodItem {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  int quantity;
  final bool available;
  final double discount;
  final double rating;
  final String vendorId;
  final String vendorName;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    this.quantity = 1,
    this.available = true,
    this.discount = 0,
    this.rating = 0,
    this.vendorId = '',
    this.vendorName = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'quantity': quantity,
      'available': available,
      'discount': discount,
      'rating': rating,
      'vendorId': vendorId,
      'vendorName': vendorName,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map, String docId) {
    return FoodItem(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      available: map['available'] ?? true,
      discount: (map['discount'] ?? 0).toDouble(),
      rating: (map['rating'] ?? 0).toDouble(),
      vendorId: map['vendorId'] ?? '',
      vendorName: map['vendorName'] ?? '',
    );
  }
}



