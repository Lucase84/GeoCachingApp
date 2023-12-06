import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MapManager {
  final CollectionReference<Map<String, dynamic>> geoCaches =
      FirebaseFirestore.instance.collection('GeoCaches');

  Future<String> uploadImage(XFile image) async {
    final String path = 'GeoCachesImages/${DateTime.now()}';
    final Reference storageReference = FirebaseStorage.instance.ref(path);
    final UploadTask uploadTask = storageReference.putData(
      await image.readAsBytes(),
    );
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    final String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<http.Response> createCache(
    String name,
    String description,
    String latitude,
    String longitude,
    XFile image,
  ) async {
    try {
      final String downloadURL = await uploadImage(image);
      await geoCaches.add(
        <String, String>{
          'name': name,
          'description': description,
          'latitude': latitude,
          'longitude': longitude,
          'imageURL': downloadURL,
        },
      );
      return http.Response('', 200);
    } catch (e) {
      debugPrint(e.toString());
      return http.Response('', 500);
    }
  }

  static Future<http.Response> getCaches() async {
    return http.Response('', 200);
  }

  static Future<http.Response> deleteCache(String id) async {
    return http.Response('', 200);
  }
}
