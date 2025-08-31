// lib/controllers/navigation_controller.dart

import 'package:carsada_app/utils/jeepneyRoutes.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final Rxn<JeepneyRoute> selectedRoute = Rxn<JeepneyRoute>();

  void pickRoute(JeepneyRoute route) {
    selectedRoute.value = route;
    // Switch back to the navigation tab when a route is picked
    selectedIndex.value = 0;
  }

  void clearRoute() {
    selectedRoute.value = null;
  }
}