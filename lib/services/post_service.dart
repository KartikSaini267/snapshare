import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  Future<String> createPostWithBase64({
  required String imageBase64,
  required String caption,
  required UserModel currentUser,
}) async {
  try {
    String postId = _uuid.v4();

    PostModel newPost = PostModel(
      postId: postId,
      userId: currentUser.uid,
      username: currentUser.username,
      userProfilePicBase64: currentUser.profilePicBase64,
      imageBase64: imageBase64,
      caption: caption,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('posts')
        .doc(postId)
        .set(newPost.toMap());

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .update({'postCount': FieldValue.increment(1)});

    return 'success';
  } catch (e) {
    return 'Failed to create post. Please try again.';
  }
}

  Stream<List<PostModel>> getAllPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromMap(doc.data()))
            .toList());
  }

  Stream<List<PostModel>> getPostsByUser(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromMap(doc.data()))
            .toList());
  }
}