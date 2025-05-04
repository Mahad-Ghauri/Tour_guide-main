import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_application/Controllers/album_controller.dart';

class AddMediaScreen extends StatefulWidget {
  final String albumId;
  const AddMediaScreen({required this.albumId, super.key});

  @override
  State<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  final ImagePicker picker = ImagePicker();

  Future<void> _pickMedia(String type) async {
    final picked =
        type == 'image'
            ? await picker.pickImage(source: ImageSource.gallery)
            : await picker.pickVideo(source: ImageSource.gallery);

    if (picked != null) {
      final controller = context.read<AlbumController>();
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        await controller.uploadMedia(
          albumId: widget.albumId,
          type: type,
          webFile: bytes,
        );
      } else {
        await controller.uploadMedia(
          albumId: widget.albumId,
          type: type,
          file: File(picked.path),
        );
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$type uploaded')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Media"), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.photo),
              label: Text("Add Photo"),
              onPressed: () => _pickMedia('image'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.videocam),
              label: Text("Add Video"),
              onPressed: () => _pickMedia('video'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            Spacer(),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Save Album"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Album saved successfully!')),
                );

                Future.delayed(Duration(seconds: 1), () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home_screen', // replace this with your actual home route
                    (Route<dynamic> route) =>
                        false, // removes all previous routes
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
