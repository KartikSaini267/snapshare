import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildImage(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF2A2A40),
            child: Text(
              post.username.isNotEmpty ? post.username[0].toUpperCase() : '?',
              style: const TextStyle(
                  color: Color(0xFFE1306C), fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(post.username,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Text(_timeAgo(post.createdAt),
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final isUrl = post.imageBase64.startsWith('http');
    return AspectRatio(
      aspectRatio: 1.0,
      child: isUrl
          ? Image.network(
              post.imageBase64,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: const Color(0xFF252540),
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFFE1306C), strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF252540),
                child: const Center(
                  child: Icon(Icons.broken_image_outlined,
                      color: Colors.white30, size: 40),
                ),
              ),
            )
          : Image.memory(
              base64Decode(post.imageBase64),
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.caption.isNotEmpty)
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '${post.username}  ',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13.5),
                ),
                TextSpan(
                  text: post.caption,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8), fontSize: 13.5, height: 1.4),
                ),
              ]),
            ),
          const SizedBox(height: 8),
          Text(_formatDate(post.createdAt),
              style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11.5)),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatDate(DateTime dt) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May',
        'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month]} ${dt.day}, ${dt.year}';
  }
}