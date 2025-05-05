import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

<<<<<<< HEAD
// class AlbumController extends ChangeNotifier {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   // Create album method
//   Future<String?> createAlbum({
//     required String name,
//     String? description,
//     required bool isPublic,
//   }) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final response = await _supabase.from('albums').insert({
//         'name': name,
//         'description': description,
//         'is_public': isPublic,
//         'created_by': _supabase.auth.currentUser!.id,
//       }).single();

//       if (response == null || response['id'] == null) {
//         debugPrint('Error creating album: Failed to retrieve album ID');
//         return null;
//       }

//       final albumId = response['id'] as String?;
//       debugPrint('Created album with ID: $albumId');
//       return albumId;
//     } catch (e) {
//       debugPrint('Error creating album: $e');
//       return null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Upload media method
//   Future<void> uploadMedia({
//     required String albumId,
//     required String type,
//     File? file,
//     Uint8List? webFile,
//   }) async {
//     try {
//       final ext = type == 'video' ? 'mp4' : 'jpg';
//       final filename = const Uuid().v4();
//       final path = 'media/$filename.$ext';

//       debugPrint('Uploading to storage: $path');
//       final bytes = file != null ? await file.readAsBytes() : webFile!;

//       // Upload the file to Supabase Storage
//       final storageResponse = await _supabase.storage.from('media').uploadBinary(path, bytes);
//       if (storageResponse.isEmpty) {
//         debugPrint('Error uploading file: Upload failed or returned an empty response');
//         return;
//       }

//       // Get the public URL of the uploaded file
//       final publicUrl = _supabase.storage.from('media').getPublicUrl(path);
//       debugPrint('Public URL: $publicUrl');

//       // Insert media record for the album
//       debugPrint('Inserting media record for albumId: $albumId');
//       final mediaResponse = await _supabase.from('media').insert({
//         'album_id': albumId,
//         'file_url': publicUrl,
//         'type': type,
//       });

//       if (mediaResponse.error != null) {
//         debugPrint('Error inserting media: ${mediaResponse.error?.message}');
//         return;
//       }

//       debugPrint('Media record inserted successfully');
//     } catch (e) {
//       debugPrint('Error uploading media: $e');
//       rethrow; // Allow caller to handle error
//     }
//   }
// }

class AlbumController with ChangeNotifier {
=======
class AlbumController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  
>>>>>>> b0558b231c5ab7b29e5618dfcbbd20374fe96968
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
<<<<<<< HEAD
  String? get errorMessage => _errorMessage;
=======
  
  // Fetch all albums for the current user
  Future<List<Map<String, dynamic>>> fetchUserAlbums() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];
      
      final res = await _supabase
          .from('albums')
          .select()
          .eq('created_by', userId)
          .order('created_at', ascending: false);
          
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint('Error fetching albums: $e');
      return [];
    }
  }
  
  // Fetch public albums
  Future<List<Map<String, dynamic>>> fetchPublicAlbums() async {
    try {
      final res = await _supabase
          .from('albums')
          .select()
          .eq('is_public', true)
          .order('created_at', ascending: false);
          
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint('Error fetching public albums: $e');
      return [];
    }
  }
>>>>>>> b0558b231c5ab7b29e5618dfcbbd20374fe96968

  // Create a new album
  Future<String?> createAlbum({
    required String name,
    required String description,
    required bool isPublic,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
<<<<<<< HEAD
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        _errorMessage = 'User not authenticated. Please log in.';
        return null;
      }

      final response = await Supabase.instance.client
          .from('albums')
          .insert({
            'user_id': user.id,
            'title': name,
            'description': description,
            'is_public': isPublic,
          })
          .select('id')
          .single();

      return response['id'] as String;
=======
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;
      
      final response = await _supabase.from('albums').insert({
        'name': name,
        'description': description,
        'is_public': isPublic,
        'created_by': userId,
      }).select('id').single();
      
      return response['id'] as String?;
>>>>>>> b0558b231c5ab7b29e5618dfcbbd20374fe96968
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Album creation error: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
<<<<<<< HEAD
}
=======
  
  // Upload media to an album
  Future<bool> uploadMedia({
    required String albumId,
    required String type,
    File? file,
    Uint8List? webFile,
  }) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Validate inputs
      if ((file == null && webFile == null) || 
          (type != 'image' && type != 'video')) {
        return false;
      }
      
      // Generate unique filename with appropriate extension
      final ext = type == 'video' ? 'mp4' : 'jpg';
      final filename = const Uuid().v4();
      final path = 'media/$filename.$ext';
      
      // Upload the file
      final bytes = file != null ? await file.readAsBytes() : webFile!;
      await _supabase.storage.from('media').uploadBinary(path, bytes);
      
      // Get the public URL
      final publicUrl = _supabase.storage.from('media').getPublicUrl(path);
      
      // Add record to the media table
      await _supabase.from('media').insert({
        'album_id': albumId,
        'file_url': publicUrl,
        'type': type,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error uploading media: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Delete a media item
  Future<bool> deleteMedia(String mediaId) async {
    try {
      // First get the media item to get the file path
      final media = await _supabase
          .from('media')
          .select('file_url')
          .eq('id', mediaId)
          .single();
          
      final fileUrl = media['file_url'] as String;
      
      // Extract the path from the URL
      final uri = Uri.parse(fileUrl);
      final pathSegments = uri.pathSegments;
      final storagePath = pathSegments.length > 1 ? 
          pathSegments.sublist(1).join('/') : '';
      
      if (storagePath.isNotEmpty) {
        // Delete the file from storage
        await _supabase.storage.from('media').remove([storagePath]);
      }
      
      // Delete the record from the database
      await _supabase.from('media').delete().eq('id', mediaId);
      return true;
    } catch (e) {
      debugPrint('Error deleting media: $e');
      return false;
    }
  }
  
  // Delete an album and all its media
  Future<bool> deleteAlbum(String albumId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // First get all media in this album
      final mediaItems = await _supabase
          .from('media')
          .select('id, file_url')
          .eq('album_id', albumId);
          
      // Delete each media file from storage
      for (final media in mediaItems) {
        final fileUrl = media['file_url'] as String;
        
        // Extract the path from the URL
        final uri = Uri.parse(fileUrl);
        final pathSegments = uri.pathSegments;
        final storagePath = pathSegments.length > 1 ? 
            pathSegments.sublist(1).join('/') : '';
        
        if (storagePath.isNotEmpty) {
          await _supabase.storage.from('media').remove([storagePath]);
        }
      }
      
      // Delete all media records for this album
      await _supabase.from('media').delete().eq('album_id', albumId);
      
      // Delete the album itself
      await _supabase.from('albums').delete().eq('id', albumId);
      
      return true;
    } catch (e) {
      debugPrint('Error deleting album: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
>>>>>>> b0558b231c5ab7b29e5618dfcbbd20374fe96968
