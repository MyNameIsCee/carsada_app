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
      //backgroundColor: Colors.transparent,
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
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedNavigation03,
                size: 24,
                color: Color(0xFF353232),
              ),
              selectedIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedNavigation03,
                size: 24,
                color: Color(0xFFFFCC00),
              ),
              label: 'Navigation',
            ),
            NavigationDestination(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedUser,
                size: 24,
                color: Color(0xFF353232),
              ),
              selectedIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedUser,
                size: 24,
                color: Color(0xFFFFCC00),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.screens,
        ),
      ),
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
  const _NavigationScreen();

  @override
  Widget build(BuildContext context) {
    final iloiloborders = LatLngBounds(
      LatLng(10.6400, 122.4700),
      LatLng(10.8300, 122.6500),
    );

    return Stack(
      children: [
        // Map fills the background
        Positioned.fill(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(10.7202, 122.5621),
              initialZoom: 13.0,
              maxZoom: 18.0,
              minZoom: 11.0,
              cameraConstraint: CameraConstraint.contain(bounds: iloiloborders),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.carsada_app',
              ),
            ],
          ),
        ),
        // Header and search box
        Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              color: const Color.fromRGBO(255, 204, 0, 1),
              height: 160,
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Navigation',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Wherever you're going, let's get you there!",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
        // Fixed-position image that can overflow header
        Positioned(
          right: -60,
          top: 4, // adjust as needed
          child: Image.asset(
            'lib/assets/images/jeep.png',
            width: 220,
            height: 220,
            fit: BoxFit.contain,
          ),
        ),
        // Floating search box
        Positioned(
          left: 20,
          right: 20,
          top: 160 - 30, // header height - overlap
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Enter your route',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ),
        ),
        // routes list at the bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag indicator (optional)
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Title
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Routes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
