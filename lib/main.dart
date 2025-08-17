import 'package:carsada_app/screens/commuter/services/cloudinary_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carsada_app/screens/splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB6IHbKnPhF3MnG6wJCE2SiDFR7M9RNajg",
      projectId: "carsada-app",
      messagingSenderId: "412517034079",
      appId: "1:412517034079:android:d2129c5ce73c74388253ea",
    ),
  );
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carsada',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Splash(),
    );
  }
}
