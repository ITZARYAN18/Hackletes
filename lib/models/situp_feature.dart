import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:math';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MaterialApp(home: ModeSelectionScreen()));
}

// --- MODE SELECTION SCREEN ---
class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Input Mode'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Choose Your Workout Mode',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              _buildModeButton(
                context,
                'Use Front Camera',
                Icons.camera_front,
                    () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SitupCounterApp(cameraIndex: 1),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildModeButton(
                context,
                'Use Back Camera',
                Icons.camera_rear,
                    () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SitupCounterApp(cameraIndex: 0),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildModeButton(
                context,
                'Upload Video from Gallery',
                Icons.video_library,
                    () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
                  if (video != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VideoProcessingScreen(videoFile: video),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 250,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// --- VIDEO PROCESSING SCREEN ---
class VideoProcessingScreen extends StatefulWidget {
  final XFile videoFile;

  const VideoProcessingScreen({Key? key, required this.videoFile}) : super(key: key);

  @override
  _VideoProcessingScreenState createState() => _VideoProcessingScreenState();
}

class _VideoProcessingScreenState extends State<VideoProcessingScreen> {
  late VideoPlayerController _videoPlayerController;
  late PoseDetector _poseDetector;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
    _videoPlayerController = VideoPlayerController.file(File(widget.videoFile.path));
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      await _videoPlayerController.initialize();
      _videoPlayerController.setLooping(true);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _videoPlayerController.play();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error loading video: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              setState(() {
                if (_videoPlayerController.value.isPlaying) {
                  _videoPlayerController.pause();
                } else {
                  _videoPlayerController.play();
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
      )
          : Stack(
        children: <Widget>[
          Center(
            child: AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Video uploaded successfully!',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  VideoProgressIndicator(
                    _videoPlayerController,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.blue,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _poseDetector.close();
    super.dispose();
  }
}

// --- LIVE CAMERA SCREEN ---
class SitupCounterApp extends StatefulWidget {
  final int cameraIndex;

  const SitupCounterApp({Key? key, required this.cameraIndex}) : super(key: key);

  @override
  _SitupCounterAppState createState() => _SitupCounterAppState();
}

class _SitupCounterAppState extends State<SitupCounterApp> {
  CameraController? _controller;
  late PoseDetector _poseDetector;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
    _initializeCamera(widget.cameraIndex);
  }

  Future<void> _initializeCamera(int index) async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        if (cameras.isNotEmpty && index < cameras.length) {
          _controller = CameraController(
            cameras[index],
            ResolutionPreset.medium,
            enableAudio: false,
          );

          await _controller!.initialize();
          if (mounted) {
            setState(() {
              _isLoading = false;
            });

            // Start image stream for pose detection if needed
            // _controller!.startImageStream((CameraImage image) {
            //   _processCameraImage(image);
            // });
          }
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Camera not available at index: $index';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Camera permission not granted.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Camera initialization error: $e';
      });
    }
  }

  // Placeholder for future pose detection implementation
  // Future<void> _processCameraImage(CameraImage image) async {
  //   // Process camera frames here
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera ${widget.cameraIndex == 0 ? "(Back)" : "(Front)"}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
      )
          : Stack(
        children: <Widget>[
          CameraPreview(_controller!),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Camera ready for workout tracking',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    _poseDetector.close();
    super.dispose();
  }
}