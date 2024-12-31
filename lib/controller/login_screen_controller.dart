import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_july_sample/views/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreenController with ChangeNotifier {
  Future<void> onLogin(
      {required String email,
      required String pass,
      required BuildContext context}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      if (credential.user != null) {
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => HomeScreen(),
        //   ),
        //   (route) => false,
        // );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code.toString()),
        ),
      );
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
