// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tour_guide_application/Controllers/album_controller.dart';
// import 'package:tour_guide_application/Screens/add_media_screen.dart';

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

  Future<void> _createAlbum() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              ),
      ),
    );
  }
}
