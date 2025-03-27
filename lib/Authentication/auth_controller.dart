import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Interface/interface.dart';
import 'package:tour_guide_application/Screens/home_screen.dart';

class AuthenticationController {
  final supabase = Supabase.instance.client;

  // ----------------- SIGN IN METHOD -----------------
  Future<void> signInWithEmailPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.message}')),
      );
    } catch (e) {
      log('Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

  // ----------------- SIGN UP METHOD -----------------
  Future<void> signUpWithEmailPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const InterfaceScreen()),
        );
      }
    } on AuthException catch (e) {
      // Check if the error indicates that the email already exists
      if (e.message.toLowerCase().contains('already exists') ||
          e.message.toLowerCase().contains('already registered')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email already exists')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${e.message}')),
        );
      }
    } catch (e) {
      log('Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

  // ----------------- SIGN OUT METHOD -----------------
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      log('Sign out error: $e');
    }
  }

  // ----------------- GET CURRENT USER EMAIL -----------------
  String? getCurrentUserEmail() {
    return supabase.auth.currentUser?.email;
  }
}