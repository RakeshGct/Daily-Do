import 'package:daily_do/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppAuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? user;

  AppAuthProvider() {
    _authService.userChanges.listen((u) {
      user = u;
      notifyListeners();
    });
  }

  bool get isAuthenticated => user != null;

  Future<void> login(String email, String password) =>
      _authService.login(email, password);
  Future<void> signUp(String email, String password) =>
      _authService.signUp(email, password);
  Future<void> logout() => _authService.logout();
}
