// import 'package:flutter/material.dart';
// import '../models/user_model.dart';
// import '../screens/services/firestore_service.dart';
// import '../services/firestore_service.dart';
//
// class UserProvider with ChangeNotifier {
//   final FirestoreService _service = FirestoreService();
//   List<UserModel> _users = [];
//
//   List<UserModel> get users => _users;
//
//   void fetchUsers() {
//     _service.getAllUsers().listen((userList) {
//       _users = userList;
//       notifyListeners();
//     });
//   }
//
//   Future<void> updateUserRole(UserModel user, String newRole) async {
//     await _service.updateUser(user.id, {'role': newRole});
//   }
//
//   Future<void> deleteUser(UserModel user) async {
//     await _service.deleteUser(user.id);
//   }
// }
