import 'package:flutter/material.dart';
import 'package:carsada_app/components/text_box.dart';
import 'package:carsada_app/components/button.dart';
import 'package:carsada_app/components/back_icon.dart';
import 'package:carsada_app/screens/auth/password_screen.dart';
import 'package:carsada_app/validator/validator.dart';

class EmailScreen extends StatefulWidget {
  final String username;
  
  const EmailScreen({super.key, required this.username});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
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
            emailTextbox(),
            const SizedBox(height: 20,),
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
               "What's your email address?",
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
                    'Enter the email address at which you can be contacted.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
        SizedBox(height: 15,),
      ],
    );
  }

  Container emailTextbox() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                Text_Box(
                  hintText: 'Email address',
                  controller: _emailController,
            keyboardType: TextInputType.text,
            validator: emailValidator,
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ],
      ),
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
              pageBuilder: (context, animation, secondaryAnimation) => PasswordScreen(
                              username: widget.username,
                              email: _emailController.text.trim(),
                            ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
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
            'Step 2 - 3',
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