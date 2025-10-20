import 'package:flutter/material.dart';
import 'package:carsada_app/components/back_icon.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF7F7F9),
      elevation: 0.0,
      leading: Back_Icon(
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            'About',
            style: TextStyle(fontSize: 20, color: Color(0xFF353232)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: appBar(context),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 90),
            Center(
              child: Image.asset(
                'lib/assets/images/Logo.png',
                width: 232,
                height: 48.73,
                fit: BoxFit.contain,
              ),
            ),
            version_box(),
            about_section(),
          ],
        ),
      ),


    );
  }

  Padding version_box() {
    return Padding(
           padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 20),
            child: Container(
              width: 390,
              height: 75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Version',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF353232),
                      ),
                    ),
                    const Text(
                      '521.0.0.0.42.97',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF353232),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

   Padding about_section() {
     return Padding(
             padding: const EdgeInsets.only(left: 20, right: 20),
             child: Container(
               width: 390,
               height: 253,
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(15),
               ),
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const Text(
                       'Carsada is an app that serves as your Route guide.',
                       style: TextStyle(
                         fontSize: 16,
                         color: Color(0xFF353232),
                       ),
                     ),
                     const Text(
                       "This helps individuals who don't know the right destination in Iloilo City.",
                       style: TextStyle(
                         fontSize: 16,
                         color: Color(0xFF353232),
                       ),
                     ),
                     const Text(
                       'Carsada is easily accessable through downloading in our website.',
                       style: TextStyle(
                         fontSize: 16,
                         color: Color(0xFF353232),
                       ),
                     ),
                   ],
                 ),
               ),
             ),
           );
   }
}