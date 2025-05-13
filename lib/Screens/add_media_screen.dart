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

  @override
  void initState() {
    super.initState();
    if (widget.albumId.trim().isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid album ID. Returning to previous screen.')),
        );
        Navigator.of(context).pop();
      });
    }
  }

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
        title: const Text(
          "Add Media",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF559CB2),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[50]!,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue[100]!.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Add Photos & Videos",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF559CB2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMediaButton(
                        icon: Icons.photo,
                        label: "Add Photo",
                        onPressed: () => _pickMedia('image'),
                      ),
                      _buildMediaButton(
                        icon: Icons.videocam,
                        label: "Add Video",
                        onPressed: () => _pickMedia('video'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _selectedMedia.isEmpty
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue[100]!.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, 
                              size: 80, 
                              color: Colors.blue[200],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No media selected",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Use the buttons above to add photos and videos",
                              style: TextStyle(
                                color: Colors.blue[400],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _selectedMedia.length,
                      itemBuilder: (context, index) {
                        final media = _selectedMedia[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue[100]!.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blue[50],
                              ),
                              child: media.type == 'video'
                                  ? Icon(Icons.videocam, 
                                      color: Colors.blue[400],
                                      size: 30,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        media.file,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            title: Text(
                              media.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              media.type.capitalize(),
                              style: TextStyle(
                                color: Colors.blue[400],
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red[400],
                              ),
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
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF559CB2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
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
                      : const Icon(Icons.cloud_upload, color: Colors.white),
                  label: Text(
                    _isUploading
                        ? "Uploading... (${_selectedMedia.length} items)"
                        : "Upload All (${_selectedMedia.length} items)",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 140,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF559CB2),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: _isUploading ? null : onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MediaItem {
  final File file;
  final String type;
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