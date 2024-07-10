 function generateSubscriptionToken(cardNumber, expirationMonth, expirationYear, securityCode, cardholderName) {
    var cardData = {
    cardNumber: cardNumber,
    expirationMonth: expirationMonth,
    expirationYear: expirationYear,
    securityCode: securityCode,
    cardholderName: cardholderName,
  };

  MercadoPago.createCardToken({
    cardData,
  }, (response) => {
    if (response.token) {
      const resJsonString = `{ "token": "${token.id}" }`;
      MercadoPagoGenerateSubscriptionTokenSuccess.postMessage(resJsonString);
    } else {
      const errorJsonString = `{ "code": "${response.code}", "error": "${response.error}", "message": "${response.message}" }`;
      MercadoPagoGenerateSubscriptionTokenFailure.postMessage(errorJsonString);
    }
  });
}
