import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UserPictureManager {
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
}
