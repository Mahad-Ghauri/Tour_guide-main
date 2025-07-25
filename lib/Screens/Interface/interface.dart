import 'package:flutter/material.dart';

class InterfaceScreen extends StatefulWidget {
  static final String id = 'Interface';
  const InterfaceScreen({super.key});

  @override
  State<InterfaceScreen> createState() => _InterfaceScreenState();
}

class _InterfaceScreenState extends State<InterfaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Interface Page',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


