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

              await CityController().storeCityInSupabase(selectedCity);

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("City '$selectedCity' stored in Supabase"),
                ),
              );
            },
          )
          ..loadFlutterAsset('assets/cities.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a City'),
        backgroundColor: Colors.teal,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../../Controllers/city_controller.dart';

// class CitySelectionScreen extends StatefulWidget {
//   final String selectedCountry;
//   const CitySelectionScreen({super.key, required this.selectedCountry});

//   @override
//   State<CitySelectionScreen> createState() => _CitySelectionScreenState();
// }

// class _CitySelectionScreenState extends State<CitySelectionScreen> {
//   late final WebViewController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..addJavaScriptChannel(
//         'CityChannel',
//         onMessageReceived: (message) {
//           final city = message.message;
//           Provider.of<CityController>(context, listen: false)
//               .saveCity(widget.selectedCountry, city);
//           Navigator.pop(context); // Go back or to the next screen
//         },
//       )
//       ..loadFlutterAsset('assets/pakistan_cities.html');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Select City in ${widget.selectedCountry}')),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }

