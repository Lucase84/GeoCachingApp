import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Objects/user.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

/// This class is used to manage the user (update picture, delete user, get users)
class UserManager {
  final User? _user = FirebaseAuth.instance.currentUser;

  Future<String> _uploadImage(XFile image) async {
    final String path = 'ProfileImages/${DateTime.now()}';
    final Reference storageReference = FirebaseStorage.instance.ref(path);
    final UploadTask uploadTask = storageReference.putData(
      await image.readAsBytes(),
    );
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    final String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  /// This method is used to update the picture of the user in the database
  Future<http.Response> updateUserPicture(
    XFile image,
  ) async {
    try {
      final String downloadURL = await _uploadImage(image);
      await _user?.updatePhotoURL(downloadURL);
      return http.Response(downloadURL, 200);
    } catch (e) {
      debugPrint(e.toString());
      return http.Response('', 500);
    }
  }

  /// This method is used to delete the user from the database
  Future<http.Response> deleteUser(String id) async {
    try {
      if (_user?.uid == id) {
        return http.Response('', 403);
      }
      await FirebaseFirestore.instance.collection('Users').doc(id).delete();
      return http.Response('', 200);
    } catch (e) {
      debugPrint(e.toString());
      return http.Response('', 500);
    }
  }

  /// This method is used to get all the users from the database
  Future<List<UserData>> getUsers() async {
    final List<UserData> users = <UserData>[];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('Users').get();
    for (final QueryDocumentSnapshot<Map<String, dynamic>> user
        in querySnapshot.docs) {
      users.add(
        UserData(
          id: user.id,
          email: user.data()['email'] as String,
          name: user.data()['name'] as String,
        ),
      );
    }
    return users;
  }
}
