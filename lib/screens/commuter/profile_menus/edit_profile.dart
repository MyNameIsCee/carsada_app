
import 'package:flutter/material.dart';
import 'package:carsada_app/components/back_icon.dart';
import 'package:carsada_app/validator/validator.dart';
import 'package:carsada_app/components/text_box.dart';
import 'package:carsada_app/components/button.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

   @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Container usernameTextbox() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
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

  Container emailTextbox() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
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
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: CustomButton(
        text: 'Confirm',
        onPressed: () {
          final form = _formKey.currentState;
          if (form == null) return;
          if (!form.validate()) return;

        },
      ),
    );
  }
      
    

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
            'Edit Profile',
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
              const SizedBox(height: 40),
              usernameTextbox(),
              emailTextbox(),
              const SizedBox(height: 20),
              customButton(),
            ],
          ),
        ),
    );
  }
}