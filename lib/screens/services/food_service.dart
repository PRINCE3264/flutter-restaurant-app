import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/food_item.dart';
import '../models/food_item.dart';

class FoodService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<FoodItem>> getFoods() {
    return _db
        .collection('menu')
        .where('available', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => FoodItem.fromMap(doc.data(), doc.id)).toList());
  }
}
