class UserModel {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String role; // 'teacher' or 'student'
  final String? bio;
  final List<String>? languages;
  final double? rating;
  final int? totalReviews;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.role,
    this.bio,
    this.languages,
    this.rating,
    this.totalReviews,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      role: json['role'],
      bio: json['bio'],
      languages:
          json['languages'] != null
              ? List<String>.from(json['languages'])
              : null,
      rating: json['rating']?.toDouble(),
      totalReviews: json['totalReviews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'role': role,
      'bio': bio,
      'languages': languages,
      'rating': rating,
      'totalReviews': totalReviews,
    };
  }
}
