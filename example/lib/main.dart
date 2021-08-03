import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PusherClient? pusher;
  Channel? channel;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var options = PusherOptions(
        cluster: 'eu',
        auth: PusherAuth('http://localhost:3000/api/v1/auth/pusherauth',
            headers: {
              'Authorization': 'Insert bearer token',
            }),
      );

      pusher = PusherClient(
        'API_Key',
        options,
        enableLogging: true,
      );

      channel = pusher?.subscribe('testchannel');
      channel?.bind('test', (data) {
        print('HELLO TEST');
      });
      // .bind('event', (event) => log('event =>' + event.toString()));
      print('Init did not crash');
    } on PlatformException {
      print('PlatformException');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () {
              try {
                channel?.trigger('test');
              } catch (exc) {
                print('Trigger broke: ${exc.toString()}');
              }
            },
            child: Text('Trigger event'),
          ),
        ),
      ),
    );
  }
}
