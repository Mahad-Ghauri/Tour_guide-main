import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_application/Authentication/auth_controller.dart';
import 'package:tour_guide_application/Screens/Authentication Screens/signup_screen.dart';
import 'package:tour_guide_application/Controllers/input_controllers.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'Login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final InputControllers _inputControllers = InputControllers();

  @override
  void dispose() {
    _inputControllers.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authController = Provider.of<AuthenticationController>(
        context,
        listen: false,
      );
      await authController.signInWithEmailPassword(
        _inputControllers.emailController.text,
        _inputControllers.passwordController.text,
        context,
        controller: _inputControllers.emailController,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF559CB2);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, primaryColor.withOpacity(0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Upper-right bubble
            Positioned(
              top: -120,
              right: -120,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(175),
                ),
                child: Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Lower-left bubble
            Positioned(
              bottom: -150,
              left: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(125),
                    ),
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Main content scrollable and centered
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),

                      // Logo
                      Image.asset(
                        'assets/images/logo.png',
                        height: 180,
                        width: 180,
                      ),
                      const SizedBox(height: 20),

                      // Login Form Box
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Welcome Back",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Hey! Good to see you again",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Email Field
                              TextFormField(
                                controller: _inputControllers.emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: primaryColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Password Field
                              TextFormField(
                                controller:
                                    _inputControllers.passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: primaryColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Remember Me & Forgot Password
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Transform.scale(
                                        scale: 0.9,
                                        child: Checkbox(
                                          value: true,
                                          onChanged: (_) {},
                                          activeColor: primaryColor,
                                        ),
                                      ),
                                      const Text(
                                        "Remember me",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Forgot password functionality
                                    },
                                    child: Text(
                                      "Forgot password?",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Sign In Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: const Text(
                                    "SIGN IN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Sign up redirect
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account? "),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Sign up",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}