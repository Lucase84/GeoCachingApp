import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Objects/geo_cache_marker.dart';
import 'package:flutter_application_1/Routes/map.dart';
import 'package:flutter_application_1/Views/geo_cache_details.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  late Position _position = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  List<GeoCacheMarker> _geoCacheMarkers = <GeoCacheMarker>[];

  @override
  void initState() {
    super.initState();
    unawaited(fetchGeoCaches());
    unawaited(_getCurrentLocation());
  }

  Future<void> fetchGeoCaches() async {
    final List<GeoCacheMarker> geoCacheMarkers = await MapManager().getCaches();
    setState(() {
      _geoCacheMarkers = geoCacheMarkers;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await _determinePosition();
      setState(() {
        _position = position;
        _mapController.move(
          LatLng(
            _position.latitude,
            _position.longitude,
          ),
          15,
        );
      });
    } catch (e) {
      if (e.toString() == 'Location permission denied') {
        await showPermissionDeniedDialog();
      }
    }
  }

  Future<void> showPermissionDeniedDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Location permission denied'),
        content: const Text(
          'Please enable location services for this app in your device settings.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _getCurrentLocation();
            },
            child: const Text('Re-ask'),
          ),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return Future<Position>.error('Location permission denied');
      }
    }
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Marker _userMarker(Position pos) {
    return Marker(
      alignment: Alignment.topCenter,
      point: LatLng(
        pos.latitude,
        pos.longitude,
      ),
      child: GestureDetector(
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 30,
        ),
        onTap: () {
          _mapController.move(
            LatLng(
              pos.latitude,
              pos.longitude,
            ),
            15,
          );
        },
        onDoubleTap: () {
          _mapController.move(
            LatLng(
              pos.latitude,
              pos.longitude,
            ),
            19,
          );
        },
      ),
    );
  }

  Future<void> _displayLongPressMenu(
    Offset offset,
    GeoCacheMarker marker,
  ) async {
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final Offset localOffset = renderBox.globalToLocal(offset);

    await showMenu<String>(
      context: context,
      color: Theme.of(context).colorScheme.surface,
      position: RelativeRect.fromLTRB(
        localOffset.dx,
        localOffset.dy,
        localOffset.dx,
        localOffset.dy,
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: Center(
            child: Text(
              marker.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
        PopupMenuItem<String>(
          child: Center(
            child: Image.network(
              marker.photo,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
        ),
        PopupMenuItem<String>(
          child: TextButton(
            child: const Center(
              child: Text('Show details'),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => GeoCacheDetails(
                    geoCacheMarker: marker,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Marker> _geoCachesMarker() {
    final List<Marker> markers = <Marker>[];
    for (final GeoCacheMarker marker in _geoCacheMarkers) {
      markers.add(
        Marker(
          point: marker.position,
          child: GestureDetector(
            child: const Icon(
              Icons.location_on,
              color: Colors.green,
              size: 30,
            ),
            onTap: () {
              _mapController.move(
                marker.position,
                15,
              );
            },
            onDoubleTap: () {
              _mapController.move(
                marker.position,
                19,
              );
            },
            onLongPressDown: (LongPressDownDetails details) async {
              await _displayLongPressMenu(details.globalPosition, marker);
            },
          ),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    if (_geoCacheMarkers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return FlutterMap(
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
        MarkerLayer(
          markers: <Marker>[
            _userMarker(_position),
            ..._geoCachesMarker(),
          ],
        ),
      ],
    );
  }
}
