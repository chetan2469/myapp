// ignore_for_file: must_be_immutable, no_logic_in_create_state, unused_local_variable, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';

class WebViewSimple extends StatefulWidget {
  const WebViewSimple({super.key});

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}

class WebViewSimpleState extends State<WebViewSimple> {
  String checkoutUrl;
  String pageTitle;

  WebViewSimpleState(this.checkoutUrl, this.pageTitle);

  final CookieManager _cookieManager = CookieManager.instance();

  InAppWebViewController? _webViewController;

  String? title;
  String url = '';
  double progress = 0;
  bool isLoading = true;
  bool visible = true;
  bool isUrlLaunch = false;
  final expiresDate =
      DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    url = "https://app.delivermyuniform.com/PayBySagePay.html?txnId=93045";
    // getDataFromSharedPref();
  }

  String? userId = '';
  String? password = '';
  String? resp = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () async {
                  if (url.contains('forgotpassword')) {
                  } else if (url.contains("registerstaff") && userId == null) {
                  } else if (url.contains("registerstaff") && userId != null) {
                    Get.back();
                    Get.back();
                  } else {
                    Get.back();
                    Get.back();
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      _webViewController?.reload();
                    },
                    icon: const Icon(Icons.refresh))
              ],
              title: const Text(
                "widget.pageTitle",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black54,
            ),
            body: SafeArea(
                child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ModalProgressHUD(
                        inAsyncCall: visible,
                        child: InAppWebView(
                          initialUrlRequest: URLRequest(url: Uri.parse(url)),
                          initialOptions: InAppWebViewGroupOptions(
                              android: AndroidInAppWebViewOptions(
                                  disabledActionModeMenuItems:
                                      AndroidActionModeMenuItem.MENU_ITEM_NONE),
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
                                  useOnLoadResource: true)),
                          onWebViewCreated:
                              (InAppWebViewController controller) {
                            _webViewController = controller;
                          },
                          onLoadStart: (InAppWebViewController? controller,
                              Uri? url) async {
                            var preferences =
                                await SharedPreferences.getInstance();
                            // var sessionId =
                            //     preferences.getString((AppConstant.COOKIEID));

                            _cookieManager.setCookie(
                                url: url!,
                                name: "PHPSESSID",
                                value: "sessionId",
                                domain: ".",
                                expiresDate: expiresDate);
                            setState(() {
                              this.url = url.toString();
                              visible = false;
                            });
                          },
                          onLoadError: (controller, url, code, message) {},
                          onLoadStop: (
                            InAppWebViewController controller,
                            Uri? url,
                          ) async {
                            var preferences =
                                await SharedPreferences.getInstance();
                            // var sessionId =
                            //     preferences.getString((AppConstant.COOKIEID));

                            _cookieManager.setCookie(
                                url: url!,
                                name: "PHPSESSID",
                                value: "sessionId",
                                domain: ".",
                                expiresDate: expiresDate);

                            setState(() {
                              visible = false;
                            });
                          },
                          onDownloadStart: (controller, Uri url) async {
                            print("onDownloadStart $url");
                            final taskId = await FlutterDownloader.enqueue(
                              url: url.toString(),
                              savedDir:
                                  (await getExternalStorageDirectory())!.path,
                              showNotification:
                                  true, // show download progress in status bar (for Android)
                              openFileFromNotification:
                                  true, // click on notification to open downloaded file (for Android)
                            );
                          },
                          onProgressChanged: (InAppWebViewController controller,
                              int progress) {
                            setState(() {
                              this.progress = progress / 100;
                              if (progress > 20) {
                                setState(() {
                                  controller.evaluateJavascript(
                                      source:
                                          "document.getElementsByClassName('navbar navbar-inverse navbar-fixed-top')[0].style.display='none',document.getElementsByClassName('heading')[0].style.display='none'");
                                });
                              }
                              visible = false;
                            });
                          },
                          onUpdateVisitedHistory:
                              (controller, url, androidIsReload) {
                            setState(() {
                              this.url = url.toString();
                              //   urlController.text = this.url;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ))),
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
      Get.back();
      return true;
    }
  }
}
