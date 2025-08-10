import 'package:latlong2/latlong.dart';

// A new class to represent a single stopping point with its own coordinates.
class StoppingPoint {
  final String name;
  final LatLng location;

  StoppingPoint({required this.name, required this.location});
}

// The main class for a route.
class JeepneyRoutes {
  final String routeName;
  // This is now a list of our new StoppingPoint objects.
  final List<StoppingPoint> stoppingPoints;
  // This is a simple list of coordinates, used for drawing the line on the map.
  final List<LatLng> polylinePoints;

  JeepneyRoutes({
    required this.routeName,
    required this.stoppingPoints,
  }) : polylinePoints = stoppingPoints.map((point) => point.location).toList(); 
  // The polyline is automatically created from the stopping points.
}

final List<JeepneyRoutes> jeepneyRoutes = [
  JeepneyRoutes(
    routeName: 'Mohon to City Proper Loop',
    // We now create a list of `StoppingPoint` objects.
    stoppingPoints: [
      StoppingPoint(name: 'Mohon Terminal, Osmeña St. (Camiña Balay nga Bato)', location: const LatLng(10.6926481, 122.4998694)),
      StoppingPoint(name: 'Jocson St. (Arevalo Elementary School)', location: const LatLng(10.6893381, 122.5169295)),
      StoppingPoint(name: 'Avanceña St. (Asilo De Molo / Iloilo Supermart Molo)', location: const LatLng(10.6945490, 122.5386000)),
      StoppingPoint(name: 'Locsin St. (Molo Plaza / Molo Mansion)', location: const LatLng(10.6970413, 122.5439116)),
      StoppingPoint(name: 'MH Del Pilar St. (GT Plaza Mall Molo / DSWD)', location: const LatLng(10.6962637, 122.5451339)),
      StoppingPoint(name: 'Gen. Luna St. (UPV Iloilo Campus / Atrium)', location: const LatLng(10.6981700, 122.5552800)),
      StoppingPoint(name: 'Iznart St. (Citadines)', location: const LatLng(10.6987220, 122.5683500)),
      StoppingPoint(name: 'JM Basa St. (Socorro Drug)', location: const LatLng(10.6964833, 122.5690417)),
      StoppingPoint(name: 'Ortiz St. (Plaza Libertad)', location: const LatLng(10.6925180, 122.5736470)),
      StoppingPoint(name: 'Rizal St. (Iloilo Central Market)', location: const LatLng(10.6938859, 122.5667390)),
      StoppingPoint(name: 'Valeria St. (SM Delgado)', location: const LatLng(10.6981150, 122.5673750)),
      StoppingPoint(name: 'Delgado St.', location: const LatLng(10.6981150, 122.5673750)),
      StoppingPoint(name: 'Mabini St. (Robinsons City)', location: const LatLng(10.6939167, 122.5652780)),
      StoppingPoint(name: 'De Leon St. (Super)', location: const LatLng(10.6939167, 122.5652780)),
      StoppingPoint(name: 'Fuentes St.', location: const LatLng(10.7026720, 122.5686140)),
      StoppingPoint(name: 'Ledesma St.', location: const LatLng(10.6939167, 122.5652780)),
      StoppingPoint(name: 'Infante St. (Iloilo Doctors’ Hospital-College / UPV Iloilo Campus)', location: const LatLng(10.6972030, 122.5542680)),
      StoppingPoint(name: 'MH Del Pilar St.', location: const LatLng(10.6962637, 122.5451339)),
      StoppingPoint(name: 'San Pedro St. (Molo Plaza)', location: const LatLng(10.6991320, 122.5472330)),
      StoppingPoint(name: 'Avanceña St. (Arevalo Plaza)', location: const LatLng(10.6945490, 122.5386000)),
      StoppingPoint(name: 'Jocson St.', location: const LatLng(10.6893381, 122.5169295)),
      StoppingPoint(name: 'Osmeña St.', location: const LatLng(10.6926481, 122.4998694)),
      StoppingPoint(name: 'Mohon Terminal', location: const LatLng(10.6926481, 122.4998694)),
    ],
  )
];