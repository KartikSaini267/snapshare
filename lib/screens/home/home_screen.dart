import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/post_service.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../post/create_post_screen.dart';
import '../profile/profile_screen.dart';
import 'post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _postService = PostService();
  int _currentIndex = 0;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = _authService.currentUser;
    if (user != null) {
      final data = await _authService.getUserData(user.uid);
      if (mounted) setState(() => _currentUser = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildFeed(),
          ProfileScreen(userId: _authService.currentUser?.uid ?? ''),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                if (_currentUser == null) return;
                await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CreatePostScreen(currentUser: _currentUser!)));
                _loadUser(); // refresh post count after returning
              },
              backgroundColor: const Color(0xFFE1306C),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
            )
          : null,
    );
  }

  Widget _buildFeed() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true, snap: true,
          backgroundColor: const Color(0xFF0F0F1A), elevation: 0,
          title: Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFE1306C), Color(0xFF833AB4)]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              const Text('SnapShare',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.white60, size: 22),
              onPressed: () => _authService.logOut(),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          sliver: StreamBuilder<List<PostModel>>(
            stream: _postService.getAllPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator(color: Color(0xFFE1306C))));
              }
              final posts = snapshot.data ?? [];
              if (posts.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library_outlined, color: Colors.white.withValues(alpha: 0.2), size: 64),
                        const SizedBox(height: 16),
                        Text('No posts yet', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('Tap + to share your first photo!',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.25), fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => PostCard(post: posts[index]),
                  childCount: posts.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.07))),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.transparent, elevation: 0,
        selectedItemColor: const Color(0xFFE1306C),
        unselectedItemColor: Colors.white38,
        showSelectedLabels: false, showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}