import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_application/Controllers/album_controller.dart';
import 'package:tour_guide_application/Screens/add_media_screen.dart';

class CreateAlbumScreen extends StatefulWidget {
  const CreateAlbumScreen({super.key});

  @override
  State<CreateAlbumScreen> createState() => _CreateAlbumScreenState();
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
    // Hide keyboard
    FocusScope.of(context).unfocus();
    
    if (_formKey.currentState!.validate()) {
      final controller = context.read<AlbumController>();
      
      final albumId = await controller.createAlbum(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        isPublic: _isPublic,
      );

      if (albumId != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddMediaScreen(albumId: albumId),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating album')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Album"), 
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<AlbumController>(
          builder: (context, controller, _) {
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Album icon
                  Center(
                    child: Icon(
                      Icons.photo_album,
                      size: 80,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Album name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
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
                  SizedBox(height: 16),
                  
                  // Album description
                  TextFormField(
                    controller: _descController,
                    decoration: InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'Describe your album',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16),
                  
                  // Public toggle
                  SwitchListTile(
                    value: _isPublic,
                    onChanged: controller.isLoading 
                        ? null 
                        : (val) => setState(() => _isPublic = val),
                    title: Text("Make album public"),
                    subtitle: Text(
                      "Public albums can be viewed by other users",
                    ),
                    secondary: Icon(
                      _isPublic ? Icons.public : Icons.lock,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Create button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: controller.isLoading ? null : _submit,
                    child: controller.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Create and Add Media",
                            style: TextStyle(fontSize: 16),
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