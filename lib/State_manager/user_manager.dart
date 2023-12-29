import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  User? _user;
  String? _photoURL; // Store the photoURL separately

  User? get user => _user;
  String? get photoURL => _photoURL; // Getter for photoURL

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void setPhotoURL(String photoURL) {
    _photoURL = photoURL;
    notifyListeners();
  }
}
