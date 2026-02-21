class UserModel {
  final String id;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      email: data['email'] ?? 'No Email',
      role: data['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
    };
  }
}
