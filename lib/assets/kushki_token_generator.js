function wakeUpJavascriptChannel() {
  DebbugingKushkiCommunication.postMessage();
}

function requestCardSubscriptionToken(name, number, cvc, expiryMonth, expiryYear, email) {
  const cardBin = number.substring(0, 6);
  const last4Digits = number.slice(-4);
  if (!kushki) return;
  kushki.requestSubscriptionToken({
    card: {
      name,
      number,
      cvc,
      expiryMonth,
      expiryYear,
    },
    currency: 'CLP',
  }, (response) => {
    if (response.token) {
      const resJsonString = `{ "token": "${response.token}", "name": "${name}", "email": "${email}" }`;
      CardSubscriptionSuccess.postMessage(resJsonString);
    } else {
      const errorResponse = {
        code: response.code,
        error: response.error,
        message: response.message,
        cardOwnerName: name,
        cardOwnerEmail: email,
        cardBin: cardBin,
        cardLast4Digits: last4Digits,
      };
      const errorJsonString = JSON.stringify(errorResponse);
      CardSubscriptionFailure.postMessage(errorJsonString);
    }
  });
}

function requestSubscriptionDeviceToken(subscriptionId) {
  var random = Math.floor(Math.random() * 1000000);
  if (!kushki) return;
  kushki.requestDeviceToken({
    subscriptionId,
  }, (response) => {

    if (response.token) {
      const resJsonString = `{ "token": "${response.token}", "random" : "${random}" }`;
      SubscriptionChargeSuccess.postMessage(resJsonString);
    } else {
      const errorJsonString = `{ "code": "${response.code}", "error": "${response.error}", "message": "${response.message}", "random" : "${random}" }`;
      SubscriptionChargeFailure.postMessage(errorJsonString);
    }
  });
}

function requestWebpayCardSubscriptionToken(userEmail) {
  if (!kushki) return;
  kushki.requestSubscriptionCardAsyncToken({
    currency: 'CLP',
    email: userEmail,
    callbackUrl: 'https://simplepark.cl/'
  }, (response) => {
    if (response.token) {
      WebpayCardSuscriptionTokenSuccess.postMessage(response.token);
    } else {
      const errorResponse = {
        code: response.code,
        error: response.error,
        message: response.message,
        cardOwnerEmail: userEmail,
      };
      const errorJsonString = JSON.stringify(errorResponse);
      WebpayCardSuscriptionTokenFailure.postMessage(errorJsonString);
    }
  });
}
