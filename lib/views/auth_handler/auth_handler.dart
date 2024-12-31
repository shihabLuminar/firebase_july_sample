import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_july_sample/views/home_screen/home_screen.dart';
import 'package:firebase_july_sample/views/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
