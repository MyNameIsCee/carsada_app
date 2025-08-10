import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:carsada_app/screens/commuter/user_tab_screen.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent,
          height: 82,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedNavigation03, size: 24, color: Color(0xFF353232)),
              selectedIcon: HugeIcon(icon: HugeIcons.strokeRoundedNavigation03, size: 24, color: Color(0xFFFFCC00)),
              label: 'Navigation',
            ),
            NavigationDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedUser, size: 24, color: Color(0xFF353232)),
              selectedIcon: HugeIcon(icon: HugeIcons.strokeRoundedUser, size: 24, color: Color(0xFFFFCC00)),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: controller.screens,
          )),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> screens = [
    const _NavigationScreen(),
    const UserTabScreen(),
  ];
}

class _NavigationScreen extends StatelessWidget {
  const _NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final iloiloborders = LatLngBounds(
      LatLng(10.6400, 122.4700),
      LatLng(10.8300, 122.6500),
    );

    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(10.7202, 122.5621), 
        initialZoom: 13.0,
        maxZoom: 18.0,
        minZoom: 11.0,
        cameraConstraint: CameraConstraint.contain(bounds: iloiloborders),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.carsada_app',
        ),
      ],
    );
  }
}