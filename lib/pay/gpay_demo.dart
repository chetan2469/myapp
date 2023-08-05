// ignore_for_file: avoid_print, deprecated_member_use

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/local_notification_service.dart';
import 'package:pay/pay.dart';
import 'package:url_launcher/url_launcher.dart';

class GPayDemo extends StatefulWidget {
  const GPayDemo({super.key});

  @override
  State<GPayDemo> createState() => _GPayDemoState();
}

class _GPayDemoState extends State<GPayDemo> {
  final paymentItems = <PaymentItem>[];

  late final LocalNotificationService service;
  @override
  void initState() {
    paymentItems.add(const PaymentItem(
        amount: "100",
        label: "Product 1",
        status: PaymentItemStatus.final_price));
    super.initState();

    service = LocalNotificationService();
    service.intialize();

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          if (message.data['_id'] != null) {}
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          service.showNotification(
            id: 1,
            title: message.notification!.title.toString(),
            body: message.notification!.body.toString(),
          );
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
          service.showNotification(
              id: 1,
              title: message.notification!.title.toString(),
              body: message.notification!.body.toString());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gpay")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GooglePayButton(
                paymentConfigurationAsset: 'gpay.json',
                onPaymentResult: (data) {
                  print(data);
                },
                paymentItems: paymentItems,
                type: GooglePayButtonType.plain),
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              String gpayUpiUrl =
                  'upi://pay?pa=gpay-11204804132@okbizaxis&pn=Chedo Tech&tn=Fees Payment&cu=INR';
              launch(gpayUpiUrl);
            },
            child: const Text("G-Pay UPI"),
          ),
          const SizedBox(
            height: 25,
          ),
          MaterialButton(
            color: Colors.deepPurple[700],
            onPressed: () {
              String money = '200.00';
              String phonePayUpi =
                  "upi://pay?pa=q64207433@ybl&pn=Chedo Tech&tn=Fees Payment&cu=INR&am=$money";
              launch(phonePayUpi);
            },
            child: const Text("Phone-Pay UPI"),
          ),
          GooglePayButton(
            paymentConfigurationAsset: JsonAssets.gpayAsset,
            paymentItems: paymentItems,
            onPaymentResult: onGooglePayResult,
            margin: const EdgeInsets.only(top: 15.0),
            width: double.maxFinite,
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  void onGooglePayResult(dynamic paymentResult) {
    debugPrint(paymentResult.toString());
  }
}

class JsonAssets {
  JsonAssets._();

  static const String gpayAsset = 'gpay.json';
}
