// // lib/screens/create_album_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../controllers/album_controller.dart';

// class CreateAlbumScreen extends StatefulWidget {
//   const CreateAlbumScreen({super.key});

//   @override
//   State<CreateAlbumScreen> createState() => _CreateAlbumScreenState();
// }

// class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
//   final _nameCtrl = TextEditingController();
//   final _descCtrl = TextEditingController();
//   bool _isPublic = false;

//   @override
//   Widget build(BuildContext context) {
//     final albumCtrl = context.read<AlbumController>();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Album', style: GoogleFonts.urbanist()),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           TextField(
//             controller: _nameCtrl,
//             decoration: InputDecoration(labelText: 'Album Name'),
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: _descCtrl,
//             decoration: InputDecoration(labelText: 'Description'),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               const Text('Public'),
//               Switch(
//                 value: _isPublic,
//                 onChanged: (v) => setState(() => _isPublic = v),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () async {
//               await albumCtrl.storeAlbum(
//                 name: _nameCtrl.text.trim(),
//                 description: _descCtrl.text.trim(),
//                 isPublic: _isPublic,
//               );
//               Navigator.pop(context);
//             },
//             child: const Text('Create Album'),
//           )
//         ]),
//       ),
//     );
//   }
// }
