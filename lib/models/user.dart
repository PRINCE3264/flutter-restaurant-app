//
// class AppUser {
//   final String id;
//   final String email;
//   final String? displayName;
//   final String role; // "admin" or "customer"
//
//   AppUser({
//     required this.id,
//     required this.email,
//     this.displayName,
//     required this.role,
//   });
//
//   factory AppUser.fromMap(String id, Map<String, dynamic> map) {
//     return AppUser(
//       id: id,
//       email: map['email'] ?? '',
//       displayName: map['displayName'],
//       role: map['role'] ?? 'customer',
//     );
//   }
//
//   Map<String, dynamic> toMap() => {
//     'email': email,
//     'displayName': displayName,
//     'role': role,
//   };
// }


class AppUser {
  final String id;
  final String email;
  final String? displayName;
  final String role; // "admin" or "customer"

  AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.role = 'customer',
  });

  // Create AppUser from Firestore document
  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      email: map['email'] ?? '',
      displayName: map['displayName'],
      role: map['role'] ?? 'customer',
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      if (displayName != null) 'displayName': displayName,
      'role': role,
    };
  }

  // Optional: copyWith for easy updates
  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? role,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'AppUser(id: $id, email: $email, displayName: $displayName, role: $role)';
  }
}
