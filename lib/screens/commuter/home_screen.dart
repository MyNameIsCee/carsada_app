import 'package:carsada_app/screens/commuter/routeSuggestion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:carsada_app/screens/commuter/user_tab_screen.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';


import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:carsada_app/utils/jeepneyRoutes.dart';
import 'package:carsada_app/utils/jeepneyRoutesLatLong.dart';

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
      bottomNavigationBar: Obx(() => bottomNavi(controller)),
      body: Obx(
        () {
          if (controller.selectedIndex.value == 0) {
            return const _NavigationScreen();
          } else {
            return controller.screens[controller.selectedIndex.value];
          }
        },
      ),
    );
  }

  Widget bottomNavi(NavigationController controller) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color.fromARGB(255, 189, 188, 188), width: 0.5),
        ),
      ),
      child: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        height: 60,
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
              icon: HugeIcons.strokeRoundedRoute02,
              size: 24,
              color: Color(0xFF353232),
            ),
            selectedIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedRoute02,
              size: 24,
              color: Color(0xFFFFCC00),
            ),
            label: 'Routes',
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
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> screens = [
    const _NavigationScreen(),
    const RouteScreen(), 
    const UserTabScreen(),
  ];
}

class _NavigationScreen extends StatefulWidget {
  const _NavigationScreen();

  @override
  State<_NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<_NavigationScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _destinationController = TextEditingController();
  final double _maxWalkDistance = 250.0;
  final List<JeepneyRoute> _routes = allJeepneyRoutes;

  LatLng? _userLocation;
  LatLng? _destinationPoint;
  List<JeepneyRoute> _validRoutes = [];
  bool _isLoading = false;
  String _statusMessage = 'Initializing...';
  JeepneyRoute? _selectedRoute;
  final List<Marker> _markers = [];
  Polyline? _walkingPath;

