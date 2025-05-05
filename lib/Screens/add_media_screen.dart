//  import 'dart:io';
//  import 'dart:typed_data';
//  import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//  import 'package:image_picker/image_picker.dart';
//  import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//  import 'package:tour_guide_application/Controllers/album_controller.dart';
//  import 'package:tour_guide_application/Screens/view_album_screen.dart';

// // class AddMediaScreen extends StatefulWidget {
// //   final String albumId;
// //   const AddMediaScreen({required this.albumId, Key? key}) : super(key: key);

// //   @override
// //   State<AddMediaScreen> createState() => _AddMediaScreenState();
// // }

// // // class _AddMediaScreenState extends State<AddMediaScreen> {
// // //   final ImagePicker picker = ImagePicker();

// // //   Future<void> _pickMedia(String type) async {
// // //     final picked =
// // //         type == 'image'
// // //             ? await picker.pickImage(source: ImageSource.gallery)
// // //             : await picker.pickVideo(source: ImageSource.gallery);

// // //     if (picked != null) {
// // //       final controller = context.read<AlbumController>();
// // //       if (kIsWeb) {
// // //         final bytes = await picked.readAsBytes();
// // //         await controller.uploadMedia(
// // //           albumId: widget.albumId,
// // //           type: type,
// // //           webFile: bytes,
// // //         );
// // //       } else {
// // //         await controller.uploadMedia(
// // //           albumId: widget.albumId,
// // //           type: type,
// // //           file: File(picked.path),
// // //         );
// // //       }

