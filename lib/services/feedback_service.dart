import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feedback_model.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Submit feedback for a food item
  Future<void> submitFoodFeedback(FeedbackModel feedback) async {
    await _firestore.collection('food_feedback').add(feedback.toMap());
  }

  // Get feedback for a specific food item
  Stream<List<FeedbackModel>> getFoodFeedback(String foodId) {
    return _firestore
        .collection('food_feedback')
        .where('foodId', isEqualTo: foodId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FeedbackModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Compute average rating for a food item
  Stream<double> getAverageRating(String foodId) {
    return getFoodFeedback(foodId).map((feedbackList) {
      if (feedbackList.isEmpty) return 0.0;
      double total = feedbackList.fold(0.0, (sum, f) => sum + f.rating);
      return total / feedbackList.length;
    });
  }
}
