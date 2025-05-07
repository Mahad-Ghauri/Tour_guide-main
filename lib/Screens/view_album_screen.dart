import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_application/Controllers/album_controller.dart';
import 'package:video_player/video_player.dart';

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

class VideoViewerScreen extends StatefulWidget {
  final String videoUrl;
  final String mediaId;

  const VideoViewerScreen({
    Key? key,
    required this.videoUrl,
    required this.mediaId,
  }) : super(key: key);

  @override
  State<VideoViewerScreen> createState() => _VideoViewerScreenState();
}

class _VideoViewerScreenState extends State<VideoViewerScreen> {
  late VideoPlayerController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _controller.play(); // Auto-play the video
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load video: $error')),
        );
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : _controller.value.isInitialized
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.replay, color: Colors.white),
                            onPressed: () {
                              _controller.seekTo(Duration.zero);
                              _controller.play();
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 80,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Failed to load video',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class ViewAlbumScreen extends StatefulWidget {
  final String? albumId;

  const ViewAlbumScreen({Key? key, this.albumId}) : super(key: key);

  @override
  State<ViewAlbumScreen> createState() => _ViewAlbumScreenState();
}

class _ViewAlbumScreenState extends State<ViewAlbumScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _mediaFuture;
  late Future<List<Map<String, dynamic>>> _userAlbumsFuture;
  bool _isLoading = true;
  String? _errorMessage;
  String? _albumName;
  String? _selectedAlbumId;
  bool _showAlbumList = true;

  @override
  void initState() {
    super.initState();
    _selectedAlbumId = widget.albumId;
    _initializeData();
  }

  void _initializeData() {
    _userAlbumsFuture = context.read<AlbumController>().fetchUserAlbums();

    if (_selectedAlbumId != null) {
      _showAlbumList = false;
      _validateAndFetchAlbum();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _validateAndFetchAlbum() {
    if (_selectedAlbumId == null || _selectedAlbumId!.trim().isEmpty) {
      print('Error: albumId is empty');
      setState(() {
        _isLoading = false;
        _errorMessage = "Invalid album ID: ID is empty.";
      });
      return;
    }

    final uuidPattern = RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
    if (!uuidPattern.hasMatch(_selectedAlbumId!)) {
      print('Error: albumId does not match UUID format: $_selectedAlbumId');
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
          .eq('id', _selectedAlbumId!)
          .single();

      print('Album response: $albumResponse');

      if (albumResponse.isEmpty) {
        setState(() {
          _errorMessage = "Album not found.";
          _isLoading = false;
        });
        return;
      }

      final isPublic = albumResponse['is_public'] as bool;
      final createdBy = albumResponse['created_by'] as String?;
      final currentUserId = _supabase.auth.currentUser?.id;

      print('createdBy: $createdBy, currentUserId: $currentUserId');

      if (currentUserId == null) {
        setState(() {
          _errorMessage = "User not authenticated. Please log in.";
          _isLoading = false;
        });
        return;
      }

      if (!isPublic && (createdBy == null || createdBy != currentUserId)) {
        setState(() {
          _errorMessage = "You do not have permission to view this album.";
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _albumName = albumResponse['name'];
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching album details: $e');
      setState(() {
        _errorMessage = "Failed to load album details: $e";
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchMedia() async {
    try {
      final response = await _supabase
          .from('media')
          .select('id, file_url, type, created_at')
          .eq('album_id', _selectedAlbumId!)
          .order('created_at', ascending: false);

      print('Media response: $response');

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
          _albumName ?? "My Albums",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF559CB2),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (!_showAlbumList) {
              setState(() {
                _showAlbumList = true;
                _selectedAlbumId = null;
                _albumName = null;
                _errorMessage = null;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          if (!_showAlbumList)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _refreshMedia,
              tooltip: 'Refresh Media',
            ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userAlbumsFuture,
        builder: (context, albumSnapshot) {
          if (albumSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (albumSnapshot.hasError || albumSnapshot.data == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Error loading albums",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _userAlbumsFuture = context.read<AlbumController>().fetchUserAlbums();
                      });
                    },
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

          final albums = albumSnapshot.data!;
          if (albums.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "No albums found.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/create_album');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF559CB2),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Create an Album",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          if (_showAlbumList) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                final albumId = album['id'] as String;
                final albumName = album['name'] as String? ?? 'Unnamed Album';
                final isPublic = album['is_public'] as bool? ?? false;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.photo_album, color: Color(0xFF559CB2)),
                    title: Text(
                      albumName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      isPublic ? 'Public' : 'Private',
                      style: TextStyle(color: isPublic ? Colors.green : Colors.grey),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      setState(() {
                        _selectedAlbumId = albumId;
                        _showAlbumList = false;
                        _albumName = null;
                        _errorMessage = null;
                        _isLoading = true;
                        _validateAndFetchAlbum();
                      });
                    },
                  ),
                );
              },
            );
          }

          return _buildMediaContent();
        },
      ),
    );
  }

  Widget _buildMediaContent() {
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
            // Removed the "Go Back to Albums" button
            // User can use the app bar's back button to return to the album list
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