// // //       ScaffoldMessenger.of(
// // //         context,
// // //       ).showSnackBar(SnackBar(content: Text('$type uploaded')));
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text("Add Media"), backgroundColor: Colors.teal),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(
// // //           children: [
// // //             ElevatedButton.icon(
// // //               icon: Icon(Icons.photo),
// // //               label: Text("Add Photo"),
// // //               onPressed: () => _pickMedia('image'),
// // //               style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
// // //             ),
// // //             SizedBox(height: 20),
// // //             ElevatedButton.icon(
// // //               icon: Icon(Icons.videocam),
// // //               label: Text("Add Video"),
// // //               onPressed: () => _pickMedia('video'),
// // //               style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
// // //             ),
// // //             Spacer(),
// // //             ElevatedButton.icon(
// // //               icon: Icon(Icons.save),
// // //               label: Text("Save Album"),
// // //               onPressed: () {
// // //                 ScaffoldMessenger.of(context).showSnackBar(
// // //                   SnackBar(content: Text('Album saved successfully!')),
// // //                 );

// // //                 Future.delayed(Duration(seconds: 1), () {
// // //                   Navigator.pushNamedAndRemoveUntil(
// // //                     context,
// // //                      // replace this with your actual home route
// // //                     (Route<dynamic> route) =>
// // //                         false, // removes all previous routes
// // //                   );
// // //                 });
// // //               },
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: Colors.teal,
// // //                 minimumSize: Size(double.infinity, 50),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }


// // // class AddMediaScreen extends StatefulWidget {
// // //   final String albumId;
// // //   const AddMediaScreen({required this.albumId, Key? key}) : super(key: key);

// // //   @override
// // //   State<AddMediaScreen> createState() => _AddMediaScreenState();
// // // }

// // // class _AddMediaScreenState extends State<AddMediaScreen> {
// // //   final ImagePicker picker = ImagePicker();

// // //   Future<void> _pickMedia(String type) async {
// // //   final picked = type == 'image'
// // //       ? await picker.pickImage(source: ImageSource.gallery)
// // //       : await picker.pickVideo(source: ImageSource.gallery);

// // //   if (picked != null) {
// // //     final controller = context.read<AlbumController>();
// // //     debugPrint('Uploading media for albumId: ${widget.albumId}'); // Log albumId
// // //     if (kIsWeb) {
// // //       final bytes = await picked.readAsBytes();
// // //       await controller.uploadMedia(
// // //         albumId: widget.albumId,
// // //         type: type,
// // //         webFile: bytes,
// // //       );
// // //     } else {
// // //       await controller.uploadMedia(
// // //         albumId: widget.albumId,
// // //         type: type,
// // //         file: File(picked.path),
// // //       );
// // //     }

// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(content: Text('$type uploaded')),
// // //     );
// // //   }
// // // }
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text("Add Media"), backgroundColor: Colors.teal),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Column(
// // //           children: [
// // //             ElevatedButton.icon(
// // //               icon: Icon(Icons.photo),
// // //               label: Text("Add Photo"),
// // //               onPressed: () => _pickMedia('image'),
// // //               style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
// // //             ),
// // //             SizedBox(height: 20),
// // //             ElevatedButton.icon(
// // //               icon: Icon(Icons.videocam),
// // //               label: Text("Add Video"),
// // //               onPressed: () => _pickMedia('video'),
// // //               style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
// // //             ),
// // //             Spacer(),
// // //             ElevatedButton.icon(
// // //               icon: Icon(Icons.save),
// // //               label: Text("Save Album"),
// // //               onPressed: () {
// // //                 ScaffoldMessenger.of(context).showSnackBar(
// // //                   SnackBar(content: Text('Album saved successfully!')),
// // //                 );

// // //                 Future.delayed(Duration(seconds: 1), () {
// // //                   Navigator.push(
// // //                     context,
// // //                     MaterialPageRoute(
// // //                       builder: (_) => ViewAlbumScreen(albumId: widget.albumId),
// // //                     ),
// // //                   );
// // //                 });
// // //               },
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: Colors.teal,
// // //                 minimumSize: Size(double.infinity, 50),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }



// // class _AddMediaScreenState extends State<AddMediaScreen> {
// //   final ImagePicker picker = ImagePicker();
// //   bool _isUploading = false; // Track upload status

// //   Future<void> _pickMedia(String type) async {
// //   final picked = type == 'image'
// //       ? await picker.pickImage(source: ImageSource.gallery)
// //       : await picker.pickVideo(source: ImageSource.gallery);

// //   if (picked != null) {
// //     setState(() {
// //       _isUploading = true;
// //     });
// //     final controller = context.read<AlbumController>();
// //     debugPrint('Uploading media for albumId: ${widget.albumId}');
// //     try {
// //       if (kIsWeb) {
// //         final bytes = await picked.readAsBytes();
// //         debugPrint('Web bytes length: ${bytes.length}');
// //         await controller.uploadMedia(
// //           albumId: widget.albumId,
// //           type: type,
// //           webFile: bytes,
// //         );
// //       } else {
// //         final file = File(picked.path);
// //         debugPrint('File path: ${file.path}');
// //         await controller.uploadMedia(
// //           albumId: widget.albumId,
// //           type: type,
// //           file: file,
// //         );
// //       }
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('$type uploaded')),
// //       );
// //     } catch (e) {
// //       debugPrint('Error in _pickMedia: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error uploading $type: $e')),
// //       );
// //     } finally {
// //       setState(() {
// //         _isUploading = false;
// //       });
// //     }
// //   }
// // }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Add Media"), backgroundColor: Colors.teal),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             ElevatedButton.icon(
// //               icon: Icon(Icons.photo),
// //               label: Text("Add Photo"),
// //               onPressed: _isUploading ? null : () => _pickMedia('image'), // Disable during upload
// //               style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton.icon(
// //               icon: Icon(Icons.videocam),
// //               label: Text("Add Video"),
// //               onPressed: _isUploading ? null : () => _pickMedia('video'), // Disable during upload
// //               style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
// //             ),
// //             Spacer(),
// //             ElevatedButton.icon(
// //               icon: Icon(Icons.save),
// //               label: Text("Save Album"),
// //               onPressed: _isUploading
// //                   ? null // Disable if uploading
// //                   : () {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         SnackBar(content: Text('Album saved successfully!')),
// //                       );

// //                       Future.delayed(Duration(seconds: 1), () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (_) => ViewAlbumScreen(
// //                               albumId: widget.albumId,
// //                             ),
// //                           ),
// //                         );
// //                       });
// //                     },
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.teal,
// //                 minimumSize: Size(double.infinity, 50),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// class AddMediaScreen extends StatefulWidget {
//   const AddMediaScreen({super.key, required String albumId});

//   @override
//   _AddMediaScreenState createState() => _AddMediaScreenState();
// }

// class _AddMediaScreenState extends State<AddMediaScreen> {
//   List<Map<String, dynamic>> mediaItems = [];

