import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// This class is used to manage the authentication of the user (login, register, logout, userName)
class UserModel extends ChangeNotifier {
  User? _user;
  String? _photoURL;
  bool _isAdmin = false;
  String? _userName;

  /// This method is used to get the user
  User? get user => _user;

  /// This method is used to get the photoURL of the user
  String? get photoURL => _photoURL;

  /// This method is used to get if the user is admin
  bool get isAdmin => _isAdmin;

  /// This method is used to get the photoURL of the user
  String? get userName => _userName;

  /// This method is used to set the user and if the user is admin
  void setUser(User? user, String userName, {bool isAdmin = false}) {
    _user = user;
    _isAdmin = isAdmin;
    _userName = userName;
    notifyListeners();
  }

  /// This method is used to set the photoURL of the user
  void setPhotoURL(String photoURL) {
    _photoURL = photoURL;
    notifyListeners();
  }
}
