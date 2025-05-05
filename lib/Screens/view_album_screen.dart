// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';

// // class ViewAlbumScreen extends StatefulWidget {
// //   final String albumId;
// //   const ViewAlbumScreen({required this.albumId, Key? key}) : super(key: key);

// //   @override
// //   State<ViewAlbumScreen> createState() => _ViewAlbumScreenState();
// // }

// // class _ViewAlbumScreenState extends State<ViewAlbumScreen> {
// //   final SupabaseClient _supabase = Supabase.instance.client;

// //   Future<List<Map<String, dynamic>>> _fetchMedia() async {
// //     final res = await _supabase
// //         .from('media')
// //         .select()
// //         .eq('album_id', widget.albumId)
// //         .order('id');

// //     return List<Map<String, dynamic>>.from(res);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("View Album"),
// //         backgroundColor: Colors.teal,
// //       ),
// //       body: FutureBuilder<List<Map<String, dynamic>>>(
// //         future: _fetchMedia(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           }

// //           if (snapshot.hasError) {
// //             return Center(child: Text("Error loading media."));
// //           }

// //           final media = snapshot.data ?? [];

// //           if (media.isEmpty) {
// //             return Center(
// //               child: Text(
// //                 "No media found.",
// //                 style: TextStyle(fontSize: 18, color: Colors.grey),
// //               ),
// //             );
// //           }

// //           return GridView.builder(
// //             padding: EdgeInsets.all(12),
// //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //               crossAxisCount: 2,
// //               crossAxisSpacing: 10,
// //               mainAxisSpacing: 10,
// //             ),
// //             itemCount: media.length,
// //             itemBuilder: (context, index) {
// //               final item = media[index];
// //               final isVideo = item['type'] == 'video';

// //               return Card(
// //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                 elevation: 3,
// //                 child: isVideo
// //                     ? Center(child: Icon(Icons.videocam, size: 40, color: Colors.teal))
// //                     : ClipRRect(
// //                         borderRadius: BorderRadius.circular(12),
// //                         child: Image.network(
// //                           item['file_url'],
// //                           fit: BoxFit.cover,
// //                           width: double.infinity,
// //                           height: double.infinity,
// //                         ),
// //                       ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';

// import 'package:tour_guide_application/widgets/vedio_palyer_widget.dart';

// // class ViewAlbumScreen extends StatefulWidget {
// //   final String albumId;
// //   const ViewAlbumScreen({required this.albumId, Key? key}) : super(key: key);

// //   @override
// //   State<ViewAlbumScreen> createState() => _ViewAlbumScreenState();
// // }

// // class _ViewAlbumScreenState extends State<ViewAlbumScreen> {
// //   final SupabaseClient _supabase = Supabase.instance.client;
// //   late Future<List<Map<String, dynamic>>> _mediaFuture;

// //   final String baseUrl =
// //       'https://wkwhjswjekqlugndxegl.supabase.co/storage/v1/object/public/media/';

// //   @override
// //   void initState() {
// //     super.initState();
// //     _mediaFuture = _fetchMedia();
// //     debugPrint('Fetching media for albumId: ${widget.albumId}');
// //   }

// //   Future<List<Map<String, dynamic>>> _fetchMedia() async {
// //     try {
// //       final res = await _supabase
// //           .from('media')
// //           .select()
// //           .eq('album_id', widget.albumId)
// //           .order('id');

// //       final mediaList = List<Map<String, dynamic>>.from(res);
// //       debugPrint('Fetched media: $mediaList');
// //       return mediaList;
// //     } catch (e) {
// //       debugPrint('Error fetching media: $e');
// //       rethrow;
// //     }
// //   }

// //   Future<void> _refreshMedia() async {
// //     setState(() {
// //       _mediaFuture = _fetchMedia();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("View Album"),
// //         backgroundColor: Colors.teal,
// //       ),
// //       body: RefreshIndicator(
// //         onRefresh: _refreshMedia,
// //         child: FutureBuilder<List<Map<String, dynamic>>>(
// //           future: _mediaFuture,
// //           builder: (context, snapshot) {
// //             if (snapshot.connectionState == ConnectionState.waiting) {
// //               return Center(child: CircularProgressIndicator());
// //             }

// //             if (snapshot.hasError) {
// //               return Center(child: Text("Error loading media: ${snapshot.error}"));
// //             }

// //             final media = snapshot.data ?? [];

// //             if (media.isEmpty) {
// //               return Center(
// //                 child: Text(
// //                   "No media found.",
// //                   style: TextStyle(fontSize: 18, color: Colors.grey),
// //                 ),
// //               );
// //             }

// //             return GridView.builder(
// //               padding: EdgeInsets.all(12),
// //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 2,
// //                 crossAxisSpacing: 10,
// //                 mainAxisSpacing: 10,
// //               ),
// //               itemCount: media.length,
// //               itemBuilder: (context, index) {
// //                 final item = media[index];
// //                 final isVideo = item['type'] == 'video';

// //                 // Prepend base URL if needed
// //                 final String imageUrl = '$baseUrl${item['file_url']}';

