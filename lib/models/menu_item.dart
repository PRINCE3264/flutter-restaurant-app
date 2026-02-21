
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final String vendorId;
  final String vendorName;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.vendorId,
    required this.vendorName,
  });

  // Convert Firestore Doc → FoodItem
  factory FoodItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodItem(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      vendorId: data['vendorId'] ?? '',
      vendorName: data['vendorName'] ?? '',
    );
  }

  // Convert FoodItem → Map (Firestore format)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'vendorId': vendorId,
      'vendorName': vendorName,
    };
  }

  // Helper: copyWith
  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    double? rating,
    String? vendorId,
    String? vendorName,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
    );
  }
}

