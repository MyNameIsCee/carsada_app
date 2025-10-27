import 'dart:io';
import 'package:carsada_app/screens/commuter/profile_menus/change_password.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:carsada_app/screens/auth/login_screen.dart';
import 'package:carsada_app/components/menu_tile.dart';
import 'package:carsada_app/screens/commuter/services/cloudinary_service.dart';
import 'package:carsada_app/screens/commuter/profile_menus/about.dart';
import 'package:carsada_app/screens/commuter/profile_menus/faqs.dart';
import 'package:carsada_app/screens/commuter/profile_menus/send_feedback.dart';
import 'package:carsada_app/screens/commuter/profile_menus/edit_profile.dart';

class UserTabScreen extends StatefulWidget {
  const UserTabScreen({super.key});

  @override
  State<UserTabScreen> createState() => _UserTabScreenState();
}

class _UserTabScreenState extends State<UserTabScreen> {
  String username = 'User';
  String email = '';
  String profileImageUrl = '';
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      setState(() => email = user.email ?? '');

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && mounted) {
        final userData = userDoc.data();

        setState(() {
          username =
              userData?['username']?.toString() ??
              user.displayName ??
              user.email?.split('@').first ??
              'User';

          profileImageUrl = userData?['profileImage']?.toString() ?? '';
        });
      } else if (!userDoc.exists) {
        await _createUserDocument(user);

        if (mounted) {
          setState(() {
            username =
                user.displayName ?? user.email?.split('@').first ?? 'User';
            profileImageUrl = '';
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() {
          username = 'User';
          profileImageUrl = '';
        });
      }
    }
  }

  Future<void> _createUserDocument(User user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': user.displayName ?? user.email?.split('@').first ?? 'User',
        'email': user.email,
        'profileImage': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('User document created successfully for ${user.uid}');
    } catch (e) {
      print('Error creating user document: $e');
    }
  }

  Future<void> _showLogoutConfirmation() async {
      return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20), 
            width: MediaQuery.of(context).size.width * 0.8,  
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,  
              children: [
                const SizedBox(height: 5),
                const Text(
                  'Log out of your account?',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF353232),
                  ),
                ),
                const SizedBox(height: 10),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.end,  
                  children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF353232),
                          ),
                        ),
                      ),
                    
                    const SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await _logout();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20),  
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'LOG OUT',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      _showAlert('Error', 'Failed to logout');
    }
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      if (file.path == null) return;

      final imageFile = File(file.path!);
      final imageUrl = await CloudinaryService.uploadImage(imageFile);

      if (imageUrl != null) {
        await _updateProfileImage(imageUrl);
        setState(() => _profileImage = imageFile);
        _showAlert('Success', 'Profile picture updated!');
      }
    } catch (e) {
      _showAlert('Error', 'Failed to update profile picture');
    }
  }

  Future<void> _updateProfileImage(String imageUrl) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'profileImage': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      setState(() => profileImageUrl = imageUrl);
    } catch (e) {
      _showAlert('Error', 'Failed to save profile picture');
      rethrow;
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F9),
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
                            radius: 61.5,
                            backgroundColor: Colors.grey,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : (profileImageUrl.isNotEmpty
                                          ? NetworkImage(profileImageUrl)
                                          : null)
                                      as ImageProvider?,
                            child:
                                _profileImage == null && profileImageUrl.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: 39,
                                height: 39,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF7F7F9),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Center(
                                      child: HugeIcon(
                                        icon: HugeIcons.strokeRoundedCamera01,
                                        size: 20,
                                        color: Color(0xFF353232),
                                      ),
                                    ),
                                  ),
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MenuTile(
                          menu: menus[0],
                          showDivider: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(),
                              ),
                            );
                          },
                        ),
                        MenuTile(
                          menu: menus[1],
                          showDivider: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => About(),
                              ),
                            );
                          },
                        ),
                        MenuTile(
                          menu: menus[2],
                          showDivider: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Faqs(),
                              ),
                            );
                          },
                        ),
                        MenuTile(
                          menu: menus[3],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => sendFeedback(),
                              ),
                            );
                          },
                        ),
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MenuTile(
                          menu: menus[4],
                          showDivider: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => changePassword(),
                              ),
                            );
                          },
                        ),
                        MenuTile(
                          menu: menus[5],
                          onTap: _showLogoutConfirmation,
                        ),
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