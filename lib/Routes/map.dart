import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Objects/geo_cache_marker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

/// This class is used to manage the map
class MapManager {
  final CollectionReference<Map<String, dynamic>> _geoCaches =
      FirebaseFirestore.instance.collection('GeoCaches');

  Future<String> _uploadImage(XFile image) async {
    final String path = 'GeoCachesImages/${DateTime.now()}';
    final Reference storageReference = FirebaseStorage.instance.ref(path);
    final UploadTask uploadTask = storageReference.putData(
      await image.readAsBytes(),
    );
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    final String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  /// This method is used to create a new cache in the database
  Future<http.Response> createCache(
    String name,
    String description,
    String latitude,
    String longitude,
    XFile image,
  ) async {
    try {
      final String downloadURL = await _uploadImage(image);
      await _geoCaches.add(
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

  /// This method is used to get all the caches from the database
  Future<List<GeoCacheMarker>> getCaches() async {
    final List<GeoCacheMarker> geoCacheMarkers = <GeoCacheMarker>[];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _geoCaches.get();
    for (final QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot
        in querySnapshot.docs) {
      final GeoCacheMarker geoCacheMarker = GeoCacheMarker(
        name: queryDocumentSnapshot.data()['name'] as String,
        position: LatLng(
          double.parse(queryDocumentSnapshot.data()['latitude'] as String),
          double.parse(queryDocumentSnapshot.data()['longitude'] as String),
        ),
        photo: queryDocumentSnapshot.data()['imageURL'] as String,
        id: queryDocumentSnapshot.id,
      );
      geoCacheMarkers.add(geoCacheMarker);
    }
    return geoCacheMarkers;
  }

  /// This method is used to delete a cache from the database
  Future<http.Response> deleteCache(String id) async {
    try {
      await _geoCaches.doc(id).delete();
      return http.Response('', 200);
    } catch (e) {
      debugPrint(e.toString());
      return http.Response('', 500);
    }
  }
}
