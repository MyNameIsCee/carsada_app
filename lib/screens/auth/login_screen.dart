import 'package:flutter/material.dart';
import 'package:carsada_app/components/text_box.dart';
import 'package:carsada_app/components/button.dart';
import 'package:carsada_app/screens/auth/username_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
              children: [
                const SizedBox(height: 90),
                
                // Logo
                Image.asset(
                   'lib/assets/images/Logo.png',
                  width: 232,
                  height: 48.73,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 22),

                //message to our users
                const Text(
                  'Your everyday navigation app',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF353232),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 84),

                //Uusername TextBox
                Text_Box(
                  hintText: 'Username',
                  controller: _usernameController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),

                // Password TextBox
                Text_Box(
                  hintText: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 20),

                // Login Button
                CustomButton(
                  text: 'Login',
                  onPressed: () {},
                  backgroundColor: const Color(0xFFFFCC00),
                  textColor: Color.fromARGB(255, 247, 243, 243),
                  width: 390,
                  height: 50,
                ),
                const SizedBox(height: 30),

                // Forgotten password 
                const Text(
                  'Forgotten password?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF353232),
                    fontWeight: FontWeight.normal,
                  ),
                ),
           
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 45, left: 20, right: 20),
        child: CustomButton(
          text: 'Create account',
          onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const UsernameScreen(),
                      ),
                    );
                  },
          isOutlined: true,
          backgroundColor: const Color(0xFFFFCC00),
          textColor: const Color(0xFFFFCC00),
          width: 390,
          height: 50,
        ),
      ),
    );
  }
}
