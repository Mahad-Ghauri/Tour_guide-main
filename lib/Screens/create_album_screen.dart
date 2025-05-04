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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final controller = context.read<AlbumController>();
      final albumId = await controller.createAlbum(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        isPublic: _isPublic,
      );

      if (albumId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddMediaScreen(albumId: albumId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error creating album')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Album"), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<AlbumController>(
          builder: (context, controller, _) {
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Album Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter album name' : null,
                  ),
                  TextFormField(
                    controller: _descController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  SwitchListTile(
                    value: _isPublic,
                    onChanged: (val) => setState(() => _isPublic = val),
                    title: Text("Make album public"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    onPressed: controller.isLoading ? null : _submit,
                    child: Text("Create and Add Media"),
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
