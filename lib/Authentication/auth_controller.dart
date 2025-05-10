import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Interface/interface.dart';
import 'package:tour_guide_application/Screens/home_screen.dart';

class AuthenticationController extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  // ----------------- SIGN IN METHOD -----------------
  Future<void> signInWithEmailPassword(
    String email,
    String password,
    BuildContext context, {required TextEditingController controller}
  ) async {
    try {
      _setLoading(true);
      _setError(null);

      log('Attempting to sign in with email: $email');
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (!context.mounted) return;

      if (response.user != null) {
        log('Sign in successful for user: ${response.user!.email}');
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        log('Sign in failed: No user returned in response');
        _setError('Login failed: Invalid credentials');
      }
    } on AuthException catch (e) {
      log('Auth exception during sign in: ${e.message}');
      _setError('Login failed: ${e.message}');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login failed: ${e.message}')));
      }
    } catch (e) {
      log('Unexpected error during sign in: $e');
      _setError('An unexpected error occurred');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  // ----------------- SIGN UP METHOD -----------------
  Future<void> signUpWithEmailPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      _setLoading(true);
      _setError(null);

      log('Attempting to sign up with email: $email');
      // Remove email confirmation by setting emailRedirectTo to null
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
        // No email confirmation required
        emailRedirectTo: null,
      );

      if (!context.mounted) return;

      if (response.user != null) {
        log('Sign up successful for user: ${response.user!.email}');
        // Navigate directly to HomeScreen after successful signup
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        log('Sign up failed: No user returned in response');
        _setError('Sign up failed: Please try again');
      }
    } on AuthException catch (e) {
      log('Auth exception during sign up: ${e.message}');
      if (context.mounted) {
        if (e.message.toLowerCase().contains('already exists') ||
            e.message.toLowerCase().contains('already registered')) {
          _setError('Email already exists');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Email already exists')));
        } else {
          _setError('Sign up failed: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign up failed: ${e.message}')),
          );
        }
      }
    } catch (e) {
      log('Unexpected error during sign up: $e');
      _setError('An unexpected error occurred');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  // ----------------- SIGN OUT METHOD -----------------
  Future<void> signOut(BuildContext context) async {
    try {
      _setLoading(true);
      _setError(null);

      log('Attempting to sign out');
      await supabase.auth.signOut();

      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
      log('Sign out successful');
    } catch (e) {
      log('Sign out error: $e');
      _setError('Failed to sign out');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to sign out')));
      }
    } finally {
      _setLoading(false);
    }
  }

  // ----------------- GET CURRENT USER EMAIL -----------------
  String? getCurrentUserEmail() {
    return supabase.auth.currentUser?.email;
  }

  // ----------------- CHECK SESSION -----------------
  bool hasValidSession() {
    final session = supabase.auth.currentSession;
    return session != null && !session.isExpired;
  }
}