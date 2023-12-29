import 'package:flutter/material.dart';
import 'package:flutter_application_1/Views/geo_cache_creation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// This class is the view for the creation of a GeoCache
class CreateGeoCache extends StatefulWidget {
  /// Constructor for CreateGeoCache
  const CreateGeoCache({super.key});

  @override
  State<CreateGeoCache> createState() => _CreateGeoCacheState();
}

class _CreateGeoCacheState extends State<CreateGeoCache> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Text(
          'Create GeoCache',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              maxZoom: 20,
              initialCenter: LatLng(46.005, 4.812),
              initialZoom: 4.5,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () async {
                  final LatLng center = _mapController.camera.center;
                  await Navigator.of(context).push(
                    PageRouteBuilder<GeoCacheCreation>(
                      opaque: false,
                      pageBuilder: (_, __, ___) {
                        return GeoCacheCreation(
                          center: center,
                        );
                      },
                    ),
                  );
                },
                child: const Text('Create GeoCache'),
              ),
            ),
          ),
          const Center(
            child: Icon(
              Icons.location_on,
              color: Color.fromARGB(255, 0, 94, 255),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
