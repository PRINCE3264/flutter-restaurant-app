//
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../../models/vendor.dart';
//
// class VendorProvider extends ChangeNotifier {
//   List<Vendor> _vendors = [];
//
//   List<Vendor> get vendors => _vendors;
//
//   final CollectionReference vendorsCollection =
//   FirebaseFirestore.instance.collection('vendors');
//
//   // ===== Fetch Vendors =====
//   Future<void> fetchVendors() async {
//     try {
//       QuerySnapshot snapshot = await vendorsCollection.get();
//       _vendors = snapshot.docs
//           .map((doc) => Vendor.fromMap(doc.id, doc.data() as Map<String, dynamic>))
//           .toList();
//       notifyListeners();
//     } catch (e) {
//       print("Error fetching vendors: $e");
//     }
//   }
//
//   // ===== Add Vendor =====
//   Future<void> addVendor(Vendor vendor) async {
//     try {
//       await vendorsCollection.doc(vendor.id).set(vendor.toMap());
//       _vendors.add(vendor);
//       notifyListeners();
//     } catch (e) {
//       print("Error adding vendor: $e");
//     }
//   }
//
//   // ===== Update Vendor =====
//   Future<void> updateVendor(Vendor vendor) async {
//     try {
//       await vendorsCollection.doc(vendor.id).update(vendor.toMap());
//
//       int index = _vendors.indexWhere((v) => v.id == vendor.id);
//       if (index != -1) {
//         _vendors[index] = vendor;
//         notifyListeners();
//       }
//     } catch (e) {
//       print("Error updating vendor: $e");
//     }
//   }
//
//   // ===== Filter Vendors (Optional) =====
//   List<Vendor> filterVendors({
//     String? foodType,
//     bool? isOpen,
//     String? location,
//     double? minRating,
//   }) {
//     return _vendors.where((v) {
//       final foodMatch = foodType == null || foodType.isEmpty || v.foodType == foodType;
//       final statusMatch = isOpen == null || v.isOpen == isOpen;
//       final locationMatch =
//           location == null || location.isEmpty || v.location.toLowerCase().contains(location.toLowerCase());
//       final ratingMatch = minRating == null || v.rating >= minRating;
//       return foodMatch && statusMatch && locationMatch && ratingMatch;
//     }).toList();
//   }
//
//   void deleteVendor(String id) {}
// }
//



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/vendor.dart';

class VendorProvider extends ChangeNotifier {
  List<Vendor> _vendors = [];

  List<Vendor> get vendors => _vendors;

  final CollectionReference vendorsCollection =
  FirebaseFirestore.instance.collection('vendors');

  // ===== Fetch Vendors =====
  Future<void> fetchVendors() async {
    try {
      QuerySnapshot snapshot = await vendorsCollection.get();
      _vendors = snapshot.docs
          .map((doc) =>
          Vendor.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching vendors: $e");
    }
  }

  // ===== Add Vendor =====
  Future<void> addVendor(Vendor vendor) async {
    try {
      await vendorsCollection.doc(vendor.id).set(vendor.toMap());
      _vendors.add(vendor);
      notifyListeners();
    } catch (e) {
      print("Error adding vendor: $e");
    }
  }

  // ===== Update Vendor =====
  Future<void> updateVendor(Vendor vendor) async {
    try {
      await vendorsCollection.doc(vendor.id).update(vendor.toMap());

      // Update local list
      int index = _vendors.indexWhere((v) => v.id == vendor.id);
      if (index != -1) {
        _vendors[index] = vendor;
      } else {
        // If vendor not found locally, add it (safety net)
        _vendors.add(vendor);
      }
      notifyListeners();
    } catch (e) {
      print("Error updating vendor: $e");
    }
  }

  // ===== Delete Vendor =====
  Future<void> deleteVendor(String id) async {
    try {
      await vendorsCollection.doc(id).delete();
      _vendors.removeWhere((v) => v.id == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting vendor: $e");
    }
  }

  // ===== Filter Vendors (Optional) =====
  List<Vendor> filterVendors({
    String? foodType,
    bool? isOpen,
    String? location,
    double? minRating,
  }) {
    return _vendors.where((v) {
      final foodMatch =
          foodType == null || foodType.isEmpty || v.foodType == foodType;
      final statusMatch = isOpen == null || v.isOpen == isOpen;
      final locationMatch = location == null ||
          location.isEmpty ||
          v.location.toLowerCase().contains(location.toLowerCase());
      final ratingMatch = minRating == null || v.rating >= minRating;
      return foodMatch && statusMatch && locationMatch && ratingMatch;
    }).toList();
  }
}
