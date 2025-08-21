// lib/screens/commuter/route_suggestion_screen.dart

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:carsada_app/utils/jeepneyRoutes.dart';

class RouteSuggestionScreen extends StatelessWidget {
  final String destinationQuery;
  final List<JeepneyRoute> validRoutes;
  final LatLng userLocation;
  final Function(LatLng, LatLng) calculateDistance;
  final LatLng Function(LatLng, List<LatLng>) findNearestPoint;

  const RouteSuggestionScreen({
    super.key,
    required this.destinationQuery,
    required this.validRoutes,
    required this.userLocation,
    required this.calculateDistance,
    required this.findNearestPoint,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 204, 0, 1),
        title: const Text(
          'Suggested Routes',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Routes for "$destinationQuery"',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: validRoutes.length,
                itemBuilder: (context, index) {
                  final route = validRoutes[index];
                  final boardingPoint =
                      findNearestPoint(userLocation, route.coordinates);
                  final distance =
                      calculateDistance(userLocation, boardingPoint);

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: route.color.withOpacity(0.1),
                        child: Icon(Icons.directions_bus, color: route.color),
                      ),
                      title: Text(route.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle:
                          Text('${distance.toStringAsFixed(0)}m walk to board'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.of(context).pop(route);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}