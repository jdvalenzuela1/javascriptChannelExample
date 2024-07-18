import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:javascript_channel_example/payment-provider/notifiers_injector.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class ScriptWebView extends ConsumerStatefulWidget {
  const ScriptWebView({super.key});

  @override
  ConsumerState<ScriptWebView> createState() => _ScriptWebViewState();
}

class _ScriptWebViewState extends ConsumerState<ScriptWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'KushkiLibraryFailure',
        onMessageReceived: (message) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Response'),
              content:
                  const Text('Hubo un error al cargar la librería de Kushki.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ).then((value) => Navigator.of(context).maybePop());
        },
      )
      ..addJavaScriptChannel(
        'SubscriptionChargeSuccess',
        onMessageReceived: (message) {
          var response = json.decode(message.message);
          var mappedJson = Map<String, dynamic>.from(response);
          ref.read(kushkiService).setChargeToken(mappedJson['token']);
        },
      )
      ..addJavaScriptChannel(
        'SubscriptionChargeFailure',
        onMessageReceived: (message) {
          var jsonError = json.decode(message.message);
          var error = Exception(jsonError);
          ref.read(kushkiService).setChargeTokenError(error);
        },
      )
      ..loadFlutterAsset('lib/assets/index.html');

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    _controller = controller;
    ref.read(kushkiService).controller = controller;
  }

  @override
  Widget build(BuildContext context) => Visibility(
        visible: false,
        maintainState: true,
        child: SizedBox(
          width: 1,
          height: 1,
          child: WebViewWidget(controller: _controller),
        ),
      );
}
