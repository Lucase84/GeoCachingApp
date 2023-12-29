import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Objects/user.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UserManager {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<String> uploadImage(XFile image) async {
    final String path = 'ProfileImages/${DateTime.now()}';
    final Reference storageReference = FirebaseStorage.instance.ref(path);
    final UploadTask uploadTask = storageReference.putData(
      await image.readAsBytes(),
    );
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    final String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<http.Response> updateUserPicture(
    XFile image,
  ) async {
    try {
      final String downloadURL = await uploadImage(image);
      await user?.updatePhotoURL(downloadURL);
      return http.Response(downloadURL, 200);
    } catch (e) {
      debugPrint(e.toString());
      return http.Response('', 500);
    }
  }

  Future<http.Response> deleteUser(String id) async {
    try {
      if (user?.uid == id) {
        return http.Response('', 403);
      }
      await FirebaseFirestore.instance.collection('Users').doc(id).delete();
      return http.Response('', 200);
    } catch (e) {
      debugPrint(e.toString());
      return http.Response('', 500);
    }
  }

  Future<List<UserData>> getUsers() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('Users').get();
    final List<UserData> users = <UserData>[];
    for (final QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot
        in querySnapshot.docs) {
      final UserData user = UserData(
        name: queryDocumentSnapshot.data()['name'] as String,
        email: queryDocumentSnapshot.data()['email'] as String,
        pictureURL: queryDocumentSnapshot.data()['pictureURL'] as String,
        id: queryDocumentSnapshot.id,
      );
      users.add(user);
    }
    return users;
  }
}
