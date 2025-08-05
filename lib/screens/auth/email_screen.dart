import 'package:flutter/material.dart';
import 'package:carsada_app/components/text_box.dart';
import 'package:carsada_app/components/button.dart';
import 'package:carsada_app/components/back_icon.dart';
import 'package:carsada_app/screens/auth/username_screen.dart';
import 'package:carsada_app/screens/auth/password_screen.dart';

class EmailScreen extends StatefulWidget {
  final String username;
  
  EmailScreen({super.key, required this.username});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
                        pageBuilder: (context, animation, secondaryAnimation) => UsernameScreen(),
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
                    "What's your email address?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(
                    'Enter the email address at which you can be contacted.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                const SizedBox(height: 15),
                Text_Box(
                  hintText: 'Email address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),
                CustomButton(
                  text: 'Next',
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => 
                            PasswordScreen(
                              username: widget.username,
                              email: _emailController.text.trim(),
                            ),
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