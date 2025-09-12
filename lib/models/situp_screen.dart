// lib/situp_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../services/video_player-screen.dart';
 // Make sure this file exists

// IMPORTANT: Replace this with your computer's IP address!
const String serverIp = "http://10.65.107.114:8000";
const String serverUrl = "http://10.65.107.114:8000/predict_situp"; // URL specifically for sit-ups

class SitupUploadScreen extends StatefulWidget {
  const SitupUploadScreen({super.key});

  @override
  State<SitupUploadScreen> createState() => _SitupUploadScreenState();
}

class _SitupUploadScreenState extends State<SitupUploadScreen> {
  Map<String, dynamic>? _resultData;
  bool _isLoading = false;
  String _errorMessage = "";

  Future<void> _uploadVideo() async {
    final picker = ImagePicker();
    final XFile? videoFile = await picker.pickVideo(source: ImageSource.gallery);

    if (videoFile == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = "";
      _resultData = null;
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
      request.files.add(
        await http.MultipartFile.fromPath('file', videoFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() {
          _resultData = json.decode(response.body);
        });
      } else {
        setState(() {
          _errorMessage = "Error from server: ${response.statusCode}\n${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to connect to the server. Is it running at $serverIp?";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sit-up Counter'),
        backgroundColor: Colors.deepPurple[300],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Result Card
              if (_resultData != null)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                            'SIT-UP RESULT',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                        ),
                        const SizedBox(height: 16),
                        Text(
                            '${_resultData!['count']}',
                            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.deepPurple)
                        ),
                        Text(
                            'REPETITIONS',
                            style: TextStyle(fontSize: 16, color: Colors.grey[700], letterSpacing: 2)
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Detailed Analysis Button
              if (_resultData != null && _resultData!['processed_video_url'] != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.analytics_outlined),
                  label: const Text('View Detailed Analysis'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(
                          videoUrl: _resultData!['processed_video_url'],
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 40),

              // Loading indicator or the main Upload Button
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  onPressed: _uploadVideo,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Pick & Upload Video'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),

              // Error Message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}