import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KushkiService {
  KushkiService(
    this.maxComunicationMilliseconds,
  );

  late WebViewController controller;
  String? _chargeToken;
  bool _loadingChargeToken = false;
  Exception _chargeTokenError = Exception('Error');
  int currentComunicationMilliseconds = 0;
  int maxComunicationMilliseconds;

  Future<String> getDeviceToken(String subscriptionId) async {
    try {
      currentComunicationMilliseconds = 0;
      _loadingChargeToken = true;
      await controller.runJavascript(
          '''requestSubscriptionDeviceToken("$subscriptionId")''');
      var token = await _loadChargeToken();
      _chargeToken = null;
      return token;
    } on Exception catch (exception) {
      log('''[KushkiService]: Couldn't get card subscription token - $exception.''');
      _loadingChargeToken = false;
      rethrow;
    }
  }

  void setChargeToken(String token) {
    _chargeToken = token;
    _loadingChargeToken = false;
  }

  void setChargeTokenError(Exception error) {
    _chargeTokenError = error;
    _loadingChargeToken = false;
  }

  Future<String> _loadChargeToken() async {
    if (_loadingChargeToken == true &&
        currentComunicationMilliseconds < maxComunicationMilliseconds) {
      currentComunicationMilliseconds++;
      // if (Platform.isIOS) {
      //   unawaited(controller.runJavascript('''wakeUpJavascriptChannel()'''));
      // }
      return Future.delayed(
          const Duration(milliseconds: 100), _loadChargeToken);
    } else if (_loadingChargeToken == true &&
        currentComunicationMilliseconds >= maxComunicationMilliseconds) {
      throw _chargeTokenError = Exception('Timeout');
    }

    if (_chargeToken == null) {
      throw _chargeTokenError;
    }
    return _chargeToken!;
  }
}

final kushkiService = Provider((ref) => KushkiService(550));
