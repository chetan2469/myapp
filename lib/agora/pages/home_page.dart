// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePageNew extends StatefulWidget {
  const MyHomePageNew({super.key});

  @override
  _MyHomePageNewState createState() => _MyHomePageNewState();
}

class _MyHomePageNewState extends State<MyHomePageNew> {
  final _channelName = TextEditingController();
  String check = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.2,
                child: TextFormField(
                  controller: _channelName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    hintText: 'Channel Name',
                  ),
                ),
              ),
              TextButton(
                onPressed: () => onJoin(isBroadcaster: false),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      'Just Watch  ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(
                      Icons.remove_red_eye,
                    )
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.pink,
                ),
                onPressed: () => onJoin(isBroadcaster: true),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      'Broadcast    ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(Icons.live_tv)
                  ],
                ),
              ),
              Text(
                check,
                style: const TextStyle(color: Colors.red),
              )
            ],
          ),
        ));
  }

  Future<void> onJoin({required isBroadcaster}) async {
    await [Permission.camera, Permission.microphone].request();

    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => BroadcastPage(
    //       channelName: _channelName.text,
    //       isBroadcaster: isBroadcaster,
    //     ),
    //   ),
    // );
  }
}
