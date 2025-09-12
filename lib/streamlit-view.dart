import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StreamlitView extends StatefulWidget {
  const StreamlitView({super.key});

  @override
  State<StreamlitView> createState() => _StreamlitViewState();
}

class _StreamlitViewState extends State<StreamlitView> {
  late final WebViewController controller;

  // --- CHOOSE THE CORRECT URL ---
  // For an Android Emulator, use this IP to connect to your computer's localhost
  final String url = "http://10.0.2.2:8501";

  // For a REAL physical phone, find your computer's Wi-Fi IP and use it here
  // final String url = "http://10.65.107.114:8501";

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streamlit Analysis'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}