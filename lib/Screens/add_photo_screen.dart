import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Controllers/album_controller.dart';

class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({Key? key}) : super(key: key);
  @override
  _AddPhotoScreenState createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool _isPublic = false;

  File? _imageFile;
  Uint8List? _webImage; // For web image support

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imageFile = null;
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
          _webImage = null;
        });
      }
    }
  }

  Future<void> _saveAlbum() async {
    if (_formKey.currentState!.validate() && (_imageFile != null || _webImage != null)) {
      final controller = context.read<AlbumController>();

      if (kIsWeb && _webImage != null) {
        await controller.createAlbumWithWebImage(
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          isPublic: _isPublic,
          imageBytes: _webImage!,
        );
      } else if (_imageFile != null) {
        await controller.createAlbumWithPhoto(
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          isPublic: _isPublic,
          imageFile: _imageFile!,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Album Created')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fill all fields and pick an image.')));
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Add Photos'),
      backgroundColor: Colors.teal,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<AlbumController>(
        builder: (context, controller, _) {
          return controller.isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Album Name'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a name' : null,
                      ),
                      TextFormField(
                        controller: _descController,
                        decoration: InputDecoration(labelText: 'Description'),
                      ),
                      SwitchListTile(
                        value: _isPublic,
                        onChanged: (val) => setState(() => _isPublic = val),
                        title: Text('Make Album Public'),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.grey[200],
                          ),
                          child: (_imageFile == null && _webImage == null)
                              ? Center(child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey[700]))
                              : _webImage != null
                                  ? Image.memory(_webImage!, fit: BoxFit.cover)
                                  : Image.file(_imageFile!, fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveAlbum,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text('Save Album', style: TextStyle(fontSize: 16)),
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
