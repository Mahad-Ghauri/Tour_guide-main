import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({super.key});

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      debugPrint("Picked image: ${pickedFile.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Photo')),
      body: Center(
        child: GestureDetector(
          onTap: _pickImage,
          child: _image == null
              ? const Icon(Icons.add_a_photo, size: 100, color: Colors.grey)
              : Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
