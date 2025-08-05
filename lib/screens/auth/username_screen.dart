import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carsada_app/components/text_box.dart';
import 'package:carsada_app/components/button.dart';
import 'package:carsada_app/components/back_icon.dart';
import 'package:carsada_app/screens/auth/login_screen.dart';
import 'package:carsada_app/screens/auth/email_screen.dart';

class UsernameScreen extends StatefulWidget {
  UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                Row(
                  children: [
                    Back_Icon(
                      onPressed: () {
                       Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                        );
                      },
                      color: Colors.black,
                      size: 26,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(width: 48), 
                  ],
                ),

                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(
                    'Hello!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(
                    'Enter the username you want.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                const SizedBox(height: 15),
                Text_Box(
                  hintText: 'Username',
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                ),

                const SizedBox(height: 20),
                CustomButton(
                  text: 'Next',
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => 
                            EmailScreen(username: _usernameController.text.trim()),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  backgroundColor: const Color(0xFFFFCC00),
                  textColor: Color.fromARGB(255, 247, 243, 243),
                  width: 390,
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}