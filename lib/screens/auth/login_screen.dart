import 'package:carsada_app/screens/auth/username_screen.dart';
import 'package:carsada_app/screens/commuter/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carsada_app/components/text_box.dart';
import 'package:carsada_app/components/button.dart';
import 'package:carsada_app/screens/auth/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please fill in all fields";
        _isLoading = false;
      });
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        _errorMessage = "Please enter a valid email address";
        _isLoading = false;
      });
      return;
    }

    try {
      User? user = await _auth.loginWithEmailAndPassword(email, password);

      if (user != null) {
        print("Login successful");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        setState(() {
          _errorMessage = "Invalid email or password";
        });
      }
    } catch (e) {
      setState(() {
        if (e.toString().contains('user-not-found')) {
          _errorMessage = "No account found with this email";
        } else if (e.toString().contains('wrong-password')) {
          _errorMessage = "Incorrect password";
        } else if (e.toString().contains('invalid-email')) {
          _errorMessage = "Please enter a valid email address";
        } else {
          _errorMessage = "Login failed. Please try again";
        }
      });
      print("Login error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

//UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 90),
                Image.asset(
                  'lib/assets/images/Logo.png',
                  width: 232,
                  height: 48.73,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 22),

                const Text(
                  'Your everyday navigation app',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF353232),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 84),

              
                Text_Box(
                  hintText: 'Email address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),

             
                Text_Box(
                  hintText: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 10),

                
                if (_errorMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red[700], fontSize: 14),
                    ),
                  ),

                const SizedBox(height: 10),

                CustomButton(
                  text:  _isLoading ? 'Logging in...'  : 'Login',
                  onPressed:  _login,
                  backgroundColor: const Color(0xFFFFCC00),
                  textColor: Color.fromARGB(255, 247, 243, 243),
                  width: 390,
                  height: 50,
                ),
                const SizedBox(height: 30),

            
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
            MaterialPageRoute(builder: (context) => const UsernameScreen()),
          );
          },
          isOutlined: true,
        ),
      ),
    );
  }
}
