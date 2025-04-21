// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class Album {
//   final int? id;
//   final String name;
//   final String? description;
//   final bool isPublic;

//   Album({
//     this.id,
//     required this.name,
//     this.description,
//     required this.isPublic,
//   });

//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       id: json['id'] as int?,
//       name: json['name'] ?? '',
//       description: json['description'],
//       isPublic: json['is_public'] ?? false,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {'name': name, 'description': description, 'is_public': isPublic};
//   }
// }

// class AlbumController extends ChangeNotifier {
//   final SupabaseClient _supabase = Supabase.instance.client;
//   List<Album> _albums = [];
//   bool _isLoading = false;

//   List<Album> get albums => _albums;
//   bool get isLoading => _isLoading;

//   AlbumController() {
//     fetchAlbums();
//   }

//   Future<void> fetchAlbums() async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       final response = await _supabase
//           .from('albums')
//           .select()
//           .order('name', ascending: true);

//       if (response is List) {
//         _albums = response.map((data) => Album.fromJson(data)).toList();
//       } else {
//         _albums = [];
//       }
//     } catch (e) {
//       debugPrint('Error fetching albums: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> createAlbum(
//     String name, {
//     String? description,
//     required bool isPublic,
//   }) async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       final album = Album(
//         name: name,
//         description: description,
//         isPublic: isPublic,
//       );

//       await _supabase.from('albums').upsert(album.toMap());

//       await fetchAlbums();
//     } catch (e) {
//       debugPrint('Error storing album: $e');
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//   Future<void> addPhotoToAlbum(int albumId, String photoUrl) async {
//   try {
//     _isLoading = true;
//     notifyListeners();

//     await _supabase.from('photos').insert({
//       'album_id': albumId,
//       'photo_url': photoUrl,
//     });

//     // Optionally, refresh data or albums after adding photo
//     await fetchAlbums();
//   } catch (e) {
//     debugPrint('Error adding photo to album: $e');
//     rethrow;
//   } finally {
//     _isLoading = false;
//     notifyListeners();
//   }
// }

//   Future<void> deleteAlbum(int id) async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       await _supabase.from('albums').delete().eq('id', id);
//       await fetchAlbums();
//     } catch (e) {
//       debugPrint('Error deleting album: $e');
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
