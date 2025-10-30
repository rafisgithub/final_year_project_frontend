import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onVideoComplete;
  
  const SplashScreen({super.key, this.onVideoComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    // Hide system UI for fullscreen cinematic experience (like Marvel intro)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    _videoController = VideoPlayerController.asset('assets/video/ads.mp4')
      ..setLooping(false) // Don't loop - play once like a movie intro
      ..setVolume(1.0) // Enable sound for cinematic experience
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isVideoInitialized = true;
        });
        _videoController.play();
        
        // Listen for video completion to handle navigation
        _videoController.addListener(_checkVideoCompletion);
      }).catchError((error) {
        // If video fails to load, fallback after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            // Parent widget (Loading) will handle navigation
            setState(() {});
          }
        });
      });
  }

  void _checkVideoCompletion() {
    if (_videoController.value.position >= _videoController.value.duration) {
      // Video completed - notify parent widget
      if (mounted) {
        _videoController.removeListener(_checkVideoCompletion);
        widget.onVideoComplete?.call();
      }
    }
  }

  @override
  void dispose() {
    _videoController.removeListener(_checkVideoCompletion);
    _videoController.dispose();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background for cinematic feel
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fullscreen video player
          if (_isVideoInitialized)
            FittedBox(
              fit: BoxFit.cover, // Cover entire screen like movie intro
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          // Show nothing while loading - just black screen
        ],
      ),
    );
  }
}