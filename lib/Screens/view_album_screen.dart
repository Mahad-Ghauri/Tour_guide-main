import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewAlbumScreen extends StatefulWidget {
  final String albumId;

  const ViewAlbumScreen({Key? key, required this.albumId}) : super(key: key);

  @override
  State<ViewAlbumScreen> createState() => _ViewAlbumScreenState();
}

class _ViewAlbumScreenState extends State<ViewAlbumScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _mediaFuture;

  @override
  void initState() {
    super.initState();
    _mediaFuture = _fetchMedia();
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

  Future<void> _refreshMedia() async {
    setState(() {
      _mediaFuture = _fetchMedia();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Album"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMedia,
            tooltip: 'Refresh Media',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshMedia,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _mediaFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Error loading media",
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshMedia,
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              );
            }

            final media = snapshot.data ?? [];

            if (media.isEmpty) {
              return const Center(
                child: Text(
                  "No media found.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: media.length,
              itemBuilder: (context, index) {
                final item = media[index];
                final isVideo = item['type'] == 'video';
                final fileUrl = item['file_url'];

                return Card(
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
                          child: const Center(
                            child: Icon(
                              Icons.videocam,
                              size: 40,
                              color: Colors.teal,
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
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),
                      if (isVideo)
                        const Positioned(
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}