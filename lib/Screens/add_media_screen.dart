import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_application/Controllers/album_controller.dart';
import 'package:tour_guide_application/Screens/view_album_screen.dart';

class AddMediaScreen extends StatefulWidget {
  final String albumId;

  const AddMediaScreen({Key? key, required this.albumId}) : super(key: key);

  @override
  _AddMediaScreenState createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<MediaItem> _selectedMedia = [];
  bool _isUploading = false;

  Future<void> _pickMedia(String type) async {
    final XFile? pickedFile = type == 'image'
        ? await _picker.pickImage(source: ImageSource.gallery)
        : await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedMedia.add(
          MediaItem(
            file: File(pickedFile.path),
            type: type,
            name: pickedFile.name,
          ),
        );
      });
    }
  }

  Future<void> _uploadAll() async {
    if (_selectedMedia.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select media to upload')),
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

    if (successCount > 0) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ViewAlbumScreen(albumId: widget.albumId),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Media"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: _isUploading ? null : () => _pickMedia('image'),
                  icon: const Icon(Icons.photo),
                  label: const Text("Add Photo"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: _isUploading ? null : () => _pickMedia('video'),
                  icon: const Icon(Icons.videocam),
                  label: const Text("Add Video"),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedMedia.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
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
                    padding: const EdgeInsets.all(16),
                    itemCount: _selectedMedia.length,
                    itemBuilder: (context, index) {
                      final media = _selectedMedia[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: media.type == 'video'
                              ? const Icon(Icons.videocam, color: Colors.teal)
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
                            icon: const Icon(Icons.delete, color: Colors.red),
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
          if (_selectedMedia.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isUploading ? null : _uploadAll,
                  icon: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.cloud_upload),
                  label: Text(
                    _isUploading
                        ? "Uploading... (${_selectedMedia.length} items)"
                        : "Upload All (${_selectedMedia.length} items)",
                  ),
                ),
              ),
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
    return isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
  }
}