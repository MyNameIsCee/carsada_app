import 'package:flutter/material.dart';
import 'package:carsada_app/components/back_icon.dart';
import 'package:carsada_app/validator/validator.dart';
import 'package:carsada_app/components/text_box.dart';
import 'package:carsada_app/components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        setState(() {
          _usernameController.text = userData?['username'] ?? '';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
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

  Container customButton() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: CustomButton(
        text: 'Confirm',
        onPressed: () async {
          final form = _formKey.currentState;
          if (form == null || !form.validate()) return;

          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) return;

            // Update Firestore username
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'username': _usernameController.text.trim()});

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Username updated successfully!')),
            );

            // Return true to indicate the profile was updated
            Navigator.of(context).pop(true);
          } catch (e) {
            print('Error updating username: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update username.')),
            );
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
              usernameTextbox(),
              const SizedBox(height: 20),
              customButton(),
            ],
          ),
        ),
      ),
    );
  }
}
