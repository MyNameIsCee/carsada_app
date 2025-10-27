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
      return null;
    }
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      print('=== LOGIN ATTEMPT STARTED ===');
      print('Email: $email');
      
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('Login successful!');
      print('User email: ${credential.user?.email}');
      print('User UID: ${credential.user?.uid}');
      print('=== LOGIN ATTEMPT COMPLETED ===');
      
      return credential.user;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      print('=== LOGOUT ATTEMPT STARTED ===');
      await _auth.signOut();
      print("User signed out successfully");
      print('=== LOGOUT ATTEMPT COMPLETED ===');
    } catch (e) {
      print("Sign out error: $e");
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // will keep the user logged in
  Stream<User?> get authStateChanges => _auth.authStateChanges();


  Widget buildAuthWrapper() {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        print('Connection state: ${snapshot.connectionState}');
        print('Has data: ${snapshot.hasData}');
        print('Data: ${snapshot.data?.email ?? "No user"}');
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('Showing splash waiting for auth state');
          return const Splash();
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          print('User authenticated, going to HomeScreen');
          return const HomeScreen();
        }
        
        print('User not authenticated, going to LandingPage');
        return const LandingPage();
      },
    );
  }
}

class _AuthWrapperWithSplash extends StatefulWidget {
  @override
  _AuthWrapperWithSplashState createState() => _AuthWrapperWithSplashState();
}

class _AuthWrapperWithSplashState extends State<_AuthWrapperWithSplash> {
  bool _splashCompleted = false;
  User? _user;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    
    await Future.delayed(Duration(milliseconds: 500));
    
    final currentUser = FirebaseAuth.instance.currentUser;
    print('Initial auth state: ${currentUser?.email ?? "No user"}');
    print('User UID: ${currentUser?.uid ?? "No UID"}');
    print('User isEmailVerified: ${currentUser?.emailVerified ?? false}');
    
    if (mounted) {
      setState(() {
        _user = currentUser;
        _isInitializing = false;
      });
    }

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
      print('New user: ${user?.email ?? "No user"}');
      print('User UID: ${user?.uid ?? "No UID"}');
      print('Previous user: ${_user?.email ?? "No previous user"}');
      
      if (mounted) {
        setState(() {
          _user = user;
        });
        print('State updated with new user');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('_isInitializing: $_isInitializing');
    print('_splashCompleted: $_splashCompleted');
    print('_user: ${_user?.email ?? "No user"}');
    
    if (_isInitializing || !_splashCompleted) {
      print('Showing splash screen');
      return const Splash();
    }

    if (_user != null) {
      print('FirebaseAuthServices: User is signed in: ${_user!.email}');
      print('FirebaseAuthServices: User UID: ${_user!.uid}');
      print('Navigating to HomeScreen');
      return const HomeScreen();
    } else {
      print('FirebaseAuthServices: User is currently signed out!');
      print('Navigating to LandingPage');
      return const LandingPage();
    }
  }
}