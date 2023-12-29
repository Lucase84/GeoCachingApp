import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Objects/geo_cache_marker.dart';
import 'package:flutter_application_1/Routes/map.dart';
import 'package:flutter_application_1/Views/geo_cache_details.dart';
import 'package:latlong2/latlong.dart';

class GeoCachesManagement extends StatefulWidget {
  const GeoCachesManagement({super.key});

  @override
  State<GeoCachesManagement> createState() => _GeoCachesManagementState();
}

class _GeoCachesManagementState extends State<GeoCachesManagement> {
  List<GeoCacheMarker> _geoCacheMarkers = <GeoCacheMarker>[];

  @override
  void initState() {
    super.initState();
    unawaited(fetchGeoCaches());
  }

  Future<void> fetchGeoCaches() async {
    final List<GeoCacheMarker> geoCacheMarkers = await MapManager().getCaches();
    setState(() {
      _geoCacheMarkers = geoCacheMarkers;
    });
  }

  String _getPosAsString(LatLng position) {
    return 'Lat: ${position.latitude.toStringAsFixed(3)} - Lng: ${position.longitude.toStringAsFixed(3)}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _geoCacheMarkers.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute<GeoCacheDetails>(
                builder: (BuildContext context) => GeoCacheDetails(
                  geoCacheMarker: _geoCacheMarkers[index],
                ),
              ),
            );
          },
          title: Text(_geoCacheMarkers[index].name),
          subtitle: Text(_getPosAsString(_geoCacheMarkers[index].position)),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await MapManager().deleteCache(_geoCacheMarkers[index].id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('GeoCache deleted'),
                  ),
                );
              }
              await fetchGeoCaches();
            },
          ),
        );
      },
    );
  }
}
