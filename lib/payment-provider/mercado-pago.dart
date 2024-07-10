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
      print('pasa por aca');
      _loadingSubscriptionToken = true;
      await controller.runJavascript(
          '''generateSubscriptionToken("$cardNumber", $expirationMonth, $expirationYear, "$securityCode", "$cardholderName")''');
      print('pasa por aca 2');
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
    print('pasa por aca 3');
    if (_loadingSubscriptionToken == true &&
        currentComunicationMilliseconds < maxComunicationMilliseconds) {
      currentComunicationMilliseconds++;
      return Future.delayed(
          const Duration(milliseconds: 100), _loadSubscriptionToken);
    } else if (_loadingSubscriptionToken == true &&
        currentComunicationMilliseconds >= maxComunicationMilliseconds) {
      throw _subscriptionTokenError = Exception('Timeout');
    }
    print('pasa por aca 4');
    if (_subscriptionToken == null) {
      print('pasa por aca 5');
      throw _subscriptionTokenError;
    }
    print('pasa por aca 6');
    return _subscriptionToken!;
  }
}
