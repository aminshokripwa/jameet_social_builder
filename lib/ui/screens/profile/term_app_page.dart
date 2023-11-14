// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables
//https://github.com/bahrie127/flutter_webview4_example/tree/master
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:jameet_social_builder/localization_helper.dart';

class TermAppPage extends StatefulWidget {
  const TermAppPage({Key? key}) : super(key: key);

  @override
  State<TermAppPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<TermAppPage> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(LanguageJameet.link_terms_of_use));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(LanguageJameet.terms_of_use),
          actions: const [],
        ),
        body: WebViewWidget(controller: _controller!));
  }
}