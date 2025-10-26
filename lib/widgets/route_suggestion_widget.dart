import 'package:flutter/material.dart';
import 'package:carsada_app/utils/jeepneyRoutes.dart';
import 'package:carsada_app/controllers/navigation_controller.dart';
import 'package:get/get.dart';

// Data model for route suggestions with pre-calculated distance
class RouteSuggestion {
  final JeepneyRoute route;
  final double distanceToBoarding;
  
  const RouteSuggestion({
    required this.route,
    required this.distanceToBoarding,
  });
}

class RouteSuggestionWidget extends StatelessWidget {
  final List<RouteSuggestion> routeSuggestions;
  final Function(JeepneyRoute)? onRouteSelected;
  final bool showDistance;
  final bool isCompact;

  const RouteSuggestionWidget({
    super.key,
    required this.routeSuggestions,
    this.onRouteSelected,
    this.showDistance = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: routeSuggestions.length,
      itemBuilder: (context, index) {
        final routeSuggestion = routeSuggestions[index];
        final route = routeSuggestion.route;
        final distance = routeSuggestion.distanceToBoarding;
        final NavigationController navController = Get.find<NavigationController>();

        if (isCompact) {
          return Container(
            width: 390,
            height: 100,
            margin: const EdgeInsets.symmetric(
              vertical: 3,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.transparent,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                splashColor: Colors.yellow.withOpacity(0.3),
                highlightColor: Colors.yellow.withOpacity(0.1),
                onTap: () {
                  if (onRouteSelected != null) {
                    onRouteSelected!(route);
                  } else {
                    navController.pickRoute(route);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_bus,
                        color: const Color(0xFFFFCC00),
                        size: 30,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              route.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF051D30),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (showDistance) ...[
                              const SizedBox(height: 4),
                              Text(
                                '${distance.toStringAsFixed(0)}m walk to board',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: route.color.withOpacity(0.1),
                child: Icon(Icons.directions_bus, color: route.color),
              ),
              title: Text(
                route.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: showDistance
                  ? Text('${distance.toStringAsFixed(0)}m walk to board')
                  : null,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                if (onRouteSelected != null) {
                  onRouteSelected!(route);
                } else {
                  navController.pickRoute(route);
                }
              },
            ),
          );
        }
      },
    );
  }
}
