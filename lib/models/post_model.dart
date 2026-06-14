class PostModel {
  final String postId;
  final String userId;
  final String username;
  final String userProfilePicBase64;
  final String imageBase64; // post image stored as a Base64 string
  final String caption;
  final DateTime createdAt;

  PostModel({
    required this.postId,
    required this.userId,
    required this.username,
    required this.userProfilePicBase64,
    required this.imageBase64,
    required this.caption,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'username': username,
      'userProfilePicBase64': userProfilePicBase64,
      'imageBase64': imageBase64,
      'caption': caption,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      userProfilePicBase64: map['userProfilePicBase64'] ?? '',
      imageBase64: map['imageBase64'] ?? '',
      caption: map['caption'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}