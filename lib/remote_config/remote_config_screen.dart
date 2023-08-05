// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:myapp/remote_config/color_constant.dart';

class RemoteConfigScreen extends StatefulWidget {
  static const routeName = '/remotePage';
  const RemoteConfigScreen({Key? key}) : super(key: key);

  @override
  _RemoteConfigScreenState createState() => _RemoteConfigScreenState();
}

class _RemoteConfigScreenState extends State<RemoteConfigScreen> {
  final String _defaultAppTitle = "App Title";
  final String _defaultBackgroundColor = "#000";

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> _initConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    _fetchConfig();
  }

  void _fetchConfig() async {
    await _remoteConfig.fetchAndActivate();
  }

  @override
  void initState() {
    _initConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_remoteConfig.getString('app_title').isNotEmpty
            ? _remoteConfig.getString('app_title')
            : _defaultAppTitle),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 35,
          ),
          ClipPath(
            clipper: OvalTopBorderClipper(),
            child: Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorConstant.fromHex(
                    _remoteConfig.getString('background_color').isNotEmpty
                        ? _remoteConfig.getString('background_color')
                        : _defaultBackgroundColor),
              ),
              child: Center(
                  child: Text(
                _remoteConfig.getString('app_title').isNotEmpty
                    ? _remoteConfig.getString('app_title')
                    : _defaultAppTitle,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Text("ABC"),
      ),
      //     Container(
      //   alignment: Alignment.bottomCenter,
      //   // decoration: BoxDecoration(
      //   //   image: DecorationImage(
      //   //     image: NetworkImage(
      //   //       _remoteConfig.getString('background_image'),
      //   //     ),
      //   //     fit: BoxFit.cover,
      //   //   ),
      //   // ),
      //   child: ClipPath(
      //     clipper: OvalTopBorderClipper(),
      //     child: Container(
      //       height: 400,
      //       width: double.infinity,
      //       decoration: BoxDecoration(
      //         color: ColorConstant.fromHex(
      //             _remoteConfig.getString('background_color').isNotEmpty
      //                 ? _remoteConfig.getString('background_color')
      //                 : _defaultBackgroundColor),
      //       ),
      //       child: Center(
      //           child: Text(
      //         _remoteConfig.getString('app_title').isNotEmpty
      //             ? _remoteConfig.getString('app_title')
      //             : _defaultAppTitle,
      //         style: const TextStyle(
      //             color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      //       )),
      //     ),
      //   ),
      // ),
    );
  }
}
