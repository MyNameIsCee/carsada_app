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
      body: SingleChildScrollView(
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
          ],
        ),
      ),
    );
  }
}