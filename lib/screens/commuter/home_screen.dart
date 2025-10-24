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
import 'dart:math'; // Import for min/max

import 'package:carsada_app/utils/jeepneyRoutes.dart';
import 'package:carsada_app/utils/jeepneyRoutesLatLong.dart';
import 'package:carsada_app/controllers/navigation_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> screens = const [
    _NavigationScreen(),
    SizedBox.shrink(), // This screen is never shown, so use a placeholder
    UserTabScreen(),
  ];

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Obx(() => bottomNavi(controller)),
      ),
      body: Container(
        color: Colors.transparent,
        child: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: screens,
          ),
        ),
      ),
      extendBody: true,
    );
  }

  Widget bottomNavi(NavigationController controller) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller.selectedIndex.value == 0)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              onPanStart: (details) {},
              onPanUpdate: (details) {
                if (details.delta.dy < -5) {
                  if (!_isExpanded) {
                    setState(() {
                      _isExpanded = true;
                    });
                  }
                } else if (details.delta.dy > 5) {
                  if (_isExpanded) {
                    setState(() {
                      _isExpanded = false;
                    });
                  }
                }
              },
              onPanEnd: (details) {},
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _isExpanded ? 655.0 : 50.0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: const Color(0xFFFEFEFE),
                ),
                child: _isExpanded
                    ? Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Column(
                              children: [
                                Container(
                                  width: 50,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 203, 201, 209),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Routes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF051D30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              child: ListView.builder(
                                itemCount: allJeepneyRoutes.length,
                                itemBuilder: (context, index) {
                                  final route = allJeepneyRoutes[index];
                                  final NavigationController navController =
                                      Get.find<NavigationController>();

                                  return Container(
                                    width: 390,
                                    height: 85,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.transparent,
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        splashColor:
                                            Colors.yellow.withOpacity(0.3),
                                        highlightColor:
                                            Colors.yellow.withOpacity(0.1),
                                        onTap: () {
                                          navController.pickRoute(route);
                                          setState(() {
                                            _isExpanded = false;
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.directions_bus,
                                                color:
                                                    const Color(0xFFFFCC00),
                                                size: 30,
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Text(
                                                  route.name,
                                                  style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFF051D30),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        height: 50.0,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 50,
                              height: 3,
                              decoration: BoxDecoration(
                                color:
                                    const Color.fromARGB(255, 203, 201, 209),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Routes',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF051D30),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: Color.fromARGB(255, 189, 188, 188), width: 0.5),
              ),
            ),
            child: NavigationBar(
              backgroundColor: Colors.white,
              indicatorColor: Colors.transparent,
              height: 60,
              elevation: 0,
              selectedIndex: _isExpanded ? 1 : controller.selectedIndex.value,
              onDestinationSelected: (index) {
                if (index == 1) {
                  setState(() {
                    _isExpanded = true;
                  });
                  controller.selectedIndex.value = 0;
                } else if (index == 2) {
                  setState(() {
                    _isExpanded = false;
                  });
                  controller.selectedIndex.value = index;
                } else if (index == 0) {
                  setState(() {
                    _isExpanded = false;
                  });
                  controller.selectedIndex.value = index;
                }
              },
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
          ),
        ],
      ),
    );
  }
}

// Navigation Screen
class _NavigationScreen extends StatefulWidget {
  const _NavigationScreen();

  @override
  State<_NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<_NavigationScreen> {
  final NavigationController navController = Get.find<NavigationController>();
  final MapController _mapController = MapController();
  final TextEditingController _destinationController = TextEditingController();
  final double _maxWalkDistance = 300.0;
  final List<JeepneyRoute> _routes = allJeepneyRoutes;

  LatLng? _userLocation;
  LatLng? _destinationPoint;
  bool _isLoading = false;
  String _statusMessage = 'Initializing...';
  final List<Marker> _markers = [];
  bool _isLocationFixed = false;
  StreamSubscription<Position>? _positionStreamSubscription;
  Polyline? _walkingPath; // User to boarding point
  Polyline? _segmentedJeepneyPath; // Boarding point to alighting point

  // --- STATE FOR SUGGESTIONS ---
  List<Map<String, dynamic>> _suggestions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initLocationService();
    _destinationController.addListener(_onSearchChanged);

    ever(navController.selectedRoute, (JeepneyRoute? route) async {
      if (!mounted) return;
      if (route != null) {
        if (_destinationPoint != null && _userLocation != null) {
          // -Find boarding and alighting points
          final boardingPoint =
              _findNearestPoint(_userLocation!, route.coordinates);
          final alightingPoint =
              _findNearestPoint(_destinationPoint!, route.coordinates);

          // -Get walking route polyline
          final walkingPoints =
              await _getWalkingRoute(_userLocation!, boardingPoint);

          List<LatLng> segmentedRouteCoords = [];
          final int boardingIndex =
              _findNearestPointIndex(boardingPoint, route.coordinates);
          final int alightingIndex =
              _findNearestPointIndex(alightingPoint, route.coordinates);

          if (boardingIndex != -1 && alightingIndex != -1) {
            int startIndex = min(boardingIndex, alightingIndex);
            int endIndex = max(boardingIndex, alightingIndex);
            segmentedRouteCoords =
                route.coordinates.sublist(startIndex, endIndex + 1);
          } else {
            segmentedRouteCoords = route.coordinates;
          }

          setState(() {
            // Set the walking path
            _walkingPath = Polyline(
              points: walkingPoints,
              strokeWidth: 5,
              color: Colors.teal, // Walking path color
            );

            // Set the segmented jeepney path
            _segmentedJeepneyPath = Polyline(
              points: segmentedRouteCoords,
              strokeWidth: 5,
              color: route.color, // Use the route's color
            );

            // Add boarding marker
            _markers.removeWhere((m) => m.key == const ValueKey('board_marker'));
            _markers.add(_createBoardingMarker(boardingPoint));
          });
          _updateMapView(); // Fit map to the full journey
        } else {
          setState(() {
            _markers.removeWhere((m) => m.key != const ValueKey('user_marker'));
            _walkingPath = null;
            _segmentedJeepneyPath = null; // Ensure no segment is drawn
            _destinationPoint = null;
            // --- FIX 1b: Clear text without triggering listener ---
            _destinationController.removeListener(_onSearchChanged);
            _destinationController.clear();
            _destinationController.addListener(_onSearchChanged);
            _suggestions = []; // Explicitly clear suggestions
            // --- END FIX 1b ---
          });
          _updateMapView(fitToRoute: route);
        }
      } else {
        setState(() {
          _markers.removeWhere((m) => m.key != const ValueKey('user_marker'));
          _walkingPath = null;
          _segmentedJeepneyPath = null; // Clear segment
          _destinationPoint = null;
          // --- FIX 1b: Clear text without triggering listener ---
          _destinationController.removeListener(_onSearchChanged);
          _destinationController.clear();
          _destinationController.addListener(_onSearchChanged);
          _suggestions = []; // Explicitly clear suggestions
          // --- END FIX 1b ---
        });
      }
    });
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _positionStreamSubscription?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (mounted) setState(() {});

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _destinationController.text.trim();
      if (query.isNotEmpty) {
        _fetchSuggestions(query);
      } else {
        if (mounted) setState(() => _suggestions = []);
      }
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    if (query.isEmpty) {
      if (mounted) setState(() => _suggestions = []);
      return;
    }

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=5&countrycodes=ph');

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'Carsada'},
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          _suggestions = List<Map<String, dynamic>>.from(data);
        });
      } else {
        setState(() => _suggestions = []);
      }
    } catch (e) {
      print('Suggestion fetch error: $e');
      if (mounted) setState(() => _suggestions = []);
    }
  }

  Future<void> _onSuggestionTapped(Map<String, dynamic> suggestion) async {
    if (!mounted || _userLocation == null) return;

    final displayName = suggestion['display_name'] ?? '';
    final lat = double.tryParse(suggestion['lat'] ?? '');
    final lon = double.tryParse(suggestion['lon'] ?? '');

    if (lat == null || lon == null) return; // Invalid data

    // --- Get new destination first ---
    final destination = LatLng(lat, lon);

    // --- FIX 1: Prevent race condition ---
    FocusScope.of(context).unfocus();
    _destinationController.removeListener(_onSearchChanged);
    _destinationController.text = displayName;
    _destinationController.addListener(_onSearchChanged);

    setState(() {
      _suggestions = [];
      _isLoading = true;
      // DON'T clear route yet
    });

    // --- NEW CHECK: Is this the same destination? ---
    if (destination == _destinationPoint &&
        navController.selectedRoute.value != null) {
      if (mounted) setState(() => _isLoading = false);
      _updateMapView(); // Re-center map
      return; // It's the same destination, do nothing
    }
    // --- END NEW CHECK ---

    // It's a new destination, proceed as normal
    try {
      // NOW we clear the old route
      navController.clearRoute();
      _markers.removeWhere((m) => m.key != const ValueKey('user_marker'));

      setState(() {
        _destinationPoint = destination;
        _markers.add(_createDestinationMarker());
      });

      await _calculateValidRoutesAndNavigate(displayName);
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Search error. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _initLocationService() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      await _getUserLocation();
      _startLocationUpdates();
    } else {
      if (mounted)
        setState(() => _statusMessage = "Location permission is required.");
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
      if (mounted)
        setState(() => _statusMessage = 'Please enable location services.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startLocationUpdates() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );
    _positionStreamSubscription = Geolocator.getPositionStream(
            locationSettings: locationSettings)
        .listen((Position position) {
      if (mounted) {
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
      if (mounted)
        setState(() => _statusMessage = "Please enable location first.");
      return;
    }

    setState(() {
      _suggestions = [];
      _isLoading = true;
      // DON'T clear the route here anymore
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1'),
        headers: {'User-Agent': 'Carsada'},
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        if (data.isNotEmpty) {
          final destination = LatLng(
              double.parse(data[0]['lat']), double.parse(data[0]['lon']));

          // --- NEW CHECK: Is this the same destination? ---
          if (destination == _destinationPoint &&
              navController.selectedRoute.value != null) {
            if (mounted) setState(() => _isLoading = false);
            _updateMapView(); // Re-center map
            return; // It's the same destination, do nothing
          }
          // --- END NEW CHECK ---

          // It's a new destination, so NOW we clear the old state
          navController.clearRoute();
          _markers.removeWhere((m) => m.key != const ValueKey('user_marker'));

          setState(() {
            _destinationPoint = destination;
            _markers.add(_createDestinationMarker());
          });
          await _calculateValidRoutesAndNavigate(query);
        } else {
          setState(() {
            _statusMessage = 'Destination not found';
            _isLoading = false; // Set loading false on error
          });
        }
      }
    } catch (e) {
      if (mounted)
        setState(() {
          _statusMessage = 'Search error. Please try again.';
          _isLoading = false; // Set loading false on error
        });
    }
  }

  Future<void> _calculateValidRoutesAndNavigate(String query) async {
    if (_userLocation == null || _destinationPoint == null) return;
    final validRoutes = _routes.where((route) {
      final boardingPoint =
          _findNearestPoint(_userLocation!, route.coordinates);
      final userDistance = _calculateDistance(_userLocation!, boardingPoint);
      final nearestToDest =
          _findNearestPoint(_destinationPoint!, route.coordinates);
      final destDistance =
          _calculateDistance(_destinationPoint!, nearestToDest);
      return userDistance <= _maxWalkDistance &&
          destDistance <= _maxWalkDistance;
    }).toList();

    if (!mounted) return;

    // --- FIX 2: Handle 1, 1+, or 0 routes ---
    if (validRoutes.length == 1) {
      // Only one route, select it automatically
      navController.selectedRoute.value = validRoutes.first;
      setState(() {
        _statusMessage = 'Route found!';
      });
    } else if (validRoutes.length > 1) {
      // Multiple routes, push the suggestion screen
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
        // This triggers the 'ever' worker to run the suggestion logic
        navController.selectedRoute.value = selectedRoute;
      } else {
        setState(() {
          _statusMessage = 'No route selected. Please try another destination.';
        });
      }
    } else {
      // No routes found
      setState(() => _statusMessage =
          'No routes found within ${_maxWalkDistance.toInt()}m of you and your destination.');
    }
    // --- END FIX 2 ---

    setState(() => _isLoading = false);
  }

  void _updateMapView({JeepneyRoute? fitToRoute}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (fitToRoute != null) {
        // Fit to the entire route (picked from list)
        final bounds = LatLngBounds.fromPoints(fitToRoute.coordinates);
        _mapController.fitCamera(
            CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)));
      } else if (navController.selectedRoute.value != null &&
          _userLocation != null &&
          _destinationPoint != null) {
        // Fit to the suggested journey (walk + ride)
        final boardingPoint = _findNearestPoint(
            _userLocation!, navController.selectedRoute.value!.coordinates);

        // This now correctly includes the jeepney route in the bounds
        final bounds = LatLngBounds.fromPoints([
          _userLocation!,
          boardingPoint,
          _destinationPoint!,
          ...navController.selectedRoute.value!.coordinates // The fix
        ]);
        _mapController.fitCamera(
            CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(80)));
      }
    });
  }

  // --- Helper Functions ---

  double _calculateDistance(LatLng p1, LatLng p2) =>
      Geolocator.distanceBetween(
          p1.latitude, p1.longitude, p2.latitude, p2.longitude);

  LatLng _findNearestPoint(LatLng p, List<LatLng> ps) {
    LatLng n = ps.first;
    double m = _calculateDistance(p, n);
    for (var pt in ps) {
      double d = _calculateDistance(p, pt);
      if (d < m) {
        m = d;
        n = pt;
      }
    }
    return n;
  }

  int _findNearestPointIndex(LatLng point, List<LatLng> points) {
    if (points.isEmpty) return -1;
    int minIndex = 0;
    double minDistance = _calculateDistance(point, points.first);

    for (int i = 1; i < points.length; i++) {
      double distance = _calculateDistance(point, points[i]);
      if (distance < minDistance) {
        minDistance = distance;
        minIndex = i;
      }
    }
    return minIndex;
  }

  Future<List<LatLng>> _getWalkingRoute(LatLng start, LatLng end) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://router.project-osrm.org/route/v1/walking/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson'),
        headers: {'User-Agent': 'Carsada'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final coordinates =
              data['routes'][0]['geometry']['coordinates'] as List;
          return coordinates
              .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
              .toList();
        }
      }
    } catch (e) {
      print('Walking route error: $e');
    }
    return [start, end]; // Fallback to a straight line
  }

  void _goToMyLocation() {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, 15.0);
      setState(() {
        _isLocationFixed = true;
      });
    }
  }

  // --- Marker Creation Functions ---
  Marker _createUserMarker() => Marker(
        key: const ValueKey('user_marker'),
        point: _userLocation!,
        width: 40,
        height: 40,
        child: Container(
          /* ... your user marker UI ... */
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      );
  Marker _createDestinationMarker() => Marker(
      key: const ValueKey('dest_marker'),
      point: _destinationPoint!,
      width: 80,
      height: 80,
      child: const Icon(Icons.location_on, color: Colors.red, size: 40));
  Marker _createBoardingMarker(LatLng p) => Marker(
      key: const ValueKey('board_marker'),
      point: p,
      width: 80,
      height: 80,
      child: const Icon(Icons.directions_bus, color: Colors.green, size: 35));

  // --- Widget to build the suggestions list ---
  Widget _buildSuggestionsList() {
    if (_suggestions.isEmpty || _destinationController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8.0), // Matches the old SizedBox
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      constraints: BoxConstraints(
        maxHeight: 220.0, // Limit height
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = _suggestions[index];
          final displayName = suggestion['display_name'] ?? 'Unknown location';

          return ListTile(
            leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
            title: Text(
              displayName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onTap: () {
              _onSuggestionTapped(suggestion);
            },
          );
        },
      ),
    );
  }

  // --- Build Method ---
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
                onMapEvent: (MapEvent mapEvent) {
                  if (mapEvent is MapEventMove && _isLocationFixed) {
                    setState(() {
                      _isLocationFixed = false;
                    });
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https::/{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.carsada_app',
                ),
                PolylineLayer(
                  polylines: <Polyline>[
                    if (_segmentedJeepneyPath != null)
                      _segmentedJeepneyPath!
                    else if (navController.selectedRoute.value != null)
                      navController.selectedRoute.value!.toPolyline(),
                    if (_walkingPath != null) _walkingPath!,
                  ],
                ),
                MarkerLayer(markers: _markers),
              ],
            ),
          ),

          // ... (Rest of your UI: Column, Positioned buttons, etc. No changes needed) ...
          Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 254, 254, 254),
                  border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(255, 189, 188, 188), width: 0.5),
                  ),
                ),
                height: 85,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 5),
                    child: const Text('carsada',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFCC00))),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 3))
                        ],
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _destinationController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your destination',
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 16),
                          icon: Icon(Icons.search, color: Colors.black54),
                        ),
                        style: const TextStyle(fontSize: 16),
                        onSubmitted: (_) => _findDestination(),
                      ),
                    ),

                    // --- MODIFIED SECTION ---
                    // Conditionally show suggestions or the status message
                    (_suggestions.isNotEmpty &&
                            _destinationController.text.isNotEmpty)
                        ? _buildSuggestionsList()
                        : Column(
                            children: [
                              const SizedBox(height: 8),
                              // Only show status message if not loading and suggestions are hidden
                              if (!_isLoading)
                                Text(
                                  _statusMessage,
                                  style: TextStyle(
                                      color: _isLoading
                                          ? Colors.grey
                                          : Color(0xFF353232),
                                      backgroundColor:
                                          Colors.white.withOpacity(0.7)),
                                  textAlign: TextAlign.center,
                                ),
                            ],
                          ),
                    // --- END MODIFIED SECTION ---
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 150,
            right: 20,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFFFEFEFE),
              ),
              child: IconButton(
                onPressed: _goToMyLocation,
                icon: Icon(
                  _isLocationFixed
                      ? Icons.my_location
                      : Icons.location_searching,
                  color: _isLocationFixed ? Colors.blue : Colors.grey,
                  size: 25,
                ),
                tooltip: 'My Location',
              ),
            ),
          ),
          Obx(
            () => navController.selectedRoute.value != null
                ? Positioned(
                    bottom: 210,
                    right: 20,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFFFEFEFE),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          navController.clearRoute();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 25,
                        ),
                        tooltip: 'Clear Route',
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}