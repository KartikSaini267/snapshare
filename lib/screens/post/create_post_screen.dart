import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import '../../services/post_service.dart';

class CreatePostScreen extends StatefulWidget {
  final UserModel currentUser;
  const CreatePostScreen({super.key, required this.currentUser});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File? _selectedImage;
  final _captionController = TextEditingController();
  final _postService = PostService();
  final _imagePicker = ImagePicker();
  bool _isUploading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 40,
        maxWidth: 800,
      );
      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
          _errorMessage = '';
        });
      }
    } catch (e) {
      setState(() => _errorMessage = 'Could not open gallery. Please try again.');
    }
  }

  Future<void> _uploadPost() async {
    if (_selectedImage == null) {
      setState(() => _errorMessage = 'Please select an image first.');
      return;
    }
    setState(() { _isUploading = true; _errorMessage = ''; });

    // Read image bytes and convert to Base64
    final bytes = await _selectedImage!.readAsBytes();
    final base64Image = base64Encode(bytes);

    String result = await _postService.createPostWithBase64(
      imageBase64: base64Image,
      caption: _captionController.text.trim(),
      currentUser: widget.currentUser,
    );

    if (mounted) {
      setState(() => _isUploading = false);
      if (result == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post shared!'),
            backgroundColor: Color(0xFFE1306C),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        setState(() => _errorMessage = result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A), elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Post',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
        actions: [
          TextButton(
            onPressed: (_selectedImage != null && !_isUploading) ? _uploadPost : null,
            child: Text('Share',
                style: TextStyle(
                  color: _selectedImage != null ? const Color(0xFFE1306C) : Colors.white30,
                  fontWeight: FontWeight.w700, fontSize: 15,
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Image picker area
            GestureDetector(
              onTap: _isUploading ? null : _pickImage,
              child: Container(
                width: double.infinity, height: 320,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64, height: 64,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [Color(0xFFE1306C), Color(0xFF833AB4)]),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(Icons.add_photo_alternate_outlined,
                                color: Colors.white, size: 30),
                          ),
                          const SizedBox(height: 14),
                          const Text('Tap to select a photo',
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                          const SizedBox(height: 6),
                          Text('From your gallery',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.35), fontSize: 13)),
                        ],
                      ),
              ),
            ),

            if (_selectedImage != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _isUploading ? null : _pickImage,
                icon: const Icon(Icons.swap_horiz_rounded,
                    size: 18, color: Color(0xFFE1306C)),
                label: const Text('Change Photo',
                    style: TextStyle(color: Color(0xFFE1306C),
                        fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ],

            const SizedBox(height: 20),

            // Caption
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18, backgroundColor: const Color(0xFF2A2A40),
                  child: Text(
                    widget.currentUser.username.isNotEmpty
                        ? widget.currentUser.username[0].toUpperCase() : '?',
                    style: const TextStyle(
                        color: Color(0xFFE1306C), fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _captionController,
                    maxLines: 4, minLines: 2, maxLength: 300,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Write a caption…',
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.3), fontSize: 15),
                      border: InputBorder.none,
                      counterStyle: TextStyle(
                          color: Colors.white.withOpacity(0.25), fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),

            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_errorMessage,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 13))),
                ]),
              ),
            ],

            if (_isUploading) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color(0xFF1E1E30),
                    borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(
                          color: Color(0xFFE1306C), strokeWidth: 2.5)),
                  const SizedBox(width: 14),
                  Text('Saving your post…',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 14)),
                ]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}