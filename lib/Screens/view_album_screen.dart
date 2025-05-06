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
  bool _isLoading = true;
  String? _errorMessage;
  String? _albumName;

  @override
  void initState() {
    super.initState();
    print('Album ID received in ViewAlbumScreen: "${widget.albumId}"'); // Debug: Log albumId
    _initializeData();
  }

  void _initializeData() {
    // Validate albumId
    if (widget.albumId.trim().isEmpty) {
      print('Error: albumId is empty');
      setState(() {
        _isLoading = false;
        _errorMessage = "Invalid album ID: ID is empty.";
      });
      return;
    }

    // Basic UUID format validation
    final uuidPattern = RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
    if (!uuidPattern.hasMatch(widget.albumId)) {
      print('Error: albumId does not match UUID format: ${widget.albumId}');
      setState(() {
        _isLoading = false;
        _errorMessage = "Invalid album ID: Not a valid UUID.";
      });
      return;
    }

    _fetchAlbumDetails();
    _mediaFuture = _fetchMedia();
  }

  Future<void> _fetchAlbumDetails() async {
    try {
      final albumResponse = await _supabase
          .from('albums')
          .select('name, is_public, created_by')
          .eq('id', widget.albumId)
          .single();

      print('Album response: $albumResponse'); // Debug: Check response

      if (albumResponse.isEmpty) {
        setState(() {
          _errorMessage = "Album not found.";
        });
        return;
      }

      final isPublic = albumResponse['is_public'] as bool;
      final createdBy = albumResponse['created_by'] as String;
      final currentUserId = _supabase.auth.currentUser?.id;

      if (currentUserId == null) {
        setState(() {
          _errorMessage = "User not authenticated. Please log in.";
        });
        return;
      }

      if (!isPublic && createdBy != currentUserId) {
        setState(() {
          _errorMessage = "You do not have permission to view this album.";
        });
        return;
      }

      setState(() {
        _albumName = albumResponse['name'];
      });
    } catch (e) {
      debugPrint('Error fetching album details: $e');
      setState(() {
        _errorMessage = "Failed to load album details: $e";
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchMedia() async {
    try {
      final response = await _supabase
          .from('media')
          .select('id, file_url, type, created_at')
          .eq('album_id', widget.albumId)
          .order('created_at', ascending: false);

      print('Media response: $response'); // Debug: Check response

      setState(() {
        _isLoading = false;
      });

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching media: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load media: $e";
      });
      return [];
    }
  }

  Future<void> _refreshMedia() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _fetchAlbumDetails();
    _mediaFuture = _fetchMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _albumName ?? "View Album",
          style: const TextStyle(color: Colors.white), // Set font color to white
        ),
        backgroundColor: const Color(0xFF559CB2), // Match logo screen background color
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Set arrow color to white
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white), // Set icon color to white
            onPressed: _refreshMedia,
            tooltip: 'Refresh Media',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF559CB2), // Match logo screen background color
                foregroundColor: Colors.white, // Set font color to white
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Go Back"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade100,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Try Again"),
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
                  const Text(
                    "No media found in this album.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshMedia,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade100,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              final mediaId = item['id'];

              return GestureDetector(
                onTap: () => _onMediaTap(context, item),
                child: Hero(
                  tag: 'media_$mediaId',
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
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress.expectedTotalBytes ?? 1)
                                        : null,
                                    color: Colors.teal,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint('Image error: $error');
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
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _onMediaTap(BuildContext context, Map<String, dynamic> media) {
    final isVideo = media['type'] == 'video';
    final fileUrl = media['file_url'];
    final mediaId = media['id'];

    if (isVideo) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VideoViewerScreen(
            videoUrl: fileUrl,
            mediaId: mediaId,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ImageViewerScreen(
            imageUrl: fileUrl,
            mediaId: mediaId,
          ),
        ),
      );
    }
  }
}

class ImageViewerScreen extends StatelessWidget {
  final String imageUrl;
  final String mediaId;

  const ImageViewerScreen({
    Key? key,
    required this.imageUrl,
    required this.mediaId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Image', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Hero(
          tag: 'media_$mediaId',
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                    color: Colors.teal,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class VideoViewerScreen extends StatelessWidget {
  final String videoUrl;
  final String mediaId;

  const VideoViewerScreen({
    Key? key,
    required this.videoUrl,
    required this.mediaId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Video', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Hero(
          tag: 'media_$mediaId',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.videocam,
                color: Colors.white,
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                'Video Player',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                'Add video_player package for full implementation',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(height: 20),
              Text(
                'URL: $videoUrl',
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}