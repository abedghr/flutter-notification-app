import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  // Handle background messages
  print('Background message received: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String? token = await FirebaseMessaging.instance.getToken();
  print("Device Token: $token");
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  // Request notification permissions on iOS
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Messaging',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received: ${message.notification?.title}');
      // Show a dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message.notification?.title ?? 'No Title'),
            content: Text(message.notification?.body ?? 'No Body'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });

    // Handle token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('New token: $newToken');
      // Save the new token if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase Messaging'),
      ),
      body: Center(
        child: Text('Listening for Firebase messages'),
      ),
    );
  }
}
