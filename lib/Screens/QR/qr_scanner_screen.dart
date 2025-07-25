// import 'package:flutter/material.dart';
// import 'package:tour_guide_application/Screens/qr_scanner_screen.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';


// class QRScannerScreen extends StatefulWidget {
//   final String placeName;

//   const QRScannerScreen({Key? key, required this.placeName}) : super(key: key);

//   @override
//   State<QRScannerScreen> createState() => _QRScannerScreenState();
// }

// class _QRScannerScreenState extends State<QRScannerScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   String? scannedData;

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       if (scannedData == null) {
//         setState(() {
//           scannedData = scanData.code;
//         });
//         controller.pauseCamera();
//         Navigator.pop(context, scannedData);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Scan QR at ${widget.placeName}'),
//         backgroundColor: const Color(0xFF559CB2),
//       ),
//       body: QRView(
//         key: qrKey,
//         onQRViewCreated: _onQRViewCreated,
//         overlay: QrScannerOverlayShape(
//           borderColor: Colors.blueAccent,
//           borderRadius: 12,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: 250,
//         ),
//       ),
//     );
//   }
// }
