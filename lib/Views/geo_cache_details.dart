import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Objects/geo_cache_marker.dart';

/// This class is the view of the details of a geo cache
class GeoCacheDetails extends StatefulWidget {
  /// Constructor for GeoCacheDetails with required parameters
  const GeoCacheDetails({required this.geoCacheMarker, super.key});

  /// GeoCacheMarker object of the cache
  final GeoCacheMarker geoCacheMarker;

  @override
  State<GeoCacheDetails> createState() => _GeoCacheDetailsState();
}

class _GeoCacheDetailsState extends State<GeoCacheDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<int> _animation;
  final int _maxWidth = 200;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation =
        IntTween(begin: 0, end: _maxWidth).animate(_animationController);
    _animation.addListener(
      () => setState(
        () {
          if (_animationController.value == 1.0) {
            if (context.mounted) {
              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Text(
          widget.geoCacheMarker.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Center(
            child: Image.network(
              widget.geoCacheMarker.photo,
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Coordinates: ${widget.geoCacheMarker.position.latitude}, ${widget.geoCacheMarker.position.longitude}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 200),
          GestureDetector(
            onLongPressCancel: () {
              _animationController.reverse();
            },
            onLongPressDown: (LongPressDownDetails details) {
              if (_animationController.value == 0.0) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            },
            onLongPressEnd: (LongPressEndDetails details) {
              if (_animationController.value < 1) {
                _animationController.reverse();
              } else {
                _animationController.reset();
              }
            },
            child: Stack(
              children: <Widget>[
                Container(
                  width: _maxWidth.toDouble(),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Found !',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: _animation.value.toDouble(),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(
                      Theme.of(context).colorScheme.error.value & 0x44FFFFFF,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
