import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carsada_app/screens/landing_page.dart';
import 'package:carsada_app/screens/commuter/home_screen.dart';
import 'package:carsada_app/screens/splash.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'username': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      
      return credential.user;
    } catch (e) {
     // print("Signup error: $e");
      return null;
    }
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
     // print("Login error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
     // print("User signed out successfully");
    } catch (e) {
      //print("Sign out error: $e");
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // will keep the user logged in
  Stream<User?> get authStateChanges => _auth.authStateChanges();


  Widget buildAuthWrapper() {
    return _AuthWrapperWithSplash();
  }
}

class _AuthWrapperWithSplash extends StatefulWidget {
  @override
  _AuthWrapperWithSplashState createState() => _AuthWrapperWithSplashState();
}

class _AuthWrapperWithSplashState extends State<_AuthWrapperWithSplash> {
  bool _splashCompleted = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _startSplashTimer();
    _listenToAuthChanges();
  }

  void _startSplashTimer() {
    Future.delayed(Duration(seconds: 3), () {  //splash duration
      if (mounted) {
        setState(() {
          _splashCompleted = true;
        });
      }
    });
  }

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _user = user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_splashCompleted) {
      return const Splash();
    }

    if (_user != null) {
     // print('FirebaseAuthServices: User is signed in: ${_user!.email}');
    // print('FirebaseAuthServices: User UID: ${_user!.uid}');
      return const HomeScreen();
    } else {
    //  print('FirebaseAuthServices: User is currently signed out!');
      return const LandingPage();
    }
  }
}