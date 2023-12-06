import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Routes/map.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class GeoCacheCreation extends StatefulWidget {
  const GeoCacheCreation({required this.center, super.key});

  final LatLng center;
  @override
  State<GeoCacheCreation> createState() => _GeoCacheCreationState();
}

class _GeoCacheCreationState extends State<GeoCacheCreation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  Future<void> createCache(
    LatLng center,
    String name,
    String description,
    XFile? image,
  ) async {
    final http.Response res = await MapManager().createCache(
      name,
      description,
      center.latitude.toString(),
      center.longitude.toString(),
      image!,
    );
    if (res.statusCode == 200) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Widget _widgetImagePicker() {
    if (_image == null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () async {
            final XFile? image = await _imagePicker.pickImage(
              source: ImageSource.gallery,
            );
            setState(() {
              _image = image;
            });
          },
          child: Text(
            'Pick an image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      );
    } else {
      return Image.file(
        File(_image!.path),
        height: 150,
        fit: BoxFit.fitWidth,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'Enter details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
          ),
          TextField(
            controller: _hintController,
            decoration: const InputDecoration(
              labelText: 'Hint',
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          _widgetImagePicker(),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final bool fieldMissing = _nameController.text.isEmpty ||
                _descriptionController.text.isEmpty ||
                _hintController.text.isEmpty ||
                _image == null;
            if (fieldMissing) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill all the fields'),
                ),
              );
              return;
            }
            final int imgLength = await File(_image!.path).length();
            if (imgLength > 5000000) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image size must be less than 5MB'),
                  ),
                );
                return;
              }
            }
            await createCache(
              widget.center,
              _nameController.text,
              _descriptionController.text,
              _image,
            );
            _nameController.clear();
            _descriptionController.clear();
            _hintController.clear();
            setState(() {
              _image = null;
            });
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
