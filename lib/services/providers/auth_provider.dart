import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isSignIn = true;

  void toggleSignInSignUp() {
    isSignIn = !isSignIn;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    debugPrint('Signing in with email: $email');
  }

  Future<void> signUp(String email, String mobile, String password) async {
    debugPrint('Signing up with email: $email and mobile: $mobile');
  }
}
