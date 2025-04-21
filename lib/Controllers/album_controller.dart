import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AlbumController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Method for mobile (File-based image)
  Future<void> createAlbumWithPhoto({
    required String name,
    String? description,
    required bool isPublic,
    required File imageFile,
  }) async {
    final imageBytes = await imageFile.readAsBytes();
    final fileExt = imageFile.path.split('.').last;
    final fileName = const Uuid().v4();
    final filePath = 'albums/$fileName.$fileExt';

    await _uploadAndInsert(
      name: name,
      description: description,
      isPublic: isPublic,
      imageBytes: imageBytes,
      filePath: filePath,
    );
  }

  // Method for web (Uint8List-based image)
  Future<void> createAlbumWithWebImage({
    required String name,
    String? description,
    required bool isPublic,
    required Uint8List imageBytes,
  }) async {
    final fileName = const Uuid().v4();
    final filePath = 'albums/$fileName.png'; // You can change format if needed

    await _uploadAndInsert(
      name: name,
      description: description,
      isPublic: isPublic,
      imageBytes: imageBytes,
      filePath: filePath,
    );
  }

  // Internal shared logic
  Future<void> _uploadAndInsert({
    required String name,
    String? description,
    required bool isPublic,
    required Uint8List imageBytes,
    required String filePath,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Upload to Supabase Storage
      final storageResponse = await _supabase.storage
          .from('photos')
          .uploadBinary(filePath, imageBytes, fileOptions: FileOptions(upsert: true));

      final publicUrl = _supabase.storage.from('photos').getPublicUrl(filePath);

      // Insert into Supabase table
      await _supabase.from('albums').insert({
        'name': name,
        'description': description,
        'is_public': isPublic,
        'photo_url': publicUrl,
      });

      debugPrint("Album created successfully.");
    } catch (e) {
      debugPrint("Error creating album: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
