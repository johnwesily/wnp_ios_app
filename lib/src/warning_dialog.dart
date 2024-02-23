import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import './web_view_stack.dart';
//
// class WarningDialog extends StatelessWidget {
//   final String warningMessage;
//   final String url;
//   final WebViewController controller;
//
//   const WarningDialog({
//     Key? key,
//     required this.warningMessage,
//     required this.url,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(warningMessage),
//       content: Text(
//         'Detected URL change to: $url. Do you want to continue?',
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             controller.loadUrl("/login"); // Adjust the login URL path as needed
//             Navigator.pop(context);
//           },
//           child: Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () async {
//             // Handle click on "Continue" (e.g., open the URL in browser, navigate within app)
//             print('Continuing...');
//             Navigator.pop(context);
//             if (await canLaunch(url)) {
//             await launch(url);
//             }
//           },
//           child: Text('Continue'),
//         ),
//       ],
//     );
//   }
// }


class WarningDialog extends StatelessWidget {
  final String warningMessage;
  final String url;
  final WebViewController controller;

  const WarningDialog({
    Key? key,
    required this.warningMessage,
    required this.url,
    required this.controller,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
     String baseUrl = dotenv.env['WEB_APP_URL'] ?? '';

    return AlertDialog(
      title: Text(warningMessage),
      content: Text(
        'Detected URL change to: $url. Do you want to continue?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Cancel: Redirect back to /login in WebView
            controller.loadRequest(
              Uri.parse(baseUrl),
            );
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // Handle click on "Continue" (e.g., open the URL in browser, navigate within app)
            print('Continuing...');
            Navigator.pop(context);
            if (await canLaunch(url)) {
              await launch(url);
            }
          },
          child: Text('Continue'),
        ),
      ],
    );
  }
}

