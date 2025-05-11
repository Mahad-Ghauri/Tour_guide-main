import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class QRScannerScreen extends StatefulWidget {
  final String placeName;

  const QRScannerScreen({
    Key? key,
    required this.placeName,
  }) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final _supabase = Supabase.instance.client;
  bool isProcessing = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _saveQRDataToSupabase(String qrData) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Parse QR data (assuming it's in JSON format)
      Map<String, dynamic> qrDataMap;
      try {
        qrDataMap = Map<String, dynamic>.from(
          qrData.startsWith('{') ? 
            Map<String, dynamic>.from(
              Map<String, dynamic>.from(
                qrData as Map<String, dynamic>
              )
            ) : 
            {'raw_data': qrData}
        );
      } catch (e) {
        qrDataMap = {'raw_data': qrData};
      }

      // Prepare data for Supabase
      final Map<String, dynamic> locationData = {
        'user_id': userId,
        'place_name': widget.placeName,
        'scanned_at': DateTime.now().toIso8601String(),
        'location_data': qrDataMap,
        'status': 'verified',
        'metadata': {
          'device_info': {
            'platform': Platform.operatingSystem,
            'version': Platform.operatingSystemVersion,
          },
          'scan_timestamp': DateTime.now().toIso8601String(),
        }
      };

      // Insert into locations table
      final response = await _supabase
          .from('locations')
          .insert(locationData)
          .select()
          .single();

      print('Location data saved to Supabase successfully: $response');

      // Create a record in location_visits table
      await _supabase.from('location_visits').insert({
        'user_id': userId,
        'location_id': response['id'],
        'visited_at': DateTime.now().toIso8601String(),
        'visit_type': 'qr_scan',
        'status': 'completed'
      });

      print('Visit record created successfully');

    } catch (e) {
      print('Error saving data to Supabase: $e');
      rethrow;
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null && !isProcessing) {
        setState(() {
          isProcessing = true;
        });
        
        try {
          await controller.pauseCamera();
          await _saveQRDataToSupabase(scanData.code!);
          
          if (mounted) {
            _showScannedInfo(scanData.code!);
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error processing QR code: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } finally {
          setState(() {
            isProcessing = false;
          });
        }
      }
    });
  }

  void _showScannedInfo(String data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Location Verified'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Place: ${widget.placeName}'),
            const SizedBox(height: 8),
            Text('Status: Verified'),
            const SizedBox(height: 8),
            Text('Data: $data'),
            const SizedBox(height: 16),
            const Text(
              'Your visit has been recorded successfully!',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller?.resumeCamera();
            },
            child: const Text('Scan Another'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to destination screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.blue.shade900,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          if (isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Scan the QR code at ${widget.placeName} to verify your visit',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 