//   Future<void> _addMedia(Map<String, dynamic> album) async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'png', 'mp4'],
//       allowMultiple: true,
//     );
//     if (result != null) {
//       final user = Supabase.instance.client.auth.currentUser!;
//       for (var file in result.files) {
//         final filePath = file.path!;
//         final fileName = file.name;
//         final fileObj = File(filePath);

//         // Upload to Supabase Storage
//         await Supabase.instance.client.storage
//             .from('media')
//             .upload('${user.id}/${album['id']}/$fileName', fileObj);

//         // Store metadata in database
//         final response = await Supabase.instance.client.from('media').insert({
//           'album_id': album['id'],
//           'user_id': user.id,
//           'file_path': '${user.id}/${album['id']}/$fileName',
//           'file_type': fileName.endsWith('.mp4') ? 'video' : 'image',
//         }).select().single();

//         setState(() {
//           mediaItems.add(response);
//         });
//       }
//     }
//   }

//   Future<void> _saveAlbum(BuildContext context, Map<String, dynamic> album) async {
//     Navigator.pushNamed(
//       context,
//       '/view_album',
//       arguments: album,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final album = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Media to ${album['title']}'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GridView.builder(
//               padding: const EdgeInsets.all(8.0),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 8.0,
//                 mainAxisSpacing: 8.0,
//                 childAspectRatio: 1.0,
//               ),
//               itemCount: mediaItems.length,
//               itemBuilder: (context, index) {
//                 final item = mediaItems[index];
//                 final url = Supabase.instance.client.storage
//                     .from('media')
//                     .getPublicUrl(item['file_path']);
//                 return Card(
//                   elevation: 2,
//                   child: item['file_type'] == 'image'
//                       ? Image.network(
//                           url,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) =>
//                               const Icon(Icons.error, size: 50, color: Colors.red),
//                         )
//                       : Center(
//                           child: Icon(
//                             Icons.videocam,
//                             size: 50,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () => _addMedia(album),
//                   icon: const Icon(Icons.upload),
//                   label: const Text('Add Media'),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () => _saveAlbum(context, album),
//                   icon: const Icon(Icons.save),
//                   label: const Text('Save Album'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:tour_guide_application/Screens/view_album_screen.dart';

class AddMediaScreen extends StatefulWidget {
  final String albumId;

  const AddMediaScreen({Key? key, required this.albumId}) : super(key: key);

  @override
  _AddMediaScreenState createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  final List<Map<String, dynamic>> _mediaList = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickMedia(ImageSource source, String mediaType) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      _mediaList.add({
        'file': File(pickedFile.path),
        'type': mediaType,
      });
    });
  }

  Future<void> _uploadMedia() async {
    setState(() {
      _isLoading = true;
    });

    final storage = Supabase.instance.client.storage.from('media');

    for (var media in _mediaList) {
      final file = media['file'] as File;
      final type = media['type'] as String;
      final fileBytes = await file.readAsBytes();
      final fileName = const Uuid().v4();
      final filePath = 'media/$fileName';

      final uploadResponse = await storage.uploadBinary(
        filePath,
        fileBytes,
        fileOptions: FileOptions(contentType: 'image/jpeg'),
      );

      final publicUrl = storage.getPublicUrl(filePath);

      await Supabase.instance.client.from('media').insert({
        'album_id': widget.albumId,
        'file_url': publicUrl,
        'type': type,
      });
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ViewAlbumScreen(albumId: widget.albumId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Media'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ElevatedButton(
                  onPressed: () => _pickMedia(ImageSource.gallery, 'image'),
                  child: const Text('Add Photo'),
                ),
                ElevatedButton(
                  onPressed: () => _pickMedia(ImageSource.gallery, 'video'),
                  child: const Text('Add Video'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _mediaList.length,
                    itemBuilder: (context, index) {
                      final media = _mediaList[index];
                      final file = media['file'] as File;
                      final type = media['type'] as String;
                      return ListTile(
                        leading: type == 'image'
                            ? Image.file(file, width: 50, height: 50)
                            : const Icon(Icons.videocam),
                        title: Text(file.path.split('/').last),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _uploadMedia,
                  child: const Text('Save Album'),
                ),
              ],
            ),
    );
  }
}
