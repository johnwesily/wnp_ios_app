import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WarningScreen extends StatelessWidget {
  final String warningMessage;
  final String url;

  const WarningScreen({super.key,
    required this.warningMessage,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Warning'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5.0,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    'Thanks for your interest in WannaPractice! Here\'s the process for using WannaPractice with your iOS device:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  const Text("follow this link to register for the content you want:",
                      style: TextStyle(color: Colors.black),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child:InkWell( // Use InkWell for tap functionality
                      onTap: () async {
                        if (await canLaunch('https://app.wannapractice.com/signup')) {
                          await launch('https://app.wannapractice.com/signup');
                        } else {
                          throw 'Could not launch https://app.wannapractice.com/signup';
                        }
                      },
                      child: const Text(
                        'https://app.wannapractice.com/signup',
                        style: TextStyle(color: Colors.blue),

                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'set up your account and subscribe to the content of your choice',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'run the WannaPractice app from your iOS device; you may have to login again with your credentials the first time you use the app after registration',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'enjoy the app and learn what you need to know to pass the exam!',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell( // Use InkWell for tap functionality
                    onTap: () async {
                      if (await canLaunch('mailto:support@wannapractice.com')) {
                        await launch('mailto:support@wannapractice.com');
                      } else {
                        throw 'Could not launch mailto:support@wannapractice.com';
                      }
                    },
                    child: const Text(
                      'Any questions? Contact us at: support@wannapractice.com',
                      style:  TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF1f87b2), // Set background color
                onPrimary: Colors.white, // Set text color
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              onPressed: () async {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: const Text('Click here to SignUp Using Browser'),
            ),
          ],
        ),
      ),
    );
  }
}
