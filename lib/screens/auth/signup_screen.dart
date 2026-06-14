import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _passwordVisible = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_usernameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return;
    }
    if (_usernameController.text.trim().length < 3) {
      setState(() => _errorMessage = 'Username must be at least 3 characters.');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = ''; });

    String result = await _authService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      username: _usernameController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (result == 'success') {
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          child: Column(
            children: [
              const Text('Create Account',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Join SnapShare today',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
              const SizedBox(height: 36),
              _buildTextField(controller: _usernameController, label: 'Username', icon: Icons.person_outline_rounded),
              const SizedBox(height: 16),
              _buildTextField(controller: _emailController, label: 'Email', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController, label: 'Password', icon: Icons.lock_outline,
                obscureText: !_passwordVisible,
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white54),
                  onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(controller: _confirmPasswordController, label: 'Confirm Password', icon: Icons.lock_outline, obscureText: true),
              const SizedBox(height: 12),
              if (_errorMessage.isNotEmpty) _buildError(_errorMessage),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1306C), foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Log In',
                        style: TextStyle(color: Color(0xFFE1306C), fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller, keyboardType: keyboardType, obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white38, size: 20),
        suffixIcon: suffixIcon, filled: true, fillColor: const Color(0xFF1E1E30),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE1306C), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.redAccent, fontSize: 13))),
        ],
      ),
    );
  }
}