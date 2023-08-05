import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// https://smartapi.angelbroking.com/docs/WebSocketStreaming
class ScreenAngelWebSocket extends StatefulWidget {
  const ScreenAngelWebSocket({Key? key}) : super(key: key);
  @override
  State<ScreenAngelWebSocket> createState() => _ScreenAngelWebSocketState();
}

class _ScreenAngelWebSocketState extends State<ScreenAngelWebSocket> {
  WebSocketChannel? channel;
  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse(
          'wss://omnefeeds.angelbroking.com/NestHtml5Mobile/socket/stream'),
    );
    channel!.sink.add(
      jsonEncode({
        "task": "cn",
        "channel": "",
        "token": "feed_token",
        "user": "client_id",
        "acctid": "client_id"
      }),
    );
    channel!.sink.add(
      jsonEncode({
        "task": "mw",
        // "channel": "nse_cm|3045", // Single script
        "channel":
            "nse_cm|3045&nse_cm|2885", // Multiple script Here, I've used SBI & Reliance
        "token": "feed_token",
        "user": "client_id",
        "acctid": "client_id"
      }),
    );
    channel!.stream.listen(
      (data) {
        String response = data.toString();
        debugPrint('wss Response before Decode: $response');
        var step1 = base64.decode(response);
        debugPrint('wss Response Decode Step 1: $step1');
        var inflated = zlib.decode(step1);
        var step2 = utf8.decode(inflated);
        debugPrint('wss Response Decode Step 2: $step2');
        var step3 = json.decode(step2);
        debugPrint('wss Response Decode Step 3: $step3');
      },
      onDone: () {
        debugPrint('wss Socket Connected');
      },
      onError: (error) => debugPrint('wss Error: $error'),
    );
  }

  @override
  void dispose() {
    super.dispose();
    channel!.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Web Socket Demo'),
          ],
        ),
      ),
    );
  }
}
