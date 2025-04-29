import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AlbumController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String?> createAlbum({
    required String name,
    String? description,
    required bool isPublic,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase.from('albums').insert({
        'name': name,
        'description': description,
        'is_public': isPublic,
        'created_by': _supabase.auth.currentUser!.id,
      }).select('id').single();

      return response['id'] as String?;
    } catch (e) {
      debugPrint('Error creating album: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadMedia({
    required String albumId,
    required String type,
    File? file,
    Uint8List? webFile,
  }) async {
    try {
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
      });
    } catch (e) {
      debugPrint('Error uploading media: $e');
    }
  }
}
