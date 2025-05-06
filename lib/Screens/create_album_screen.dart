import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_application/Controllers/album_controller.dart';
import 'package:tour_guide_application/Screens/add_media_screen.dart';

class CreateAlbumScreen extends StatefulWidget {
  const CreateAlbumScreen({super.key});

  @override
  _CreateAlbumScreenState createState() => _CreateAlbumScreenState();
}

class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool _isPublic = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus(); // Hide keyboard

    if (_formKey.currentState!.validate()) {
      final controller = context.read<AlbumController>();

      final albumId = await controller.createAlbum(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        isPublic: _isPublic,
      );

      if (albumId == null || albumId.trim().isEmpty) {
        print('Error: Failed to create album, albumId is null or empty');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  controller.errorMessage ?? 'Error creating album. Please try again.'),
            ),
          );
        }
        return;
      }

      print('Navigating to AddMediaScreen with albumId: $albumId');
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddMediaScreen(albumId: albumId),
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
          "Create Album",
          style: TextStyle(color: Colors.white), // Set font color to white
        ),
        backgroundColor: const Color(0xFF559CB2), // Match logo screen background color
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Set arrow color to white
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<AlbumController>(
          builder: (context, controller, _) {
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Album name input
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Album Name',
                      hintText: 'Enter a name for your album',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an album name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Album description input
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'Describe your album',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Public toggle
                  SwitchListTile(
                    value: _isPublic,
                    onChanged: controller.isLoading
                        ? null
                        : (val) => setState(() => _isPublic = val),
                    title: const Text("Make album public"),
                    subtitle:
                        const Text("Public albums can be viewed by other users"),
                    secondary: Icon(
                      _isPublic ? Icons.public : Icons.lock,
                      color: const Color(0xFF559CB2), // Match logo screen color
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Create button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF559CB2), // Match logo screen button color
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: controller.isLoading ? null : _submit,
                    child: controller.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Create and Add Media",
                            style: TextStyle(fontSize: 16, color: Colors.white), // Set font color to white
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}