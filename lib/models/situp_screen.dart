import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// // IMPORTANT: Replace this with your computer's IP address!
const String serverIp = "10.65.107.114";
const String serverUrl = "http://10.65.107.114:8000/predict";
//
// void main() {
//   runApp(const FitnessApp());
// }
//
// class FitnessApp extends StatelessWidget {
//   const FitnessApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fitness Counter',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const UploadScreen(),
//     );
//   }
// }

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  int? _repCount;
  String _stage = "";
  bool _isLoading = false;
  String _errorMessage = "";

  Future<void> _uploadVideo() async {
    final picker = ImagePicker();
    final XFile? videoFile = await picker.pickVideo(source: ImageSource.gallery);

    if (videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No video selected.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = "";
      _repCount = null;
      _stage = "";
    });

    try {
      // 1. Create the multipart request
      var request = http.MultipartRequest('POST', Uri.parse(serverUrl));

      // 2. Add the file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // This key 'file' must match the FastAPI parameter name
          videoFile.path,
        ),
      );

      // 3. Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // 4. Handle the response
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        setState(() {
          _repCount = result['count'];
          _stage = result['stage'];
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Sit-Up Counter (Backend)'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display the result from the server
              if (_repCount != null)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text('Workout Result', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Text('$_repCount', style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                        Text('REPETITIONS', style: TextStyle(fontSize: 16, color: Colors.grey[700], letterSpacing: 2)),
                        const SizedBox(height: 8),
                        Text('(Final Stage: ${_stage.toUpperCase()})', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 40),

              // Show a loading spinner or the upload button
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  onPressed: _uploadVideo,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Pick & Upload Video'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),

              // Display any error messages
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