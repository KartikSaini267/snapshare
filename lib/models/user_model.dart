class UserModel {
  final String uid;
  final String username;
  final String email;
  final String profilePicBase64; // profile picture stored as a Base64 string
  final int postCount;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.profilePicBase64 = '',
    this.postCount = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'profilePicBase64': profilePicBase64,
      'postCount': postCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profilePicBase64: map['profilePicBase64'] ?? '',
      postCount: map['postCount'] ?? 0,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  UserModel copyWith({
    String? username,
    String? profilePicBase64,
    int? postCount,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      username: username ?? this.username,
      profilePicBase64: profilePicBase64 ?? this.profilePicBase64,
      postCount: postCount ?? this.postCount,
      createdAt: createdAt,
    );
  }
}