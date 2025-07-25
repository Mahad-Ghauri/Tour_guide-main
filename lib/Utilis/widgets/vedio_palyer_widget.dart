// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// // Video Player Widget
// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;

//   const VideoPlayerWidget({super.key, required this.videoUrl});

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   VideoPlayerController? _controller;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//       ..initialize().then((_) {
//         setState(() {
//           _isInitialized = true;
//         });
//       }).catchError((error) {
//         setState(() {
//           _isInitialized = false;
//         });
//       });
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isInitialized || _controller == null) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         AspectRatio(
//           aspectRatio: _controller!.value.aspectRatio,
//           child: VideoPlayer(_controller!),
//         ),
//         IconButton(
//           icon: Icon(
//             _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//             color: Colors.white,
//             size: 50,
//           ),
//           onPressed: () {
//             setState(() {
//               if (_controller!.value.isPlaying) {
//                 _controller!.pause();
//               } else {
//                 _controller!.play();
//               }
//             });
//           },
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: use_super_parameters, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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