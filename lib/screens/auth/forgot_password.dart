import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carsada_app/components/text_box.dart';
import 'package:carsada_app/components/button.dart';
import 'package:carsada_app/components/back_icon.dart';
import 'package:carsada_app/validator/validator.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('Password reset link sent to your email.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.message ?? 'An error occurred.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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
            emailTextbox(),
            const SizedBox(height: 20),
            customButton(),
          ],
        ),
      ),
    );
  }

  /// Header text section
  Column textInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Forgot your password?',
            style: TextStyle(
              color: Color(0xFF353232),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Text(
            'Enter your registered email address and we’ll send you a link to reset your password.',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  /// Email input field
  Container emailTextbox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text_Box(
        hintText: 'Email address',
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        validator: emailValidator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  /// Reset Password button
  Container customButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomButton(
        text: 'Send Reset Link',
        onPressed: () async {
          final form = _formKey.currentState;
          if (form == null) return;
          if (!form.validate()) return;
          await passwordReset();
        },
      ),
    );
  }

  /// AppBar (same style as EmailScreen)
  AppBar appBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF7F7F9),
      elevation: 0.0,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Reset Password',
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
}
