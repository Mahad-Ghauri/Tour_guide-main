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
<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
=======
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_application/Controllers/album_controller.dart';
>>>>>>> b0558b231c5ab7b29e5618dfcbbd20374fe96968
import 'package:tour_guide_application/Screens/view_album_screen.dart';

class AddMediaScreen extends StatefulWidget {
  final String albumId;
//<<<<<<< HEAD

  const AddMediaScreen({Key? key, required this.albumId}) : super(key: key);

  const AddMediaScreen.named({required this.albumId, super.key});
//>>>>>>> 7c427a9f8915ce9afcf1b141f060b04009afd099

  @override
  _AddMediaScreenState createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
<<<<<<< HEAD
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

     
=======
  final ImagePicker _picker = ImagePicker();
  final List<MediaItem> _selectedMedia = [];
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _selectedMedia.add(
          MediaItem(
            file: File(image.path),
            type: 'image',
            name: image.name,
          ),
        );
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    
    if (video != null) {
      setState(() {
        _selectedMedia.add(
          MediaItem(
            file: File(video.path),
            type: 'video',
            name: video.name,
          ),
        );
      });
    }
  }

  Future<void> _uploadAll() async {
    if (_selectedMedia.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select media to upload')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final controller = context.read<AlbumController>();
    int successCount = 0;
    
    for (final media in _selectedMedia) {
      final success = await controller.uploadMedia(
        albumId: widget.albumId,
        type: media.type,
        file: media.file,
      );
      
      if (success) successCount++;
    }

    setState(() {
      _isUploading = false;
    });

    final message = successCount == _selectedMedia.length
        ? 'All media uploaded successfully'
        : '$successCount/${_selectedMedia.length} uploads completed';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    // If any files were uploaded successfully, navigate to view the album
    if (successCount > 0) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ViewAlbumScreen(albumId: widget.albumId),
          ),
        );
      }
>>>>>>> b0558b231c5ab7b29e5618dfcbbd20374fe96968
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
<<<<<<< HEAD
        title: const Text('Add Media'),
=======
        title: Text("Add Media"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Media selection buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: _isUploading ? null : _pickImage,
                  icon: Icon(Icons.photo),
                  label: Text("Add Photo"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: _isUploading ? null : _pickVideo,
                  icon: Icon(Icons.videocam),
                  label: Text("Add Video"),
                ),
              ],
            ),
          ),

          // Selected media list
          Expanded(
            child: _selectedMedia.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No media selected",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Use the buttons above to add photos and videos",
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _selectedMedia.length,
                    itemBuilder: (context, index) {
                      final media = _selectedMedia[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: media.type == 'video'
                              ? Icon(Icons.videocam, color: Colors.teal)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.file(
                                    media.file,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          title: Text(
                            media.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(media.type.capitalize()),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: _isUploading
                                ? null
                                : () {
                                    setState(() {
                                      _selectedMedia.removeAt(index);
                                    });
                                  },
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Upload button
          if (_selectedMedia.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isUploading ? null : _uploadAll,
                  icon: _isUploading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.cloud_upload),
                  label: Text(
                    _isUploading
                        ? "Uploading... (${_selectedMedia.length} items)"
                        : "Upload All (${_selectedMedia.length} items)",
                  ),
                ),
              ),
            ),

          // View album button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextButton.icon(
              icon: Icon(Icons.photo_library),
              label: Text("View Album"),
              onPressed: _isUploading
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ViewAlbumScreen(albumId: widget.albumId),
                        ),
                      );
                    },
            ),
          ),
          SizedBox(height: 16),
        ],
>>>>>>> b0558b231c5ab7b29e5618dfcbbd20374fe96968
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

class MediaItem {
  final File file;
  final String type; // 'image' or 'video'
  final String name;

  MediaItem({
    required this.file,
    required this.type,
    required this.name,
  });
}

extension StringExtension on String {
  String capitalize() {
    return this.isEmpty ? '' : '${this[0].toUpperCase()}${this.substring(1)}';
  }
}