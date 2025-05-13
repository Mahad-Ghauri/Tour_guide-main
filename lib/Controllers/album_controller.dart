// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AlbumController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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

Future<String?> createAlbum({
  required String name,
  required String description,
  required bool isPublic,
}) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      _errorMessage = 'User not authenticated. Please log in.';
      print('Error: User not authenticated');
      return null;
    }

    final response = await _supabase.from('albums').insert({
      'name': name,
      'description': description,
      'is_public': isPublic,
      'created_by': userId,
    }).select('id').single();

    final albumId = response['id'] as String?;
    if (albumId == null) {
      _errorMessage = 'Failed to retrieve album ID after creation.';
      print('Error: Album ID is null after creation');
      return null;
    }

    print('Album created successfully with ID: $albumId');
    return albumId;
  } catch (e) {
    _errorMessage = e.toString();
    debugPrint('Album creation error: $e');
    return null;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  // Upload media to an album
  Future<bool> uploadMedia({
    required String albumId,
    required String type,
    File? file,
    Uint8List? webFile,
  }) async {
    if (albumId.isEmpty) {
      debugPrint('Error: albumId is empty');
      return false;
    }
    _isLoading = true;
    notifyListeners();

    try {
      if ((file == null && webFile == null) || (type != 'image' && type != 'video')) {
        return false;
      }

      final ext = type == 'video' ? 'mp4' : 'jpg';
      final filename = const Uuid().v4();
      final path = 'media/$filename.$ext';

      final bytes = file != null ? await file.readAsBytes() : webFile!;
      await _supabase.storage.from('media').uploadBinary(path, bytes);

      final publicUrl = _supabase.storage.from('media').getPublicUrl(path);

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
    if (mediaId.isEmpty) {
      debugPrint('Error: mediaId is empty');
      return false;
    }
    try {
      final media = await _supabase.from('media').select('file_url').eq('id', mediaId).single();
      final fileUrl = media['file_url'] as String;

      final uri = Uri.parse(fileUrl);
      final pathSegments = uri.pathSegments;
      final storagePath = pathSegments.length > 1 ? pathSegments.sublist(1).join('/') : '';

      if (storagePath.isNotEmpty) {
        await _supabase.storage.from('media').remove([storagePath]);
      }

      await _supabase.from('media').delete().eq('id', mediaId);
      return true;
    } catch (e) {
      debugPrint('Error deleting media: $e');
      return false;
    }
  }

  // Delete an album and all its media
  Future<bool> deleteAlbum(String albumId) async {
    if (albumId.isEmpty) {
      debugPrint('Error: albumId is empty');
      return false;
    }
    _isLoading = true;
    notifyListeners();

    try {
      final mediaItems = await _supabase.from('media').select('id, file_url').eq('album_id', albumId);

      for (final media in mediaItems) {
        final fileUrl = media['file_url'] as String;

        final uri = Uri.parse(fileUrl);
        final pathSegments = uri.pathSegments;
        final storagePath = pathSegments.length > 1 ? pathSegments.sublist(1).join('/') : '';

        if (storagePath.isNotEmpty) {
          await _supabase.storage.from('media').remove([storagePath]);
        }
      }

      await _supabase.from('media').delete().eq('album_id', albumId);
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
