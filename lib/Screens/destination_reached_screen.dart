// import 'package:flutter/material.dart';

// class DestinationReachedScreen extends StatelessWidget {
//   final String placeName;

//   const DestinationReachedScreen({
//     Key? key,
//     required this.placeName,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF559CB2), Color(0xFFB3E5FC)],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               children: [
//                 const SizedBox(height: 40),
//                 // Celebration Icon
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.flag_circle,
//                     size: 100,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 // Title
//                 Text(
//                   'Destination Reached!',
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 0.5,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 // Place Name
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     'You have arrived at $placeName',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const Spacer(),
//                 // Return Button
//                 Container(
//                   width: double.infinity,
//                   margin: const EdgeInsets.only(bottom: 40),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).popUntil((route) => route.isFirst);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: const Color(0xFF559CB2),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 2,
//                     ),
//                     child: const Text(
//                       'Return to Home',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// } 

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'destination_info_screen.dart';

class DestinationReachedScreen extends StatefulWidget {
  final String placeName;

  const DestinationReachedScreen({
    Key? key,
    required this.placeName,
  }) : super(key: key);

  @override
  _DestinationReachedScreenState createState() => _DestinationReachedScreenState();
}

class _DestinationReachedScreenState extends State<DestinationReachedScreen> with WidgetsBindingObserver {
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isScanning) {
      setState(() {
        _isScanning = false;
      });
    }
  }

  void _startQrScan() async {
    setState(() {
      _isScanning = true;
    });

    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Scan QR Code')),
            body: MobileScanner(
              onDetect: (capture) {
                final barcode = capture.barcodes.first;
                if (barcode.rawValue != null) {
                  Navigator.pop(context, barcode.rawValue);
                }
              },
            ),
          ),
        ),
      );

      if (result != null && mounted) {
        try {
          final decoded = jsonDecode(result) as Map<String, dynamic>;
          final scannedPlaceName = decoded['placeName'] as String?;
          if (scannedPlaceName == widget.placeName) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DestinationInfoScreen(
                  placeId: decoded['placeId'] as String,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid QR code for this destination')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid QR code format')),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF559CB2), Color(0xFFB3E5FC)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Celebration Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.flag_circle,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                Text(
                  'Destination Reached!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Place Name
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'You have arrived at ${widget.placeName}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                // QR Scan Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isScanning ? null : _startQrScan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF559CB2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      _isScanning ? 'Scanning...' : 'Scan QR Code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Return Button
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF559CB2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Return to Home',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
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