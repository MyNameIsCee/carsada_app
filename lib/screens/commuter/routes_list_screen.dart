import 'package:carsada_app/utils/jeepneyRoutesLatLong.dart';
import 'package:carsada_app/utils/jeepneyRoutes.dart';
import 'package:carsada_app/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RoutesListScreen extends StatelessWidget {
  const RoutesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navController = Get.find<NavigationController>();
    final List<JeepneyRoute> allRoutes = allJeepneyRoutes;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 204, 0, 1),
        title: const Text(
          'All Jeepney Routes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 1,
        automaticallyImplyLeading: false, //removes the back button
      ),
      body: ListView.builder(
        itemCount: allRoutes.length,
        itemBuilder: (context, index) {
          final route = allRoutes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 0,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(
                route.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: route.color.withOpacity(0.2),
                child: Icon(Icons.directions_bus, color: route.color, size: 22),
              ),
              onTap: () {
                // This is the key action:
                // Call the pickRoute method on the controller.
                // This will update the state and switch the tab.
                navController.pickRoute(route);
              },
            ),
          );
        },
      ),
    );
  }
}