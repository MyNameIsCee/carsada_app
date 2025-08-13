import 'package:carsada_app/screens/auth/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carsada_app/components/text_box.dart';
import 'package:carsada_app/components/button.dart';
import 'package:carsada_app/components/back_icon.dart';
import 'package:carsada_app/screens/auth/email_screen.dart';
import 'package:carsada_app/screens/auth/login_screen.dart';

class PasswordScreen extends StatefulWidget {
  final String username;
  final String email;

  const PasswordScreen({super.key, required this.username, required this.email});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
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
                   SizedBox(
                        width: 48,
                        child: Transform.translate(
                        offset: const Offset(-15, 0),
                        child: Align(
                        alignment: Alignment.centerLeft,
                        child: Back_Icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                             PageRouteBuilder(
                               pageBuilder: (context, animation, secondaryAnimation) => EmailScreen(username: widget.username),
                               transitionDuration: Duration.zero,
                               reverseTransitionDuration: Duration.zero,
                           ),
                         );
                       },
                       size: 35,
                     ),
                    ),
                   ),
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
                    'Create a password',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(
                    "Create a password with at least six letters or numbers. It should be something that others can't guess.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                const SizedBox(height: 15),

                Text_Box(
                  hintText: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                ),

                const SizedBox(height: 20),
                CustomButton(
                  text: 'Next',
                  onPressed: _signUp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String password = _passwordController.text.trim();

    if (password.length < 6) {
      print("Password must be at least 6 characters");
      return;
    }

    try {
      User? user = await _auth.signUpWithEmailAndPassword(
        widget.email, 
        password, 
        widget.username
      );

      if (user != null) {
        print("User is successfully created");
        // Optionally sign out to ensure the new user isn't kept logged in
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } else {
        print("Authentication error");
      }
    } catch (e) {
      print("Sign-up error: $e");
    }
  }
}