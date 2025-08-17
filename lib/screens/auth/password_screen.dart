import 'package:carsada_app/screens/auth/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carsada_app/components/text_box.dart';
import 'package:carsada_app/components/button.dart';
import 'package:carsada_app/components/back_icon.dart';
import 'package:carsada_app/validator/validator.dart';
import 'package:carsada_app/screens/commuter/home_screen.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: const Color(0xFFF7F7F9),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textInfo(),
            passwordTextbox(),
            const SizedBox(height: 20),
            customButton(),
          ],
        ),
      ),
    );
  }

   Column textInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                'Create a password',
                style: TextStyle(
                  color: Color(0xFF353232),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "Create a password with at least six letters or numbers. It should be something that others can't guess.",
            style: TextStyle(fontSize: 14),
          ),
        ),
        SizedBox(height: 15,),
      ],
    );
  }

  Container passwordTextbox() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text_Box(
            hintText: 'Password',
            controller: _passwordController,
            isPassword: true,
            validator: passwordValidator,
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ],
      ),
    );
  }

  Container customButton() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: CustomButton(
        text: 'Next',
        onPressed: () {
          final formState = _formKey.currentState;
          if (formState == null) return;
          if (!formState.validate()) return;
          _signUp();
        },
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF7F7F9),
      elevation: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Step 3 - 3',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF353232),
            ),
          ),
        ],
      ),
      leading: Back_Icon(
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _signUp() async {
    String password = _passwordController.text.trim();
    try {
      User? user = await _auth.signUpWithEmailAndPassword(
        widget.email,
        password,
        widget.username,
      );
      if (user != null) {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
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