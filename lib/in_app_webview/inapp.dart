// ignore_for_file: deprecated_member_use
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class InAppWbDemo extends StatefulWidget {
  const InAppWbDemo({super.key});

  @override
  State<InAppWbDemo> createState() => _InAppWbDemoState();
}

class _InAppWbDemoState extends State<InAppWbDemo> {
  InAppWebViewController? _webViewController;
  String url = '';

  @override
  void initState() {
    super.initState();
    url = "https://app.delivermyuniform.com/PayBySagePay.html?txnId=93045";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(url)),
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  allowContentAccess: true,
                  disabledActionModeMenuItems:
                      AndroidActionModeMenuItem.MENU_ITEM_NONE,
                ),
                ios: IOSInAppWebViewOptions(
                  disableLongPressContextMenuOnLinks: true,
                  allowsInlineMediaPlayback: true,
                  allowsLinkPreview: true,
                ),
                crossPlatform: InAppWebViewOptions(
                  disableContextMenu: true,
                  disableHorizontalScroll: false,
                  supportZoom: true,
                  useOnDownloadStart: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                  useOnLoadResource: true,
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onLoadStart:
                  (InAppWebViewController? controller, Uri? url) async {
                setState(() {
                  this.url = url.toString();
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                });
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                if (kDebugMode) {
                  print(navigationAction.request.url);
                }
                if (navigationAction.request.url
                    .toString()
                    .contains("PaymentFailure")) {
                  if (kDebugMode) {
                    print("payment Cancel");
                  }
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _exitApp() async {
    bool go = await _webViewController!.canGoBack();
    if (go) {
      _webViewController!.goBack();
      return false;
    } else {
      Get.back();
      return true;
    }
  }
}
