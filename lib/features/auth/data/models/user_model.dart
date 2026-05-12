import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.nom,
    super.phone,
    super.profileImage,
    super.token,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return UserModel(
      id: user['id'].toString(),
      email: user['email'] as String,
      nom: user['nom'] as String,
      phone: user['phone'] as String?,
      token: json['token'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nom': nom,
      'phone': phone,
      'token': token,
    };
  }
  
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      nom: user.nom,
      phone: user.phone,
      token: user.token,
    );
  }
}
