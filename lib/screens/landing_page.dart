import 'package:flutter/material.dart';
import 'package:carsada_app/screens/auth/login_screen.dart';
import 'package:carsada_app/screens/auth/username_screen.dart';
import 'package:carsada_app/components/button.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<String> _landingPageImages = [
    'lib/assets/landing_page/image1.jpg',
    'lib/assets/landing_page/image2.jpg',
    'lib/assets/landing_page/image3.jpg',
    'lib/assets/landing_page/image4.jpg',
    'lib/assets/landing_page/image5.jpg',
    'lib/assets/landing_page/image6.jpg',
    'lib/assets/landing_page/image7.jpg',
    'lib/assets/landing_page/image8.jpg',
    'lib/assets/landing_page/image9.jpg',
    'lib/assets/landing_page/image10.jpg',
    'lib/assets/landing_page/image11.jpg',
    'lib/assets/landing_page/image12.jpg',
    'lib/assets/landing_page/image13.jpg',
  ];

  late final List<String> _extendedImages = _landingPageImages + [_landingPageImages[0]];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      body: Stack(
        children: [
          Positioned.fill(
            child: OverflowBox(  
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: Center(  
                child: _imageGrid(),
              ),
            ),
          ),
          
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          
          // main content
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                
                // logo
                _Logo(),
                
                const Spacer(),
                
                // buttons for sign up and login
                _buttons(),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageGrid() {
    return Transform.rotate(
      angle: 0.47, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1st column 
          Transform.translate(
            offset: const Offset(0, 40), // to align rows
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _image(0),
                const SizedBox(height: 20),
                _image(1),
                  const SizedBox(height: 20),
                _image(4),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // 2nd column
          Transform.translate(
            offset: const Offset(0, 40), // to align rows
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _image(2),
                  const SizedBox(height: 20),
                _image(3),
                  const SizedBox(height: 20),
                _image(4),
                  const SizedBox(height: 20),
                _image(5),
                  const SizedBox(height: 20),
                _image(6),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // 3rd column
          Transform.translate(
            offset: const Offset(0, 40), //to align the rows
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _image(7),
                  const SizedBox(height: 20),
                _image(8),
                  const SizedBox(height: 20),
                _image(9),
                  const SizedBox(height: 20),
                _image(10),
                  const SizedBox(height: 20),
                _image(11),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // 4th column
          Transform.translate(
            offset: const Offset(0, 400), // to align rows
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _image(12),
                const SizedBox(height: 20),
                _image(13),
                const SizedBox(height: 20),
                _image(1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _image(int imageIndex) {
    int index = imageIndex % _extendedImages.length;
    return Container(
      width: 180,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          _extendedImages[index],
          fit: BoxFit.cover,
          color: Colors.black.withOpacity(0.5), // Increased opacity for less visibility
          colorBlendMode: BlendMode.multiply,
        ),
      ),
    );
  }

  Widget _Logo() {
    return Image.asset(
      'lib/assets/images/Logo.png',
      width: 232,
      height: 48.73,
      fit: BoxFit.contain,
    );
  }

  Widget _buttons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // sign up button
          CustomButton(
            text: 'Sign Up',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UsernameScreen(),
                ),
              );
            },
            backgroundColor: const Color(0xFFFFCC00),
            textColor: Colors.black,
            width: double.infinity,
            height: 50,
          ),
          
          const SizedBox(height: 16),
          
          // login button
          CustomButton(
            text: 'Log In',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            isOutlined: true,
            backgroundColor: const Color(0xFFFFCC00),
            textColor: const Color(0xFFFFCC00),
            width: double.infinity,
            height: 50,
          ),
        ],
      ),
    );
  }
}