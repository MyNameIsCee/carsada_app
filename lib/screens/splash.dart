import 'package:carsada_app/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
<<<<<<< Updated upstream
    await Future.delayed(const Duration(milliseconds: 3500), () {});
=======
    await Future.delayed(const Duration(milliseconds: 3300), () {});
>>>>>>> Stashed changes
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Lottie.network(
                  'https://lottie.host/d484db38-ba89-4fa1-abe9-4dec178f2fcc/HClo8cU9x0.json',
                  fit: BoxFit.contain,
                  repeat: true,
                  animate: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
