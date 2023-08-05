import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myapp/animation/animation_demo.dart';
import 'package:myapp/busta_bit5/busta_bit_demo.dart';
import 'package:myapp/constant/constant.dart';
import 'package:myapp/remote_config/color_constant.dart';

import 'websocket/screenAngelWebSocket.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print(message.data.toString());
    print(message.notification!.title);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    // getFCM();
    super.initState();
  }

  // void getFCM() async {
  //   String? fcmToken = await FirebaseMessaging.instance.getToken();
  //   if (kDebugMode) {
  //     print("FCM Token : $fcmToken");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          dividerColor: Colors.transparent,
          // backgroundColor: Colors.white,
          // ignore: deprecated_member_use
          accentColorBrightness: Brightness.light,
          appBarTheme: AppBarTheme(
              backgroundColor:
                  _remoteConfig.getString('background_color').isNotEmpty
                      ? ColorConstant.fromHex(
                          _remoteConfig.getString('background_color'))
                      : primaryColor),
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor:
                  _remoteConfig.getString('background_color').isNotEmpty
                      ? ColorConstant.fromHex(
                          _remoteConfig.getString('background_color'))
                      : primaryColor,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: _remoteConfig.getString('background_color').isNotEmpty
                  ? ColorConstant.fromHex(
                      _remoteConfig.getString('background_color'))
                  : primaryColor)),
      home: const ScreenAngelWebSocket(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
