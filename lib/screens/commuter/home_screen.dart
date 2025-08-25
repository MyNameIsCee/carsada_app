// lib/screens/commuter/home_screen.dart

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
import 'dart:async';
import 'package:carsada_app/utils/jeepneyRoutes.dart';
import 'package:carsada_app/utils/jeepneyRoutesLatLong.dart';
import 'package:carsada_app/screens/commuter/routes_list_screen.dart';
import 'package:carsada_app/controllers/navigation_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> screens = const [
    _NavigationScreen(),
    RoutesListScreen(),
    UserTabScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      bottomNavigationBar: Obx(() => bottomNavi(controller)),
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: screens,
        ),
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
        onDestinationSelected: (index) => controller.selectedIndex.value = index,
        destinations: const [
          NavigationDestination(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedNavigation03, size: 24, color: Color(0xFF353232),
            ),
            selectedIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedNavigation03, size: 24, color: Color(0xFFFFCC00),
            ),
            label: 'Navigation',
          ),
          NavigationDestination(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedRoute02, size: 24, color: Color(0xFF353232),
            ),
            selectedIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedRoute02, size: 24, color: Color(0xFFFFCC00),
            ),
            label: 'Routes',
          ),
          NavigationDestination(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedUser, size: 24, color: Color(0xFF353232),
            ),
            selectedIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedUser, size: 24, color: Color(0xFFFFCC00),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _NavigationScreen extends StatefulWidget {
  const _NavigationScreen();

  @override
  State<_NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<_NavigationScreen> {
  final NavigationController navController = Get.find<NavigationController>();
  final MapController _mapController = MapController();
  final TextEditingController _destinationController = TextEditingController();
  final double _maxWalkDistance = 250.0;
  final List<JeepneyRoute> _routes = allJeepneyRoutes;

  LatLng? _userLocation;
  LatLng? _destinationPoint;
  bool _isLoading = false;
  String _statusMessage = 'Initializing...';
  final List<Marker> _markers = [];
  Polyline? _walkingPath;
  
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initLocationService();
    _destinationController.addListener(() {
      if (mounted) setState(() {});
    });

    ever(navController.selectedRoute, (JeepneyRoute? route) {
      if (!mounted) return;
      if (route != null) {
        if (_destinationPoint != null && _userLocation != null) {
          final boardingPoint = _findNearestPoint(_userLocation!, route.coordinates);
          setState(() {
            _walkingPath = Polyline(
              points: [_userLocation!, boardingPoint],
              strokeWidth: 5,
              color: Colors.teal,
              // isDotted: true, // <-- FIX: Removed as it's not supported in your package version
            );
            _markers.removeWhere((m) => m.key == const ValueKey('board_marker'));
            _markers.add(_createBoardingMarker(boardingPoint));
          });
          _updateMapView();
        } else {
          setState(() {
            _markers.removeWhere((m) => m.key != const ValueKey('user_marker'));
            _walkingPath = null;
            _destinationPoint = null;
            _destinationController.clear();
          });
          _updateMapView(fitToRoute: route);
        }
      } else {
        setState(() {
          _markers.removeWhere((m) => m.key != const ValueKey('user_marker'));
          _walkingPath = null;
          _destinationPoint = null;
          _destinationController.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initLocationService() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      await _getUserLocation();
      _startLocationUpdates();
    } else {
      if (mounted) setState(() => _statusMessage = "Location permission is required.");
    }
  }

  Future<void> _getUserLocation() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      _updateUserLocation(position, isInitial: true);
    } catch (e) {
      if (mounted) setState(() => _statusMessage = 'Please enable location services.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startLocationUpdates() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );
    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
          if(mounted) {
            _updateUserLocation(position);
          }
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
    if (navController.selectedRoute.value != null) {
      _updateMapView();
    }
  }

  Future<void> _findDestination() async {
    final query = _destinationController.text.trim();
    if (query.isEmpty) return;
    if (_userLocation == null) {
      if (mounted) setState(() => _statusMessage = "Please enable location first.");
      return;
    }
    if (mounted) {
      setState(() {
        _isLoading = true;
        navController.clearRoute();
        _markers.removeWhere((m) => m.key != const ValueKey('user_marker'));
        _walkingPath = null;
      });
    }
    try {
      final response = await http.get(
        Uri.parse('https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1'),
        headers: {'User-Agent': 'Carsada'},
      );
      if(!mounted) return;
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        if (data.isNotEmpty) {
          final destination = LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon']));
          setState(() {
            _destinationPoint = destination;
            _markers.add(_createDestinationMarker());
          });
          await _calculateValidRoutesAndNavigate(query);
        } else {
          setState(() => _statusMessage = 'Destination not found');
        }
      }
    } catch (e) {
      if (mounted) setState(() => _statusMessage = 'Search error. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _calculateValidRoutesAndNavigate(String query) async {
    if (_userLocation == null || _destinationPoint == null) return;
    final validRoutes = _routes.where((route) {
      final boardingPoint = _findNearestPoint(_userLocation!, route.coordinates);
      final userDistance = _calculateDistance(_userLocation!, boardingPoint);
      final nearestToDest = _findNearestPoint(_destinationPoint!, route.coordinates);
      final destDistance = _calculateDistance(_destinationPoint!, nearestToDest);
      return userDistance <= _maxWalkDistance && destDistance <= _maxWalkDistance;
    }).toList();
    if (!mounted) return;
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
      if (!mounted) return;
      if (selectedRoute != null) {
        navController.selectedRoute.value = selectedRoute;
      } else {
        setState(() {
            _statusMessage = 'No route selected. Please try another destination.';
        });
      }
    } else {
      setState(() => _statusMessage = 'No routes found within ${_maxWalkDistance.toInt()}m of you and your destination.');
    }
    setState(() => _isLoading = false);
  }

  void _updateMapView({JeepneyRoute? fitToRoute}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (fitToRoute != null) {
        final bounds = LatLngBounds.fromPoints(fitToRoute.coordinates);
        _mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)));
      } else if (navController.selectedRoute.value != null && _userLocation != null && _destinationPoint != null) {
        final boardingPoint = _findNearestPoint(_userLocation!, navController.selectedRoute.value!.coordinates);
        final bounds = LatLngBounds.fromPoints([_userLocation!, boardingPoint, _destinationPoint!]);
        _mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(80)));
      }
    });
  }

  double _calculateDistance(LatLng p1, LatLng p2) => Geolocator.distanceBetween(p1.latitude, p1.longitude, p2.latitude, p2.longitude);
  LatLng _findNearestPoint(LatLng p, List<LatLng> ps) { LatLng n=ps.first;double m=_calculateDistance(p, n);for(var pt in ps){double d=_calculateDistance(p, pt);if(d<m){m=d;n=pt;}}return n; }
  Marker _createUserMarker() => Marker(key: const ValueKey('user_marker'), point: _userLocation!, width: 80, height: 80, child: const Icon(Icons.person_pin_circle, color: Colors.orangeAccent, size: 35));
  Marker _createDestinationMarker() => Marker(key: const ValueKey('dest_marker'), point: _destinationPoint!, width: 80, height: 80, child: const Icon(Icons.location_on, color: Colors.red, size: 40));
  Marker _createBoardingMarker(LatLng p) => Marker(key: const ValueKey('board_marker'), point: p, width: 80, height: 80, child: const Icon(Icons.directions_bus, color: Colors.green, size: 35));

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _userLocation ?? const LatLng(10.7202, 122.5621),
                initialZoom: 13.0,
                maxZoom: 18.0,
                minZoom: 11.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.carsada_app',
                ),
                PolylineLayer(
                  polylines: <Polyline>[ 
                    if (navController.selectedRoute.value != null)
                      navController.selectedRoute.value!.toPolyline(),
                    if (_walkingPath != null) _walkingPath!,
                  ],
                ),
                MarkerLayer(markers: _markers),
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
                      Text('Navigation', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(height: 4),
                      Text("Para po! San punta natin?", style: TextStyle(fontSize: 14, color: Colors.black87)),
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
            child: Image.asset('lib/assets/images/jeep.png', width: 220, height: 220, fit: BoxFit.contain),
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
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
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
                  style: TextStyle(color: _isLoading ? Colors.grey : Color(0xFF353232), backgroundColor: Colors.white.withOpacity(0.7)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          if (navController.selectedRoute.value != null)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () => navController.clearRoute(),
                backgroundColor: Colors.redAccent,
                tooltip: 'Clear Route',
                child: const Icon(Icons.clear, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}