import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  User? _user;
  String? _photoURL; // Store the photoURL separately
  bool _isAdmin = false;

  User? get user => _user;
  String? get photoURL => _photoURL; // Getter for photoURL
  bool get isAdmin => _isAdmin;

  void setUser(User? user, {bool isAdmin = false}) {
    _user = user;
    _isAdmin = isAdmin;
    notifyListeners();
  }

  void setPhotoURL(String photoURL) {
    _photoURL = photoURL;
    notifyListeners();
  }
}