// //                 return Card(
// //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                   elevation: 3,
// //                   child: isVideo
// //                       ? Center(child: Icon(Icons.videocam, size: 40, color: Colors.teal))
// //                       : ClipRRect(
// //                           borderRadius: BorderRadius.circular(12),
// //                           child: Image.network(
// //                             imageUrl,
// //                             fit: BoxFit.cover,
// //                             width: double.infinity,
// //                             height: double.infinity,
// //                             errorBuilder: (context, error, stackTrace) {
// //                               return Center(child: Icon(Icons.error, color: Colors.red));
// //                             },
// //                           ),
// //                         ),
// //                 );
// //               },
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //  }
// //}
// // class ViewAlbumScreen extends StatefulWidget {
// //   const ViewAlbumScreen({super.key, required String albumId});

// //   @override
// //   _ViewAlbumScreenState createState() => _ViewAlbumScreenState();
// // }

// // class _ViewAlbumScreenState extends State<ViewAlbumScreen> {
// //   List<Map<String, dynamic>> media = [];
// //   bool _isLoading = true;

// //   Future<void> _fetchMedia(Map<String, dynamic> album) async {
// //     setState(() => _isLoading = true);
// //     final response = await Supabase.instance.client
// //         .from('media')
// //         .select()
// //         .eq('album_id', album['id']);
// //     setState(() {
// //       media = List<Map<String, dynamic>>.from(response);
// //       _isLoading = false;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final album = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(album['title']),
// //       ),
// //       body: FutureBuilder(
// //         future: _fetchMedia(album),
// //         builder: (context, snapshot) {
// //           if (_isLoading) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //           if (media.isEmpty) {
// //             return const Center(child: Text('No media in this album'));
// //           }
// //           return GridView.builder(
// //             padding: const EdgeInsets.all(8.0),
// //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //               crossAxisCount: 2,
// //               crossAxisSpacing: 8.0,
// //               mainAxisSpacing: 8.0,
// //               childAspectRatio: 1.0,
// //             ),
// //             itemCount: media.length,
// //             itemBuilder: (context, index) {
// //               final item = media[index];
// //               final url = Supabase.instance.client.storage
// //                   .from('media')
// //                   .getPublicUrl(item['file_path']);
// //               return Card(
// //                 elevation: 2,
// //                 child: item['file_type'] == 'image'
// //                     ? Image.network(
// //                         url,
// //                         fit: BoxFit.cover,
// //                         errorBuilder: (context, error, stackTrace) =>
// //                             const Icon(Icons.error, size: 50, color: Colors.red),
// //                       )
// //                     : VideoPlayerWidget(videoUrl: url),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }


// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';

// // class ViewAlbumScreen extends StatelessWidget {
// //   final String albumId;
// // //<<<<<<< HEAD

// //   const ViewAlbumScreen({required this.albumId, super.key});
// // //>>>>>>> 7c427a9f8915ce9afcf1b141f060b04009afd099

// //   const ViewAlbumScreen.namedConstructor({Key? key, required this.albumId}) : super(key: key);

// //  Future<List<Map<String, dynamic>>> _fetchMedia() async {
// //   final response = await Supabase.instance.client
// //       .from('media')
// //       .select()
// //       .eq('album_id', albumId); // Make sure albumId is not null

// //   return List<Map<String, dynamic>>.from(response);
// // }


// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('View Album'),
// //       ),
// //       body: FutureBuilder<List<Map<String, dynamic>>>(
// //         future: _fetchMedia(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //             return const Center(child: Text('No media found.'));
// //           }

// //           final mediaList = snapshot.data!;

// //           return ListView.builder(
// //             itemCount: mediaList.length,
// //             itemBuilder: (context, index) {
// //               final media = mediaList[index];
// //               final type = media['type'] as String;
// //               final url = media['file_url'] as String;

// //               return ListTile(
// //                 leading: type == 'image'
// //                     ? Image.network(url, width: 50, height: 50)
// //                     : const Icon(Icons.videocam),
// //                 title: Text(url.split('/').last),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tour_guide_application/widgets/vedio_palyer_widget.dart';

// class ViewAlbumScreen extends StatefulWidget {
//   final String albumId;

//   const ViewAlbumScreen({Key? key, required this.albumId}) : super(key: key);

//   @override
//   State<ViewAlbumScreen> createState() => _ViewAlbumScreenState();
// }

// class _ViewAlbumScreenState extends State<ViewAlbumScreen> {
//   final SupabaseClient _supabase = Supabase.instance.client;
//   late Future<List<Map<String, dynamic>>> _mediaFuture;

//   final String baseUrl =
//       'https://wkwhjswjekqlugndxegl.supabase.co/storage/v1/object/public/media/';

//   @override
//   void initState() {
//     super.initState();
//     _mediaFuture = _fetchMedia();
//   }

//   Future<List<Map<String, dynamic>>> _fetchMedia() async {
//     final res = await _supabase
//         .from('media')
//         .select()
//         .eq('album_id', widget.albumId)
//         .order('id');

//     return List<Map<String, dynamic>>.from(res);
//   }

