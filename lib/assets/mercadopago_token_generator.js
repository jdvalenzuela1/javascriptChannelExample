async function generateSubscriptionToken(cardNumber, expirationMonth, expirationYear, securityCode, cardholderName) {
    var cardData = {
    cardNumber: cardNumber,
    expirationMonth: expirationMonth,
    expirationYear: expirationYear,
    securityCode: securityCode,
    cardholderName: cardholderName,
  };
  try {
    const token = await MercadoPago.createCardToken(cardData);
    const resJsonString = `{ "token": "${token.id}" }`;
    MercadoPagoGenerateSubscriptionTokenSuccess.postMessage(resJsonString);
    return token;
  } catch (error) {
    const errorJsonString = `{ "code": "${response.code}", "error": "${response.error}", "message": "${response.message}" }`;
    MercadoPagoGenerateSubscriptionTokenFailure.postMessage(errorJsonString);
    return null;
  }
}
