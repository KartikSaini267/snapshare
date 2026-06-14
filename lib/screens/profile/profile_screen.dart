import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../services/post_service.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final postService = PostService();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, userSnapshot) {
        UserModel? user;
        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          user = UserModel.fromMap(
              userSnapshot.data!.data() as Map<String, dynamic>);
        }
        final username = user?.username ?? '';
        final email = user?.email ?? '';
        final postCount = user?.postCount ?? 0;

        return StreamBuilder<List<PostModel>>(
          stream: postService.getPostsByUser(userId),
          builder: (context, postsSnapshot) {
            final posts = postsSnapshot.data ?? [];
            final hasError = postsSnapshot.hasError;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: const Color(0xFF0F0F1A),
                  elevation: 0,
                  pinned: true,
                  expandedHeight: 210,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildHeader(username, email, postCount),
                  ),
                ),

                // Error state
                if (hasError)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Error loading posts:\n${postsSnapshot.error}',
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )

                // Loading state
                else if (postsSnapshot.connectionState ==
                    ConnectionState.waiting)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFFE1306C)),
                      ),
                    ),
                  )

                // Empty state
                else if (posts.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Column(
                        children: [
                          Icon(Icons.photo_camera_outlined,
                              color: Colors.white.withOpacity(0.2), size: 56),
                          const SizedBox(height: 12),
                          Text('No posts yet',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 15)),
                        ],
                      ),
                    ),
                  )

                // Posts grid
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(2),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final img = posts[index].imageBase64;
                          final isUrl = img.startsWith('http');
                          return isUrl
                              ? Image.network(img, fit: BoxFit.cover)
                              : Image.memory(
                                  base64Decode(img),
                                  fit: BoxFit.cover,
                                );
                        },
                        childCount: posts.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(String username, String email, int postCount) {
    return Container(
      color: const Color(0xFF0F0F1A),
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70, height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [Color(0xFFE1306C), Color(0xFF833AB4)]),
            ),
            child: Center(
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : '?',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(username,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(email,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.35), fontSize: 12)),
          const SizedBox(height: 10),
          Column(
            children: [
              Text('$postCount',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              Text('posts',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}