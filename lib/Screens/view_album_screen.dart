import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewAlbumScreen extends StatefulWidget {
  final String albumId;
  const ViewAlbumScreen({required this.albumId, super.key});

  @override
  State<ViewAlbumScreen> createState() => _ViewAlbumScreenState();
}

class _ViewAlbumScreenState extends State<ViewAlbumScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  late Future<Map<String, dynamic>> _albumFuture;
  late Future<List<Map<String, dynamic>>> _mediaFuture;
  
  @override
  void initState() {
    super.initState();
    _albumFuture = _fetchAlbumDetails();
    _mediaFuture = _fetchMedia();
  }

  Future<Map<String, dynamic>> _fetchAlbumDetails() async {
    try {
      final res = await _supabase
          .from('albums')
          .select()
          .eq('id', widget.albumId)
          .single();
      
      return Map<String, dynamic>.from(res);
    } catch (e) {
      debugPrint('Error fetching album details: $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> _fetchMedia() async {
    try {
      final res = await _supabase
          .from('media')
          .select()
          .eq('album_id', widget.albumId)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint('Error fetching media: $e');
      return [];
    }
  }

  void _refreshMedia() {
    setState(() {
      _mediaFuture = _fetchMedia();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: _albumFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading Album...");
            }
            final albumData = snapshot.data;
            return Text(albumData?['name'] ?? "View Album");
          },
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshMedia,
            tooltip: 'Refresh media',
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _mediaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Error loading media",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshMedia,
                    child: Text("Try Again"),
                  ),
                ],
              ),
            );
          }

          final media = snapshot.data ?? [];

          if (media.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_album_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No media found in this album",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemCount: media.length,
            itemBuilder: (context, index) {
              final item = media[index];
              final isVideo = item['type'] == 'video';
              final fileUrl = item['file_url'];

              return GestureDetector(
                onTap: () {
                  _showMediaDetail(context, item);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (isVideo)
                        Container(
                          color: Colors.black12,
                          child: Center(
                            child: Icon(
                              Icons.videocam, 
                              size: 40, 
                              color: Colors.teal
                            ),
                          ),
                        )
                      else
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            fileUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (isVideo)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showMediaDetail(BuildContext context, Map<String, dynamic> media) {
    final isVideo = media['type'] == 'video';
    final fileUrl = media['file_url'];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(isVideo ? 'Video' : 'Photo'),
              backgroundColor: Colors.teal,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: isVideo
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.videocam, size: 80, color: Colors.teal),
                            SizedBox(height: 16),
                            Text(
                              "Video playback not implemented",
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                              ),
                              onPressed: () {},
                              child: Text("Open Video URL"),
                            ),
                          ],
                        ),
                      )
                    : InteractiveViewer(
                        panEnabled: true,
                        boundaryMargin: EdgeInsets.all(20),
                        minScale: 0.5,
                        maxScale: 4,
                        child: Image.network(
                          fileUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.broken_image, color: Colors.red, size: 64),
                                  SizedBox(height: 16),
                                  Text("Failed to load image: $fileUrl"),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}