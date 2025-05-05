// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tour_guide_application/Controllers/album_controller.dart';
// import 'package:tour_guide_application/Screens/add_media_screen.dart';

<<<<<<< HEAD
// // class CreateAlbumScreen extends StatefulWidget {
// //   const CreateAlbumScreen({super.key});

// //   @override
// //   _CreateAlbumScreenState createState() => _CreateAlbumScreenState();
// // }

// // class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _nameController = TextEditingController();
// //   final _descController = TextEditingController();
// //   bool _isPublic = false;

// //   Future<void> _submit() async {
// //     if (_formKey.currentState!.validate()) {
// //       final controller = context.read<AlbumController>();
// //       final albumId = await controller.createAlbum(
// //         name: _nameController.text.trim(),
// //         description: _descController.text.trim(),
// //         isPublic: _isPublic,
// //       );

// //       if (albumId != null) {
// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (_) => AddMediaScreen(albumId: albumId),
// //           ),
// //         );
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Error creating album')),
// //         );
// //       }
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     _descController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Add Album"),
// //         backgroundColor: Colors.teal,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Consumer<AlbumController>(
// //           builder: (context, controller, _) {
// //             return Form(
// //               key: _formKey,
// //               child: ListView(
// //                 children: [
// //                   TextFormField(
// //                     controller: _nameController,
// //                     decoration: const InputDecoration(labelText: 'Album Name'),
// //                     validator: (value) =>
// //                         value!.isEmpty ? 'Enter album name' : null,
// //                   ),
// //                   TextFormField(
// //                     controller: _descController,
// //                     decoration: const InputDecoration(labelText: 'Description'),
// //                     maxLines: 3,
// //                   ),
// //                   SwitchListTile(
// //                     value: _isPublic,
// //                     onChanged: (val) => setState(() => _isPublic = val),
// //                     title: const Text("Make album public"),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   ElevatedButton(
// //                     style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
// //                     onPressed: controller.isLoading ? null : _submit,
// //                     child: controller.isLoading
// //                         ? const CircularProgressIndicator(color: Colors.white)
// //                         : const Text("Create and Add Media"),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }

// class CreateAlbumScreen extends StatefulWidget {
//   const CreateAlbumScreen({super.key});

//   @override
//   _CreateAlbumScreenState createState() => _CreateAlbumScreenState();
// }

// class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descController = TextEditingController();
//   bool _isPublic = false;

//   Future<void> _submit() async {
//     if (_formKey.currentState!.validate()) {
//       final controller = context.read<AlbumController>();
//       final albumId = await controller.createAlbum(
//         name: _nameController.text.trim(),
//         description: _descController.text.trim(),
//         isPublic: _isPublic,
//       );

//       if (albumId != null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => AddMediaScreen(albumId: albumId),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(controller.errorMessage ?? 'Error creating album'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Add Album"),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Consumer<AlbumController>(
//           builder: (context, controller, _) {
//             return Form(
//               key: _formKey,
//               child: ListView(
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(labelText: 'Album Name'),
//                     validator: (value) =>
//                         value!.isEmpty ? 'Enter album name' : null,
//                   ),
//                   TextFormField(
//                     controller: _descController,
//                     decoration: const InputDecoration(labelText: 'Description'),
//                     maxLines: 3,
//                   ),
//                   SwitchListTile(
//                     value: _isPublic,
//                     onChanged: (val) => setState(() => _isPublic = val),
//                     title: const Text("Make album public"),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//                     onPressed: controller.isLoading ? null : _submit,
//                     child: controller.isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text("Create and Add Media"),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tour_guide_application/Screens/add_media_screen.dart';

// class CreateAlbumScreen extends StatefulWidget {
//   const CreateAlbumScreen({Key? key}) : super(key: key);

//   @override
//   _CreateAlbumScreenState createState() => _CreateAlbumScreenState();
// }

// class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   bool _isPublic = true;
//   bool _isLoading = false;

//   Future<void> _createAlbum() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     final userId = Supabase.instance.client.auth.currentUser?.id;
//     if (userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User not logged in')),
//       );
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }

//     final response = await Supabase.instance.client
//         .from('albums')
//         .insert({
//           'name': _nameController.text,
//           'description': _descriptionController.text,
//           'is_public': _isPublic,
//           'created_by': userId,
//         })
//         .select()
//         .single();

//     setState(() {
//       _isLoading = false;
//     });

//     if (response == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error creating album')),
//       );
//       return;
//     }

//     final albumId = response['id'] as String?;
//     if (albumId != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => AddMediaScreen(albumId: albumId),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Album'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: const InputDecoration(labelText: 'Album Name'),
//                       validator: (value) =>
//                           value == null || value.isEmpty ? 'Enter album name' : null,
//                     ),
//                     TextFormField(
//                       controller: _descriptionController,
//                       decoration:
//                           const InputDecoration(labelText: 'Description'),
//                     ),
//                     SwitchListTile(
//                       title: const Text('Public Album'),
//                       value: _isPublic,
//                       onChanged: (value) {
//                         setState(() {
//                           _isPublic = value;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _createAlbum,
//                       child: const Text('Create Album'),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Screens/add_media_screen.dart';

=======
>>>>>>> b0558b231c5ab7b29e5618dfcbbd20374fe96968
class CreateAlbumScreen extends StatefulWidget {
  const CreateAlbumScreen({super.key});

  @override
  _CreateAlbumScreenState createState() => _CreateAlbumScreenState();
}

class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPublic = true;
  bool _isLoading = false;

<<<<<<< HEAD
  Future<void> _createAlbum() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
=======
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
>>>>>>> b0558b231c5ab7b29e5618dfcbbd20374fe96968
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

<<<<<<< HEAD
    final response = await Supabase.instance.client
        .from('albums')
        .insert({
          'name': _nameController.text,
          'description': _descriptionController.text,
          'is_public': _isPublic,
          'created_by': userId,
        })
        .select()
        .single();

    setState(() {
      _isLoading = false;
    });

    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error creating album')),
      );
      return;
    }

    final albumId = response['id'] as String?;
    if (albumId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddMediaScreen(albumId: albumId),
        ),
      );
=======
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
>>>>>>> b0558b231c5ab7b29e5618dfcbbd20374fe96968
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: const Text('Create Album'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Album Name'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter album name' : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    SwitchListTile(
                      title: const Text('Public Album'),
                      value: _isPublic,
                      onChanged: (value) {
                        setState(() {
                          _isPublic = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _createAlbum,
                      child: const Text('Create Album'),
                    ),
                  ],
                ),
=======
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
>>>>>>> b0558b231c5ab7b29e5618dfcbbd20374fe96968
              ),
      ),
    );
  }
}