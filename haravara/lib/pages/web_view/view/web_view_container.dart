
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final String url;

  WebViewContainer({required this.url});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove default leading widget
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0.w), // Add some right padding
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  },
                icon: Icon(Icons.close,size:15.dg)),
          ),
        ],
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
