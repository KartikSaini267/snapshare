import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/login_screen.dart';
import 'home/home_screen.dart';

// First screen to appear. Checks login state and routes accordingly.
// If already logged in → HomeScreen. If not → LoginScreen.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0F0F1A),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFE1306C)),
            ),
          );
        }
        if (snapshot.hasData) return const HomeScreen();
        return const LoginScreen();
      },
    );
  }
}