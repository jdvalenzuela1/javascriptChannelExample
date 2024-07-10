import 'dart:developer';

import 'package:webview_flutter/webview_flutter.dart';

class MercadoPagoService {
  MercadoPagoService(
    this.maxComunicationMilliseconds,
  );

  late WebViewController controller;
  String? _subscriptionToken;
  bool _loadingSubscriptionToken = false;
  Exception _subscriptionTokenError = Exception('Error');
  int currentComunicationMilliseconds = 0;
  int maxComunicationMilliseconds;

  Future<String> generateSubscriptionToken(
    String cardNumber,
    String expirationMonth,
    String expirationYear,
    String securityCode,
    String cardholderName,
  ) async {
    try {
      _loadingSubscriptionToken = true;
      await controller.runJavascript(
          '''generateSubscriptionToken("$cardNumber", $expirationMonth, $expirationYear, "$securityCode", "$cardholderName")''');
      var token = await _loadSubscriptionToken();
      _subscriptionToken = null;
      return token;
    } on Exception catch (exception) {
      log('''[MercadoPagoService]: Couldn't get subscription token - $exception.''');
      _loadingSubscriptionToken = false;
      rethrow;
    }
  }

  void setSubscriptionToken(String token) {
    _subscriptionToken = token;
    _loadingSubscriptionToken = false;
  }

  void setSubscriptionTokenError(Exception error) {
    _subscriptionTokenError = error;
    _loadingSubscriptionToken = false;
  }

  Future<String> _loadSubscriptionToken() async {
    if (_loadingSubscriptionToken == true &&
        currentComunicationMilliseconds < maxComunicationMilliseconds) {
      currentComunicationMilliseconds++;
      return Future.delayed(
          const Duration(milliseconds: 100), _loadSubscriptionToken);
    } else if (_loadingSubscriptionToken == true &&
        currentComunicationMilliseconds >= maxComunicationMilliseconds) {
      throw _subscriptionTokenError = Exception('Timeout');
    }
    if (_subscriptionToken == null) {
      throw _subscriptionTokenError;
    }
    return _subscriptionToken!;
  }
}
