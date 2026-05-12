import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String nom;
  final String? phone;
  final String? profileImage;
  final String? token;
  
  const User({
    required this.id,
    required this.email,
    required this.nom,
    this.phone,
    this.profileImage,
    this.token,
  });
  
  User copyWith({
    String? id,
    String? email,
    String? nom,
    String? phone,
    String? profileImage,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      nom: nom ?? this.nom,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      token: token ?? this.token,
    );
  }
  
  @override
  List<Object?> get props => [id, email, nom, phone, profileImage, token];
}
