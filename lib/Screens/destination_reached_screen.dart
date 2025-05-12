// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'destination_info_screen.dart';

// class DestinationReachedScreen extends StatefulWidget {
//   final String placeName;

//   const DestinationReachedScreen({
//     Key? key,
//     required this.placeName,
//   }) : super(key: key);

//   @override
//   _DestinationReachedScreenState createState() => _DestinationReachedScreenState();
// }

// class _DestinationReachedScreenState extends State<DestinationReachedScreen> with WidgetsBindingObserver {
//   bool _isScanning = false;
//   late final MobileScannerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _controller = MobileScannerController();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && _isScanning) {
//       setState(() {
//         _isScanning = false;
//       });
//     }
//   }

//   void _onQRCodeScanned(String result) async {
//     setState(() {
//       _isScanning = true;
//     });

//     try {
//       final decoded = jsonDecode(result) as Map<String, dynamic>;

//       if (!decoded.containsKey('placeId') || !decoded.containsKey('placeName')) {
//         throw FormatException('Missing placeId or placeName in QR data');
//       }

//       final scannedPlaceName = decoded['placeName'] as String?;
//       final placeId = decoded['placeId'] as String?;

//       if (scannedPlaceName == null || placeId == null) {
//         throw FormatException('Invalid data types in QR');
//       }

//       if (scannedPlaceName == widget.placeName) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DestinationInfoScreen(placeId: placeId),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('This QR is not for ${widget.placeName}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Invalid QR code format or data: $e')),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isScanning = false;
//         });
//       }
//     }
//   }

//   void _startQrScan() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         contentPadding: EdgeInsets.zero,
//         content: AspectRatio(
//           aspectRatio: 1,
//           child: MobileScanner(
//             controller: _controller,
//             onDetect: (barcode) {
//               if (barcode.barcodes.isNotEmpty) {
//                 final String? value = barcode.barcodes.first.rawValue;
//                 if (value != null && !_isScanning) {
//                   Navigator.of(context).pop(); // Close dialog
//                   _onQRCodeScanned(value);
//                 }
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

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
//                 Text(
//                   'Destination Reached!',
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 0.5,
//                       ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     'You have arrived at ${widget.placeName}',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w500,
//                         ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Container(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _isScanning ? null : _startQrScan,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: const Color(0xFF559CB2),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 2,
//                     ),
//                     child: Text(
//                       _isScanning ? 'Scanning...' : 'Scan QR Code',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
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
import 'tomb_info_screen.dart'; // New screen import

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
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
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

  void _onQRCodeScanned(String result) async {
    setState(() {
      _isScanning = true;
    });

    // Hardcoded QR code value to match
    const expectedQrCode = 'multan_tombs';

    // Check if the scanned QR code matches the hardcoded value
    if (result == expectedQrCode) {
      // Navigate to the new screen with hardcoded tomb data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TombInfoScreen(),
        ),
      );
    } else {
      // Show a message if the QR code doesn't match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid QR code for this location')),
      );
    }

    // Reset the scanning state
    if (mounted) {
      setState(() {
        _isScanning = false;
      });
    }
  }

  void _startQrScan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: AspectRatio(
          aspectRatio: 1,
          child: MobileScanner(
            controller: _controller,
            onDetect: (barcode) {
              if (barcode.barcodes.isNotEmpty) {
                final String? value = barcode.barcodes.first.rawValue;
                if (value != null && !_isScanning) {
                  Navigator.of(context).pop(); // Close dialog
                  _onQRCodeScanned(value);
                }
              }
            },
          ),
        ),
      ),
    );
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
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