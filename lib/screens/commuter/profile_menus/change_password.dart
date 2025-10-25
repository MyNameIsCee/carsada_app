import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carsada_app/components/back_icon.dart';
import 'package:carsada_app/validator/validator.dart';
import 'package:carsada_app/components/text_box.dart';
import 'package:carsada_app/components/button.dart';

class changePassword extends StatefulWidget {
  const changePassword({super.key});

  @override
  State<changePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<changePassword> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Container currentPasswordTextbox() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text_Box(
            hintText: 'Current Password',
            controller: _currentPasswordController,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your current password';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ],
      ),
    );
  }

  Container newPasswordTextbox() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text_Box(
            hintText: 'New Password',
            controller: _newPasswordController,
            isPassword: true,
            validator: passwordValidator,
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ],
      ),
    );
  }

  Container confirmPasswordTextbox() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text_Box(
            hintText: 'Confirm Password',
            controller: _confirmPasswordController,
            isPassword: true,
            validator: (value) {
              if (value != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
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
        onPressed: () async {
          final form = _formKey.currentState;
          if (form == null || !form.validate()) return;

          try {
            // Get the current user
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No user is logged in.')),
              );
              return;
            }

            final credential = EmailAuthProvider.credential(
              email: user.email!,
              password: _currentPasswordController.text,
            );

            await user.reauthenticateWithCredential(credential);

            await user.updatePassword(_newPasswordController.text);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password changed successfully!')),
            );

            // Return true to indicate the password was changed
            Navigator.of(context).pop(true);
          } catch (e) {
            // error handling
            String errorMessage = 'Failed to change password.';
            if (e is FirebaseAuthException) {
              if (e.code == 'wrong-password') {
                errorMessage = 'The current password is incorrect.';
              } else if (e.code == 'requires-recent-login') {
                errorMessage = 'Please log in again to change your password.';
              }
            }

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(errorMessage)));
          }
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
            'Change Password',
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
        child: Form(
          key: _formKey,
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
              currentPasswordTextbox(),
              newPasswordTextbox(),
              confirmPasswordTextbox(),
              const SizedBox(height: 20),
              customButton(),
            ],
          ),
        ),
      ),
    );
  }
}
