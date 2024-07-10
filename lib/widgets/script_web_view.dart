import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:javascript_channel_example/payment-provider/kushki.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScriptWebView extends ConsumerStatefulWidget {
  const ScriptWebView({super.key});

  @override
  ConsumerState<ScriptWebView> createState() => _ScriptWebViewState();
}

class _ScriptWebViewState extends ConsumerState<ScriptWebView> {
  @override
  Widget build(BuildContext context) => Visibility(
        visible: false,
        maintainState: true,
        child: SizedBox(
          width: 1,
          height: 1,
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (webViewController) async {
              await webViewController
                  .loadFlutterAsset('lib/assets/kushki_token_dev.html');
              ref.read(kushkiService).controller = webViewController;
            },
            javascriptChannels: {
              JavascriptChannel(
                name: 'SubscriptionChargeSuccess',
                onMessageReceived: (message) {
                  var response = json.decode(message.message);
                  var mappedJson = Map<String, dynamic>.from(response);
                  ref.read(kushkiService).setChargeToken(mappedJson['token']);
                },
              ),
              JavascriptChannel(
                name: 'SubscriptionChargeFailure',
                onMessageReceived: (message) {
                  var jsonError = json.decode(message.message);
                  var error = Exception(jsonError);
                  ref.read(kushkiService).setChargeTokenError(error);
                },
              ),
              JavascriptChannel(
                name: 'DebbugingKushkiCommunication',
                onMessageReceived: (_) {},
              ),
            },
          ),
        ),
      );
}
