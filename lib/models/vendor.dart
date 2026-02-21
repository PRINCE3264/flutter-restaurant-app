

class Vendor {
  final String id;
  final String name;
  final String foodType;
  final String location;
  final String image;
  final bool isOpen;
  final double rating;

  Vendor({
    required this.id,
    required this.name,
    required this.foodType,
    required this.location,
    required this.image,
    required this.isOpen,
    required this.rating,
  });

  // Convert Vendor → Map (Firestore format)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'foodType': foodType,
      'location': location,
      'image': image,
      'isOpen': isOpen,
      'rating': rating,
    };
  }

  // Convert Firestore Doc → Vendor
  factory Vendor.fromMap(String id, Map<String, dynamic> map) {
    return Vendor(
      id: id,
      name: map['name'] ?? '',
      foodType: map['foodType'] ?? '',
      location: map['location'] ?? '',
      image: map['image'] ?? '',
      isOpen: map['isOpen'] ?? true,
      rating: (map['rating'] ?? 0).toDouble(),
    );
  }

  // Helper: Copy with changes
  Vendor copyWith({
    String? id,
    String? name,
    String? foodType,
    String? location,
    String? image,
    bool? isOpen,
    double? rating,
  }) {
    return Vendor(
      id: id ?? this.id,
      name: name ?? this.name,
      foodType: foodType ?? this.foodType,
      location: location ?? this.location,
      image: image ?? this.image,
      isOpen: isOpen ?? this.isOpen,
      rating: rating ?? this.rating,
    );
  }
}


