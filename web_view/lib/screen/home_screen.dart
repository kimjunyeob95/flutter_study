import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

final homeUrl = Uri.parse("https://github.com/kimjunyeob95");

class HomeScreen extends StatelessWidget {
  WebViewController controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..loadRequest(homeUrl);

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('Junyeob Github'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  controller.loadRequest(homeUrl);
                },
                icon: Icon(Icons.home))
          ],
        ),
        body: SafeArea(
          child: WebViewWidget(
            controller: controller,
          ),
        ));
  }
}
