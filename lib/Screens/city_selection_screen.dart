import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:tour_guide_application/Controllers/city_controller.dart';
// Assume storeCityInSupabase exists

class CitySelectionScreen extends StatefulWidget {
  const CitySelectionScreen({super.key});

  @override
  State<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'CityChannel',
            onMessageReceived: (message) async {
              final selectedCity = message.message;
              print("Selected City: $selectedCity");

              // Store the selected city in Supabase
              await CityController().storeCityInSupabase(selectedCity);

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("City '$selectedCity' stored in Supabase"),
                ),
              );

              // Navigate back to the home screen after storing the city
              Navigator.pop(context,
              'homescreen'); // This will take you back to the previous screen (HomeScreen)
            },
          )
          ..loadFlutterAsset('assets/cities.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select a City',
          style: TextStyle(color: Colors.white), // Set font color to white
        ),
        backgroundColor: const Color(0xFF559CB2), // Match logo screen background color
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Set arrow color to white
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WebViewWidget(controller: _controller), // Only keep the WebView
      ),
    );
  }
}
