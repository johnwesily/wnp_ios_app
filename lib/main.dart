import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'src/web_view_stack.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    String baseUrl = dotenv.env['WEB_APP_URL'] ?? '';

    WebViewCookie cookie = WebViewCookie(
      name: "X-From-Webview=",
      value: "true",
      domain: baseUrl, // Set the domain appropriately
    );

    controller = WebViewController();

    WebViewCookieManager().setCookie(cookie);

    controller.loadRequest(
      Uri.parse(baseUrl),
    );

    // controller.currentUrl().then((url) {
    //   print("URL changed to: $url");
    //   // You can also store the URL in a state variable here if needed
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewStack(controller: controller), // Use the WebViewStack widget here
    );
  }
}