  @override
  void initState() {
    super.initState();
    _initLocationService();
    _destinationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _initLocationService() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      await _getUserLocation();
      _startLocationUpdates();
    } else {
      setState(() {
        _statusMessage = "Location permission is required.";
      });
    }
  }

  Future<void> _getUserLocation() async {
    setState(() => _isLoading = true);
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      _updateUserLocation(position, isInitial: true);
    } catch (e) {
      setState(() => _statusMessage = 'Please enable location services.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _startLocationUpdates() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _updateUserLocation(position);
    });
  }

  void _updateUserLocation(Position position, {bool isInitial = false}) {
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      _markers.removeWhere((m) => m.key == const ValueKey('user_marker'));
      _markers.add(_createUserMarker());

      if (isInitial && _statusMessage == 'Initializing...') {
        _statusMessage = 'Enter your destination';
      }
    });

    if (_selectedRoute != null) {
      _updateMapView();
    }
  }

  Future<void> _findDestination() async {
    final query = _destinationController.text.trim();
    if (query.isEmpty) return;
    if (_userLocation == null) {
      setState(() => _statusMessage = "Please enable location first.");
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Searching for "$query"...';
      _validRoutes = [];
      _selectedRoute = null; 
      _markers.removeWhere((m) => m.key != const ValueKey('user_marker'));
      _walkingPath = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1'),
        headers: {'User-Agent': 'Carsada'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        if (data.isNotEmpty) {
          final destination = LatLng(
            double.parse(data[0]['lat']),
            double.parse(data[0]['lon']),
          );
          setState(() {
            _destinationPoint = destination;
            _markers.add(_createDestinationMarker());
          });
          await _calculateValidRoutesAndNavigate(
              query); 
        } else {
          setState(() => _statusMessage = 'Destination not found');
        }
      }
    } catch (e) {
      setState(() => _statusMessage = 'Search error. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _calculateValidRoutesAndNavigate(String query) async {
    if (_userLocation == null || _destinationPoint == null) return;

    final validRoutes = _routes.where((route) {
      final boardingPoint = _findNearestPoint(_userLocation!, route.coordinates);
      final userDistance = _calculateDistance(_userLocation!, boardingPoint);
      final nearestToDest =
          _findNearestPoint(_destinationPoint!, route.coordinates);
      final destDistance = _calculateDistance(_destinationPoint!, nearestToDest);
      return userDistance <= _maxWalkDistance &&
          destDistance <= _maxWalkDistance;
    }).toList();

    if (validRoutes.isNotEmpty) {
    
      final selectedRoute = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RouteSuggestionScreen(
            destinationQuery: query,
            validRoutes: validRoutes,
            userLocation: _userLocation!,
            calculateDistance: _calculateDistance,
            findNearestPoint: _findNearestPoint,
          ),
        ),
      );

      if (selectedRoute != null) {
        setState(() => _selectedRoute = selectedRoute);
        _selectRoute(selectedRoute); 
      }
    } else {
      setState(() => _statusMessage =
          'No routes found within ${_maxWalkDistance.toInt()}m of you and your destination.');
    }
    setState(() => _isLoading = false);
  }

  void _selectRoute(JeepneyRoute route) {
    if (_userLocation == null) return;
    final boardingPoint = _findNearestPoint(_userLocation!, route.coordinates);
    final destinationPoint = _findNearestPoint(_destinationPoint!, route.coordinates);

    setState(() {
      _selectedRoute = route;
      _walkingPath = Polyline(
        points: [_userLocation!, boardingPoint],
        strokeWidth: 4,
        color: Colors.green,
      );
      _markers.removeWhere((m) => m.key == const ValueKey('board_marker'));
      _markers.add(_createBoardingMarker(boardingPoint));
    });

    _updateMapView();
  }

  void _updateMapView() {
    if (_selectedRoute == null ||
        _userLocation == null ||
        _destinationPoint == null) return;
    final boardingPoint =
        _findNearestPoint(_userLocation!, _selectedRoute!.coordinates);
    final bounds = LatLngBounds.fromPoints([
      _userLocation!,
      boardingPoint,
      ..._selectedRoute!.coordinates,
      _destinationPoint!,
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(50),
        ),
      );
    });
  }
  

  double _calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  LatLng _findNearestPoint(LatLng point, List<LatLng> points) {
    LatLng nearestPoint = points.first;
    double minDistance = _calculateDistance(point, nearestPoint);

    for (var p in points) {
      double distance = _calculateDistance(point, p);
      if (distance < minDistance) {
        minDistance = distance;
        nearestPoint = p;
      }
    }
    return nearestPoint;
  }

  Marker _createUserMarker() {
    return Marker(
      key: const ValueKey('user_marker'),
      point: _userLocation!,
      width: 80,
      height: 80,
      child: const Icon(
        Icons.person_pin_circle,
        color: Colors.orangeAccent,
        size: 30,
      ),
    );
  }

  Marker _createDestinationMarker() {
    return Marker(
      key: const ValueKey('dest_marker'),
      point: _destinationPoint!,
      width: 80,
      height: 80,
      child: const Icon(
        Icons.location_on,
        color: Colors.red,
        size: 40,
      ),
    );
  }

  Marker _createBoardingMarker(LatLng point) {
    return Marker(
      key: const ValueKey('board_marker'),
      point: point,
      width: 80,
      height: 80,
      child: const Icon(
        Icons.directions_walk,
        color: Colors.green,
        size: 35,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Positioned.fill(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation ?? const LatLng(10.7202, 122.5621),
              initialZoom: 13.0,
              maxZoom: 18.0,
              minZoom: 11.0,
              onMapReady: () async {
                if (_userLocation == null) {
                  await _getUserLocation();
                }
                if (_userLocation != null) {
                  _mapController.move(_userLocation!, 15.0);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.carsada_app',
              ),
              if (_selectedRoute != null)
                PolylineLayer(
                  polylines: [
                    _selectedRoute!.toPolyline(),
                    if (_walkingPath != null) _walkingPath!,
                  ],
                ),
              MarkerLayer(
                markers: _selectedRoute == null 
                  ? _markers.where((m) => m.key == const ValueKey('user_marker')).toList()
                  : _markers,
              ),
            ],
          ),
        ),

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
                      "Para po! San punta natin?",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),


        Positioned(
          right: -60,
          top: 3,
          child: Image.asset(
            'lib/assets/images/jeep.png',
            width: 220,
            height: 220,
            fit: BoxFit.contain,
          ),
        ),

 
        Positioned(
          left: 20,
          right: 20,
          top: 160 - 30, 
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your destination',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
                    icon: Icon(Icons.search, color: Colors.black54),
                  ),
                  style: const TextStyle(fontSize: 16),
                  onSubmitted: (_) => _findDestination(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _statusMessage,
                style: TextStyle(color: _isLoading ? Colors.grey : Colors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        if (_selectedRoute != null)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => _calculateValidRoutesAndNavigate(_destinationController.text),
              backgroundColor: const Color.fromRGBO(255, 204, 0, 1),
             child: const HugeIcon(icon: HugeIcons.strokeRoundedBus02, color: Colors.black),
            ),
          ),
      ],
    );
  }
}

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      backgroundColor: Color(0xFFF7F7F9),
      body: Center(
        child: Text(
          'Jeepney Routes Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}