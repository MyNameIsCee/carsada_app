import 'package:carsada_app/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:carsada_app/components/text_box.dart';
import 'package:carsada_app/components/button.dart';
import 'package:carsada_app/components/back_icon.dart';
import 'package:carsada_app/screens/auth/email_screen.dart';
import 'package:carsada_app/validator/validator.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
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
            usernameTextbox(),
            const SizedBox(height: 20,),
            customButton(),
          ],
        ),
      ),
    );
  }

  //methods

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
                'Hello!',
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
            'Enter the username you want.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        SizedBox(height: 15,),
      ],
    );
  }

  Container customButton() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: CustomButton(
        text: 'Next',
        onPressed: () {
          final form = _formKey.currentState;
          if (form == null) return;
          if (!form.validate()) return;
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  EmailScreen(username: _usernameController.text.trim()),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
      ),
    );
  }

  Container usernameTextbox() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text_Box(
            hintText: 'Username',
            controller: _usernameController,
            keyboardType: TextInputType.text,
            validator: usernameValidator,
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ],
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
            'Step 1 - 3',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF353232),
            ),
          ),
        ],
      ),
      leading: Back_Icon(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  LoginScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
      ),
    );
  }
}
