import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carsada_app/screens/auth/login_screen.dart';
import 'package:carsada_app/components/menu_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hugeicons/hugeicons.dart';

class UserTabScreen extends StatefulWidget {
  const UserTabScreen({super.key});

  @override
  State<UserTabScreen> createState() => _UserTabScreenState();
}

//back end

class _UserTabScreenState extends State<UserTabScreen> {
  String username = '';
  String email = '';

  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          email = user.email ?? '';
        });
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && mounted) {
          setState(() {
            username = userDoc.get('username') ?? 'User';
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      print('Logout error: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _profileImage = File(picked.path);
        });
      }
    } catch (e) {
      print('Image pick error: $e');
    }
  }


  //UI

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: const Color(0xFFF7F7F9),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 123,
                      height: 123,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 61.5,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : null,
                            child: _profileImage == null
                                ? const Icon(Icons.person, color: Colors.white, size: 100)
                                : null,
                          ),
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: GestureDetector(
                              onTap: () => _pickImage(ImageSource.gallery),
                              child: SizedBox(
                                width: 39,
                                height: 39,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 39,
                                      height: 39,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF7F7F9),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: HugeIcon(
                                          icon: HugeIcons.strokeRoundedCamera01,
                                          size: 20,
                                          color: Color(0xFF353232),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(fontSize: 20, color: Color(0xFF353232)),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          email,
                          style: const TextStyle(fontSize: 14, color: Color(0xFF353232)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                Center(
                  child: Container(
                    width: 390,
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MenuTile(menu: menus[0], showDivider: true),
                        MenuTile(menu: menus[1], showDivider: true),
                        MenuTile(menu: menus[2], showDivider: true),
                        MenuTile(menu: menus[3]),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 390,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MenuTile(menu: menus[4], showDivider: true),
                        MenuTile(menu: menus[5], onTap: _logout),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
