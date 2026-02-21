
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryBoy {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String vehicleNumber;
  final String vehicleType;
  final String status; // Available, Busy, Offline
  final String? imageUrl;
  final double rating;
  final int totalDeliveries;
  final int completedDeliveries;
  final DateTime joinDate;
  final bool isActive;
  final String? currentOrderId;
  final GeoPoint? currentLocation;
  final DateTime? lastActive;
  final String? licenseNumber;
  final String? licenseType;
  final String? address;
  final String? emergencyContact;
  final String? notes;
  final int? age;
  final String? gender;
  final String? bloodGroup;
  final String? aadharNumber;
  final String? panNumber;
  final String? bankAccountNumber;
  final String? ifscCode;
  final String? bankName;
  final String? insuranceNumber;
  final DateTime? licenseExpiry;
  final DateTime? insuranceExpiry;
  final List<String>? documents;
  final Map<String, dynamic>? metadata;

  DeliveryBoy({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.status,
    this.imageUrl,
    this.rating = 0.0,
    this.totalDeliveries = 0,
    this.completedDeliveries = 0,
    required this.joinDate,
    this.isActive = true,
    this.currentOrderId,
    this.currentLocation,
    this.lastActive,

    // New fields with default values
    this.licenseNumber,
    this.licenseType = 'A',
    this.address,
    this.emergencyContact,
    this.notes,
    this.age,
    this.gender,
    this.bloodGroup,
    this.aadharNumber,
    this.panNumber,
    this.bankAccountNumber,
    this.ifscCode,
    this.bankName,
    this.insuranceNumber,
    this.licenseExpiry,
    this.insuranceExpiry,
    this.documents,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'status': status,
      'imageUrl': imageUrl,
      'rating': rating,
      'totalDeliveries': totalDeliveries,
      'completedDeliveries': completedDeliveries,
      'joinDate': joinDate.millisecondsSinceEpoch,
      'isActive': isActive,
      'currentOrderId': currentOrderId,
      'currentLocation': currentLocation,
      'lastActive': lastActive?.millisecondsSinceEpoch,

      // New fields
      'licenseNumber': licenseNumber,
      'licenseType': licenseType,
      'address': address,
      'emergencyContact': emergencyContact,
      'notes': notes,
      'age': age,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'aadharNumber': aadharNumber,
      'panNumber': panNumber,
      'bankAccountNumber': bankAccountNumber,
      'ifscCode': ifscCode,
      'bankName': bankName,
      'insuranceNumber': insuranceNumber,
      'licenseExpiry': licenseExpiry?.millisecondsSinceEpoch,
      'insuranceExpiry': insuranceExpiry?.millisecondsSinceEpoch,
      'documents': documents,
      'metadata': metadata,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory DeliveryBoy.fromMap(Map<String, dynamic> map, String docId) {
    return DeliveryBoy(
      id: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      vehicleNumber: map['vehicleNumber'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      status: map['status'] ?? 'Offline',
      imageUrl: map['imageUrl'],
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalDeliveries: map['totalDeliveries'] ?? 0,
      completedDeliveries: map['completedDeliveries'] ?? 0,
      joinDate: map['joinDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['joinDate'])
          : DateTime.now(),
      isActive: map['isActive'] ?? true,
      currentOrderId: map['currentOrderId'],
      currentLocation: map['currentLocation'],
      lastActive: map['lastActive'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastActive'])
          : null,

      // New fields
      licenseNumber: map['licenseNumber'],
      licenseType: map['licenseType'] ?? 'A',
      address: map['address'],
      emergencyContact: map['emergencyContact'],
      notes: map['notes'],
      age: map['age'],
      gender: map['gender'],
      bloodGroup: map['bloodGroup'],
      aadharNumber: map['aadharNumber'],
      panNumber: map['panNumber'],
      bankAccountNumber: map['bankAccountNumber'],
      ifscCode: map['ifscCode'],
      bankName: map['bankName'],
      insuranceNumber: map['insuranceNumber'],
      licenseExpiry: map['licenseExpiry'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['licenseExpiry'])
          : null,
      insuranceExpiry: map['insuranceExpiry'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['insuranceExpiry'])
          : null,
      documents: map['documents'] != null
          ? List<String>.from(map['documents'])
          : null,
      metadata: map['metadata'],
    );
  }

  DeliveryBoy copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? vehicleNumber,
    String? vehicleType,
    String? status,
    String? imageUrl,
    double? rating,
    int? totalDeliveries,
    int? completedDeliveries,
    DateTime? joinDate,
    bool? isActive,
    String? currentOrderId,
    GeoPoint? currentLocation,
    DateTime? lastActive,
    String? licenseNumber,
    String? licenseType,
    String? address,
    String? emergencyContact,
    String? notes,
    int? age,
    String? gender,
    String? bloodGroup,
    String? aadharNumber,
    String? panNumber,
    String? bankAccountNumber,
    String? ifscCode,
    String? bankName,
    String? insuranceNumber,
    DateTime? licenseExpiry,
    DateTime? insuranceExpiry,
    List<String>? documents,
    Map<String, dynamic>? metadata,
  }) {
    return DeliveryBoy(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      totalDeliveries: totalDeliveries ?? this.totalDeliveries,
      completedDeliveries: completedDeliveries ?? this.completedDeliveries,
      joinDate: joinDate ?? this.joinDate,
      isActive: isActive ?? this.isActive,
      currentOrderId: currentOrderId ?? this.currentOrderId,
      currentLocation: currentLocation ?? this.currentLocation,
      lastActive: lastActive ?? this.lastActive,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseType: licenseType ?? this.licenseType,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      notes: notes ?? this.notes,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      panNumber: panNumber ?? this.panNumber,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      bankName: bankName ?? this.bankName,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      documents: documents ?? this.documents,
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper methods
  double get successRate {
    if (totalDeliveries == 0) return 0.0;
    return (completedDeliveries / totalDeliveries) * 100;
  }

  bool get isLicenseExpired {
    if (licenseExpiry == null) return false;
    return licenseExpiry!.isBefore(DateTime.now());
  }

  bool get isInsuranceExpired {
    if (insuranceExpiry == null) return false;
    return insuranceExpiry!.isBefore(DateTime.now());
  }

  int get experienceInMonths {
    final now = DateTime.now();
    final difference = now.difference(joinDate);
    return (difference.inDays / 30).floor();
  }

  String get formattedJoinDate {
    return '${joinDate.day}/${joinDate.month}/${joinDate.year}';
  }

  String get formattedExperience {
    final months = experienceInMonths;
    if (months < 12) {
      return '$months ${months == 1 ? 'month' : 'months'}';
    } else {
      final years = (months / 12).floor();
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years ${years == 1 ? 'year' : 'years'}';
      } else {
        return '$years ${years == 1 ? 'year' : 'years'} $remainingMonths ${remainingMonths == 1 ? 'month' : 'months'}';
      }
    }
  }

  // Validation methods
  bool get hasCompleteProfile {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        vehicleNumber.isNotEmpty &&
        licenseNumber != null &&
        licenseNumber!.isNotEmpty &&
        aadharNumber != null &&
        aadharNumber!.isNotEmpty;
  }

  bool get hasBankDetails {
    return bankAccountNumber != null &&
        bankAccountNumber!.isNotEmpty &&
        ifscCode != null &&
        ifscCode!.isNotEmpty;
  }

  List<String> get missingDocuments {
    final List<String> missing = [];
    if (licenseNumber == null || licenseNumber!.isEmpty) missing.add('License');
    if (aadharNumber == null || aadharNumber!.isEmpty) missing.add('Aadhar');
    if (panNumber == null || panNumber!.isEmpty) missing.add('PAN');
    if (insuranceNumber == null || insuranceNumber!.isEmpty) missing.add('Insurance');
    return missing;
  }

  // Status helpers
  bool get isAvailable => status == 'Available' && isActive;
  bool get isBusy => status == 'Busy';
  bool get isOffline => status == 'Offline' || !isActive;

  // Performance metrics
  double get averageDeliveryTime {
    // This would be calculated based on actual delivery data
    // For now, return a placeholder
    return 30.0; // minutes
  }

  double get customerSatisfaction {
    // This would be calculated based on ratings and feedback
    // For now, return the rating as satisfaction percentage
    return (rating / 5.0) * 100;
  }

  @override
  String toString() {
    return 'DeliveryBoy(id: $id, name: $name, status: $status, rating: $rating, deliveries: $completedDeliveries/$totalDeliveries)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeliveryBoy && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Extension for list operations
extension DeliveryBoyListExtensions on List<DeliveryBoy> {
  List<DeliveryBoy> get available => where((boy) => boy.isAvailable).toList();
  List<DeliveryBoy> get busy => where((boy) => boy.isBusy).toList();
  List<DeliveryBoy> get offline => where((boy) => boy.isOffline).toList();
  List<DeliveryBoy> get active => where((boy) => boy.isActive).toList();
  List<DeliveryBoy> get topRated => where((boy) => boy.rating >= 4.0).toList();

  List<DeliveryBoy> sortByRating({bool ascending = false}) {
    sort((a, b) => ascending ? a.rating.compareTo(b.rating) : b.rating.compareTo(a.rating));
    return this;
  }

  List<DeliveryBoy> sortByDeliveries({bool ascending = false}) {
    sort((a, b) => ascending
        ? a.completedDeliveries.compareTo(b.completedDeliveries)
        : b.completedDeliveries.compareTo(a.completedDeliveries));
    return this;
  }

  List<DeliveryBoy> sortByExperience({bool ascending = false}) {
    sort((a, b) => ascending
        ? a.joinDate.compareTo(b.joinDate)
        : b.joinDate.compareTo(a.joinDate));
    return this;
  }

  double get averageRating {
    if (isEmpty) return 0.0;
    return map((boy) => boy.rating).reduce((a, b) => a + b) / length;
  }

  int get totalCompletedDeliveries {
    return map((boy) => boy.completedDeliveries).reduce((a, b) => a + b);
  }
}
