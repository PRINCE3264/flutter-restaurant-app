// import 'package:flutter/material.dart';
// import '../models/vendor.dart';
//
// class VendorProvider extends ChangeNotifier {
//   List<Vendor> _vendors = [
//     Vendor(
//         id: 'v1',
//         name: 'Sharma Canteen',
//         image: 'https://i.imgur.com/1.jpg',
//         location: 'Block A',
//         isOpen: true,
//         rating: 4.5,
//         foodTypes: ['Indian', 'Fast Food']),
//     Vendor(
//         id: 'v2',
//         name: 'Green Leaf',
//         image: 'https://i.imgur.com/2.jpg',
//         location: 'Block B',
//         isOpen: false,
//         rating: 4.2,
//         foodTypes: ['Salads', 'Vegan']),
//     // Add more vendors here
//   ];
//
//   List<Vendor> get vendors => _vendors;
//
//   List<Vendor> filterBy(String foodType, bool? isOpen) {
//     return _vendors.where((v) {
//       bool matchesType = foodType.isEmpty || v.foodTypes.contains(foodType);
//       bool matchesOpen = isOpen == null || v.isOpen == isOpen;
//       return matchesType && matchesOpen;
//     }).toList();
//   }
// }
