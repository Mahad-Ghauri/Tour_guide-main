

// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'locations/tomb_info_screen.dart'; // Existing screen
import 'locations/ghanta_ghar_info_screen.dart'; // New screen for Ghanta Ghar
import 'locations/khoni_burj_info_screen.dart'; // New screen for Khoni Burj

class DestinationReachedScreen extends StatefulWidget {
  final String placeName;

  const DestinationReachedScreen({
    super.key,
    required this.placeName,
  });

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

    // Define hardcoded QR code values
    const tombQrCode = 'multan_tombs';
    const ghantaGharQrCode = 'multan_ghanta_ghar';
    const khoniBurjQrCode = 'multan_khoni_burj';

    // Check which QR code was scanned and navigate accordingly
    if (result == tombQrCode) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TombInfoScreen()),
      );
    } else if (result == ghantaGharQrCode) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GhantaGharInfoScreen()),
      );
    } else if (result == khoniBurjQrCode) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => KhoniBurjInfoScreen()),
      );
    } else {
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
                SizedBox(
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