//   Future<void> _refreshMedia() async {
//     setState(() {
//       _mediaFuture = _fetchMedia();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("View Album"),
//         backgroundColor: Colors.teal,
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshMedia,
//         child: FutureBuilder<List<Map<String, dynamic>>>(
//           future: _mediaFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (snapshot.hasError) {
//               return Center(child: Text("Error loading media: ${snapshot.error}"));
//             }

//             final mediaList = snapshot.data ?? [];

//             if (mediaList.isEmpty) {
//               return const Center(
//                 child: Text("No media found.",
//                     style: TextStyle(fontSize: 18, color: Colors.grey)),
//               );
//             }

//             return GridView.builder(
//               padding: const EdgeInsets.all(12),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: mediaList.length,
//               itemBuilder: (context, index) {
//                 final item = mediaList[index];
//                 final isVideo = item['type'] == 'video';
//                 final filePath = item['file_url'];
//                 final mediaUrl = '$baseUrl$filePath';

//                 return Card(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   elevation: 3,
//                   child: isVideo
//                       ? VideoPlayerWidget(videoUrl: mediaUrl)
//                       : ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.network(
//                             mediaUrl,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 const Center(child: Icon(Icons.error, color: Colors.red)),
//                           ),
//                         ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tour_guide_application/widgets/vedio_palyer_widget.dart';

// class ViewAlbumScreen extends StatefulWidget {
//   final String albumId;

//   const ViewAlbumScreen({Key? key, required this.albumId}) : super(key: key);

//   @override
//   State<ViewAlbumScreen> createState() => _ViewAlbumScreenState();
// }

// class _ViewAlbumScreenState extends State<ViewAlbumScreen> {
//   final SupabaseClient _supabase = Supabase.instance.client;
//   late Future<List<Map<String, dynamic>>> _mediaFuture;

//   final String baseUrl =
//       'https://wkwhjswjekqlugndxegl.supabase.co/storage/v1/object/public/media/';

//   @override
//   void initState() {
//     super.initState();
//     _mediaFuture = _fetchMedia();
//   }

//   Future<List<Map<String, dynamic>>> _fetchMedia() async {
//     try {
//       final res = await _supabase
//           .from('media')
//           .select()
//           .eq('album_id', widget.albumId)
//           .order('id');

//       return List<Map<String, dynamic>>.from(res);
//     } catch (e) {
//       debugPrint('Error fetching media: $e');
//       rethrow;
//     }
//   }

//   Future<void> _refreshMedia() async {
//     setState(() {
//       _mediaFuture = _fetchMedia();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("View Album"),
//         backgroundColor: Colors.teal,
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshMedia,
//         child: FutureBuilder<List<Map<String, dynamic>>>(
//           future: _mediaFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (snapshot.hasError) {
//               return Center(child: Text("Error loading media: ${snapshot.error}"));
//             }

//             final media = snapshot.data ?? [];

//             if (media.isEmpty) {
//               return const Center(
//                 child: Text(
//                   "No media found.",
//                   style: TextStyle(fontSize: 18, color: Colors.grey),
//                 ),
//               );
//             }

//             return GridView.builder(
//               padding: const EdgeInsets.all(12),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: media.length,
//               itemBuilder: (context, index) {
//                 final item = media[index];
//                 final isVideo = item['type'] == 'video';
//                 final String mediaUrl = '$baseUrl${item['file_url']}';

//                 return Card(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   elevation: 3,
//                   child: isVideo
//                       ? VideoPlayerWidget(videoUrl: mediaUrl)
//                       : ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.network(
//                             mediaUrl,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             height: double.infinity,
//                             errorBuilder: (context, error, stackTrace) {
//                               return const Center(child: Icon(Icons.error, color: Colors.red));
//                             },
//                           ),
//                         ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewAlbumScreen extends StatefulWidget {
  final String albumId;
  const ViewAlbumScreen({Key? key, required this.albumId}) : super(key: key);

  @override
  State<ViewAlbumScreen> createState() => _ViewAlbumScreenState();
}

class _ViewAlbumScreenState extends State<ViewAlbumScreen> {
  late Future<List<Map<String, dynamic>>> _mediaFuture;

  @override
  void initState() {
    super.initState();
    _mediaFuture = _fetchMedia();
  }

  Future<List<Map<String, dynamic>>> _fetchMedia() async {
    final response = await Supabase.instance.client
        .from('media')
        .select()
        .eq('album_id', widget.albumId)
        .order('id');

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Album')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _mediaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));

          final media = snapshot.data ?? [];

          if (media.isEmpty)
            return Center(child: Text("No media found."));

          return GridView.builder(
            padding: EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: media.length,
            itemBuilder: (context, index) {
              final item = media[index];
              final isImage = item['type'] == 'image';
              final url = Supabase.instance.client.storage
                  .from('media')
                  .getPublicUrl(item['file_path']);

              return Card(
                child: isImage
                    ? Image.network(url, fit: BoxFit.cover)
                    : Center(child: Icon(Icons.videocam)),
              );
            },
          );
        },
      ),
    );
  }
}
