import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import './warning_dialog.dart';
import './warning_screen.dart';


class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, super.key});

  final WebViewController controller;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;
  Timer? timer;
  String detectedUrl = '';


  @override
  void initState() {
    super.initState();
    widget.controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            // print("Page started: $url");
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onNavigationRequest: (navigation) async {
            // final host = Uri.parse(navigation.url).host;
            // print("Navigation Request: $navigation.url");

            final String url = navigation.url;
            final Uri hosturi = Uri.parse(url);

            // Now 'url' contains the full URL as a string, and 'uri' is a Uri object for further parsing if needed.
            final String host = hosturi.host;

            print("Navigation Request URL: $url");
            // print("Navigation Request Host: $host");

            if (host.contains('youtube.com')) {
              print("it is from inside the youtube $url ");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Blocking navigation to $host',
                  ),
                ),
              );
              return NavigationDecision.prevent;
            }

            final String signupUrl = dotenv.env['WEB_APP_URL'] ?? '';
            print(signupUrl);

            if (url == "$signupUrl/signup") {
              print("Detected the URL $signupUrl/signup");
              if (await canLaunch(url)) {
                await launch(url);
                return NavigationDecision.prevent; // Prevent the WebView from loading the URL
              }

              // Add your additional logic here if needed
            }

            if (url == "$signupUrl/test") {
              print("Detected the URL $signupUrl/test");
              if (await canLaunch(url)) {
                await launch(url);
                return NavigationDecision.prevent; // Prevent the WebView from loading the URL
              }

              // Add your additional logic here if needed
            }

            // if (url.contains("signup")) {
            //   print("Signup detected in the URL in the WebView");
            //   if (await canLaunchUrl(navigation.url as Uri)) {
            // await launchUrl(navigation.url as Uri);
            // return NavigationDecision.prevent;
            // }
            // }

            //dialog_box
            // timer ??= Timer.periodic(const Duration( seconds: 1), (_) async {
            //     final currentUrl = await widget.controller.currentUrl();
            //     if (currentUrl != null &&
            //         (currentUrl.endsWith("/signup") || currentUrl.endsWith("/test"))) {
            //       detectedUrl = currentUrl; // Store detected URL
            //       showDialog(
            //         context: context,
            //         builder: (context) => WarningDialog(
            //           warningMessage: 'Warning!',
            //           url: detectedUrl,
            //           controller: widget.controller,
            //         ),
            //       );
            //     }
            //   });


            //Screen
            timer ??= Timer.periodic(const Duration( milliseconds: 30), (_) async {
              final currentUrl = await widget.controller.currentUrl();
              if (currentUrl != null &&
                  (currentUrl.endsWith("/signup") || currentUrl.endsWith("/test"))) {
                detectedUrl = currentUrl;
                widget.controller.loadRequest(Uri.parse(signupUrl)); /// Store detected URL
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WarningScreen(
                      warningMessage: 'Warning!',
                      url: detectedUrl,
                    ),
                  ),
                );
              }

              if(currentUrl != null && ( currentUrl.endsWith("/account") ) ) {
                detectedUrl=currentUrl;
                widget.controller.loadRequest(Uri.parse('$signupUrl/account/ios'));
              }

              if(currentUrl != null && ( currentUrl.endsWith("/practice/subscribe_cert") ) ) {
                detectedUrl=currentUrl;
                widget.controller.loadRequest(Uri.parse('$signupUrl/practice/subscribe_cert/ios'));
              }

            });

            return NavigationDecision.navigate;
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      );

    @override
    void dispose() {
      timer?.cancel();
      super.dispose();
    }

  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: widget.controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}
