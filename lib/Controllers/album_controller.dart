import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

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
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<String?> createAlbum({
    required String name,
    required String description,
    required bool isPublic,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
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
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Album creation error: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
