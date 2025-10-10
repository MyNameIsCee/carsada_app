import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Represents a single jeepney route with its name, coordinates, and appearance.
class JeepneyRoute {
  final String name;
  final List<LatLng> coordinates;
  final Color color;
  final String description;

  const JeepneyRoute({
    required this.name,
    required this.coordinates,
    this.color = Colors.blue,
    this.description = '',
  });

  /// Converts this route object into a [Polyline] for displaying on the map.
  Polyline toPolyline() => Polyline(
        points: coordinates,
        strokeWidth: 5,
        color: color,
      );
}
